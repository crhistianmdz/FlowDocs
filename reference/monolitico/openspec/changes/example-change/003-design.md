# Design — add-card-attachments

## Architecture

```
Client ──POST multipart──> Express route /attachments
                              ├─ multer (memory storage, 5MB limit)
                              ├─ mime whitelist middleware
                              ├─ attachments.service.ts
                              ├─ Prisma: attachments table
                              └─ fs write to /uploads/<cardId>/<uuid>.<ext>
```

## Decisions
- Use `multer` with memory storage + manual write (avoids temp dir naming conflicts).
- Filename: `<uuid>.<ext>`; original name stored in DB.
- URL served via static `/uploads/...` (Vite dev + Express prod).

## DB

```prisma
model Attachment {
  id          String   @id @default(uuid())
  cardId      String
  filename    String
  mimeType    String
  size        Int
  url         String
  createdAt   DateTime @default(now())
  card        Card     @relation(fields: [cardId], references: [id], onDelete: Cascade)
  @@index([cardId])
}
```

## Open questions
- Move to S3 in Phase 2 (see proposal Out of scope).