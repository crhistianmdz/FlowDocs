# Documento de Especificaciones de Producto (PRD) y Diseño de Software (SDD)
**Proyecto:** Sistema de Traducción Académica Local (STAL)
**Plataforma Objetivo:** Entornos Linux optimizados para baja latencia (CachyOS)
**Fecha de Revisión:** Abril 2026

---

## 1. Visión General del Sistema
El sistema STAL es una herramienta automatizada (CLI/Backend) para la extracción, traducción técnica y reensamblaje de libros académicos en formato EPUB. El sistema está diseñado bajo principios de Arquitectura Limpia (Clean Architecture), separando la lógica de ingesta de datos, el motor de inferencia (LLM) y la capa de persistencia/salida.

Se definen dos perfiles de ejecución estrictos basados en restricciones de VRAM de hardware independiente.

---

## Propuesta A: Perfil "Edge / Ultra-Light" (Pipeline Secuencial)
**Hardware Objetivo:** GPU NVIDIA (4GB VRAM - RTX 3050 Mobile)
**Objetivo:** Maximizar la eficiencia térmica, limitar el consumo energético y procesar fragmentos atómicos mediante un modelo híbrido rápido.

### A.1. Especificaciones de Inferencia y Modelos
* **Modelo Principal:** `gemma4:4b-it` (Google) o `qwen3.5:4b`.
* **Cuantización:** `Q4_K_M` (Consumo estimado en RAM/VRAM: ~2.8 GB).
* **Motor de Inferencia:** Ollama con aceleración nativa CUDA (`nvidia-open`).
* **Ventana de Contexto Operativa:** Límite estricto fijado en **32,768 tokens** para evitar el desbordamiento hacia la memoria RAM del sistema (Swap/SysRAM).
* **Flash Attention:** Activado obligatoriamente en la configuración del backend.

### A.2. Arquitectura del Pipeline de Datos (Python)
Dado el límite de 4GB, el sistema debe ser extremadamente cuidadoso con la gestión de memoria.

1. **Capa de Extracción (`EPUBExtractor`)**
   * Utiliza `ebooklib` y `BeautifulSoup4` para desempaquetar el `.epub`.
   * **Limpieza Agresiva:** Se eliminan etiquetas HTML innecesarias, clases CSS, índices y pies de página antes del cálculo de tokens para ahorrar espacio de contexto.
2. **Capa de Segmentación (`ChunkingService`)**
   * División del texto por el tag `<body>` o `<div>` principal de cada capítulo (`.xhtml`).
   * Si un capítulo supera las 4,000 palabras (aprox. 5,500 tokens), se divide en fragmentos lógicos usando expresiones regulares para no cortar párrafos en medio de una idea.
3. **Capa de Traducción (`LLMInterface`)**
   * Llamadas síncronas a la API REST local de Ollama (`http://localhost:11434/api/generate`).
   * **System Prompt:** *"Eres un traductor académico profesional. Traduce el texto del inglés al español. Mantén el formato HTML original intacto. No agregues introducciones ni explicaciones, devuelve únicamente el texto traducido."*
4. **Carga y Descarga de Memoria (Térmica y Batería)**
   * Entre llamadas de capítulos, el script fuerza un `time.sleep(15)` o envía una señal de reinicio a la API de Ollama para purgar el *KV Cache*.
   * **Gestión de Hardware:** El proceso se diseña para operar conectado a la red eléctrica con un límite de carga de batería fijado a nivel de sistema operativo (80%) para prevenir la degradación de las celdas durante sesiones de 5+ horas.

---

## Propuesta B: Perfil "Academic Standard" (Pipeline RAG y Glosario)
**Hardware Objetivo:** GPU AMD (8GB VRAM - RX 6650 XT)
**Objetivo:** Traducción de grado profesional (nivel maestría/doctorado) garantizando la consistencia terminológica en todo el documento mediante inyección de contexto.

