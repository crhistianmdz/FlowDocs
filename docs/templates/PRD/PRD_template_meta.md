# Product Requirements Document (PRD) Template — Meta-Documentation Frameworks

> For documentation framework projects (not product development). Use `PRD_template.md` for AI/ML projects with testing, models, and metrics.

---

## 1. Framework Overview
- **Framework Name:** [Framework Name]
- **Type:** Documentation Framework
- **Review Date:** [Month, Year]
- **Description:** [A brief description of what this documentation framework provides and who it's for]

---

## 2. Problem Statement

### What This Solves
- [Problem 1: e.g., No clear place for technical decisions]
- [Problem 2: e.g., Knowledge loss when team members leave]
- [Problem 3: e.g., Documentation scattered across tools]

### Proposed Solution
[A concise description of the solution approach]

---

## 3. Target Users

| User | Need |
|------|------|
| **Developers** | [What they need from the framework] |
| **Tech Leads** | [What they need from the framework] |
| **Newcomers** | [What they need from the framework] |
| **AI Agents** | [What they need from the framework] |

---

## 4. Scope

### In Scope
- [Core capability 1]
- [Core capability 2]
- [Core capability N]

### Out of Scope
- [Explicitly NOT included]
- [These are common confusions to clarify]

---

## 5. Core Concepts

### [Document Type 1] — [Brief Description]
**What**: [One sentence definition]
**When**: [When to use this document type]
**Location**: `docs/[folder]/`

### [Document Type 2] — [Brief Description]
**What**: [One sentence definition]
**When**: [When to use this document type]
**Location**: `docs/[folder]/`

---

## 6. Document Types Inventory

| Type | Folder | Purpose | Lifetime |
|------|--------|---------|----------|
| **[Type]** | `docs/[folder]/` | [Purpose] | [Duration] |
| **[Type]** | `docs/[folder]/` | [Purpose] | [Duration] |

---

## 7. AI Agent Compatibility

### How It Works
1. Agent reads `docs/PRD.md` → understands the project
2. Agent reads [relevant documents] → [understands what]
3. Agent reads [contracts/schemas] → [knows how to integrate]

### Supported Tools
| Tool | Why it works |
|------|--------------|
| [Tool 1] | [Reason] |
| [Tool 2] | [Reason] |

---

## 8. Adoption Levels

| Level | What You Get | Ideal For |
|-------|-------------|-----------|
| **L1: [Name]** | [Capabilities] | [Use case] |
| **L2: [Name]** | [Capabilities] | [Use case] |
| **L3: [Name]** | [Capabilities] | [Use case] |

---

## 9. Project Structure

```
docs/
├── README.md                    # [Description]
├── PRD.md                       # [Description]
├── [folder]/                    # [Description]
│   └── ...
└── templates/                   # [Description]
    └── ...
```

---

## 10. Documentation Rules

### Golden Rules

| Rule | Why |
|------|-----|
| **[Rule 1]** | [Reason] |
| **[Rule 2]** | [Reason] |

### Anti-Patterns

| Sign | What It Means |
|------|---------------|
| [Symptom 1] | [Interpretation] |
| [Symptom 2] | [Interpretation] |

---

## 11. Resources

| Resource | Location |
|---------|----------|
| [Resource name] | [Path or link] |

---

## 12. Changelog

| Version | Date | Change |
|---------|------|--------|
| 1.0 | [YYYY-MM-DD] | Initial version |
