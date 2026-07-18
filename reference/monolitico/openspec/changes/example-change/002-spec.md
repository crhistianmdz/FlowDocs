# Spec — add-card-attachments

## Requirements

### REQ-1 Upload attachment
- Upload via `POST /api/cards/:cardId/attachments` (multipart/form-data).
- Max file size 5MB.
- Accepted types: image/png, image/jpeg, application/pdf, text/plain.

### REQ-2 List attachments
- `GET /api/cards/:cardId/attachments` returns array ordered by `createdAt` desc.

### REQ-3 Delete attachment
- `DELETE /api/attachments/:id` → 204; only card assignee or board owner.

## Scenarios

### Scenario: upload happy path
- **WHEN** POST `/api/cards/:id/attachments` with valid file ≤5MB and auth
- **THEN** response 201 with `{ id, cardId, filename, url, createdAt }`

### Scenario: oversize upload
- **WHEN** POST with file 6MB
- **THEN** response 413 `{ error: { code: "FILE_TOO_LARGE", message: "..." } }`

### Scenario: invalid type
- **WHEN** POST with `application/zip`
- **THEN** response 415 `{ error: { code: "UNSUPPORTED_TYPE" } }`

### Scenario: delete by non-owner
- **WHEN** DELETE by user who isn't assignee/owner
- **THEN** 403 FORBIDDEN