### B.1. Especificaciones de Inferencia y Modelos
* **Modelo Principal:** `qwen3.5:9b` (Alibaba).
* **Cuantización:** `Q5_K_M` (Consumo estimado en VRAM: ~6.2 GB).
* **Motor de Inferencia:** Ollama con backend HIP/ROCm (`mesa-rocm`).
* **Ventana de Contexto Operativa:** Fijada en **65,536 tokens** u **81,920 tokens** (Aprovechando el ancho de banda y la VRAM extendida).

### B.2. Arquitectura del Pipeline de Datos (Python)
Esta propuesta utiliza un flujo de trabajo más complejo, inyectando un glosario dinámico (RAG ligero).

1. **Capa de Extracción y Preprocesamiento (`EPUBExtractor` & `TermExtractor`)**
   * Tras extraer el `.xhtml` completo, se realiza una primera pasada rápida (usando un modelo ligero de 1.5B o el mismo 9B) para identificar jerga técnica.
   * Se genera un archivo de estado `glossary.json` (Ej. `{"Entropy": "Entropía", "Torque": "Par motor"}`).
2. **Capa de Traducción con Contexto Dinámico (`ContextualTranslator`)**
   * Se procesan capítulos completos (hasta 12,000 palabras de golpe).
   * **System Prompt Modificado:** *"Eres un traductor técnico. Traduce el siguiente texto de ingeniería al español. Utiliza obligatoriamente el siguiente glosario para los términos técnicos: {glossary_json}. Mantén las etiquetas HTML intactas."*
3. **Mecanismo de Tolerancia a Fallos (`StateManager`)**
   * Sistema de guardado en tiempo real. Cada bloque traducido se guarda temporalmente en una base de datos SQLite local (`translations.db`) o en formato `.jsonl`.
   * Si el servicio ROCm falla o hay un kernel panic en el entorno gráfico (KDE Plasma) por saturación de VRAM, el script puede reanudar la traducción desde el último bloque sin repetir procesos.
4. **Capa de Compilación (`EPUBCompiler`)**
   * Lee la base de datos de estado y reescribe los archivos `.xhtml` originales con los valores traducidos.
   * Vuelve a empaquetar el directorio modificado usando el estándar ZIP del formato EPUB3 y valida la estructura.

---

## 3. Estructura del Proyecto (Directorios)

Recomendación de estructura de Clean Architecture para el desarrollo en el entorno local:

```text
/stal-translator
├── /core
│   ├── config.py           # Variables de entorno y selección de Perfil (A o B)
│   ├── interfaces.py       # Clases abstractas para extractores y LLMs
├── /infrastructure
│   ├── ollama_client.py    # Conexión REST a Ollama (gestión de timeouts)
│   ├── epub_parser.py      # Implementación con BeautifulSoup
│   └── sqlite_repo.py      # Persistencia de estado para la Propuesta B
├── /use_cases
│   ├── extract_terms.py    # Lógica de generación de glosario
│   ├── translate_chunk.py  # Lógica central de envío y recepción
│   └── build_epub.py       # Reensamblaje del archivo final
├── /data
│   ├── /input              # Archivos .epub originales
│   ├── /output             # Archivos _es.epub generados
│   └── /tmp                # Descompresión y bases de datos locales
└── main.py                 # CLI de ejecución (ej: python main.py --profile 8GB)
```

## 4. Requisitos de Ejecución en Entorno
Para garantizar que el backend de CachyOS asigne los recursos correctamente y no congele el entorno de escritorio durante el procesamiento de la **Propuesta B**:

1.  **Variables de Entorno AMD (Perfil B):**
    ```bash
    HSA_OVERRIDE_GFX_VERSION=10.3.0 # Obligatorio para asegurar compatibilidad ROCm en RDNA2
    OLLAMA_MAX_VRAM=8192
    ```
2.  **Variables de Entorno NVIDIA (Perfil A):**
    ```bash
    OLLAMA_MAX_VRAM=4096
    ```