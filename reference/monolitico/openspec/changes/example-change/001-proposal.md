# Proposal — add-card-attachments

## Intent

Allow users to attach small images/files (≤5MB) to TaskManager cards so context stays with the task.

## Scope

- Add `attachments` table (per card).
- API endpoints: upload, list, delete.
- UI: attachment zone in card detail.

## Approach

Store files in local filesystem for MVP (Phase 2 → move to S3). Reference `docs/api/endpoints.md` for new endpoints.

## Risks

- Storage growth unmanaged.
- MIME-type validation bypass.

## Out of scope

- File preview / thumbnail generation (Phase 2).
- Virus scanning.

---

**Status**: Draft
**Author**: @backend-lead
**Date**: 2026-07-18