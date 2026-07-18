# RFC Template: Request for Comments

> Copy this template when you need to make an important technical decision.
> Product decisions go in PRD.md, not in RFC.

---

## [RFC Number]: [Technical Decision Title]

- **Status**: [Draft | In Review | Accepted | Obsolete]
- **Author(s)**: [Name(s)]
- **Date**: [YYYY-MM-DD]
- **Project**: [Project name]

---

## 1. Summary

Brief description of the technical decision and why it is needed.

---

## 2. Context

- What technical problem does this solve?
- Why is it necessary to decide this now?
- What alternatives were considered?

---

## 3. Technical Decision

### 3.1 Chosen Technology
| Item | Selection | Justification |
|------|-----------|---------------|
| Language/Framework | [e.g: .NET 8] | [reason] |
| Database | [e.g: PostgreSQL] | [reason] |
| API Style | [REST/GraphQL/gRPC] | [reason] |
| Auth | [JWT/OAuth/etc] | [reason] |

---

## 4. Infrastructure

### 4.1 Containers (Docker)

| Service | Image | Port | Description |
|---------|-------|------|-------------|
| API | [image:tag] | 5000 | Backend |
| Frontend | [image:tag] | 4200 | Web app |
| Database | [image:tag] | 5432 | PostgreSQL |
| Cache | [image:tag] | 6379 | Redis |
| [Other] | [image:tag] | [port] | [description] |

### 4.2 Docker Files

- `Dockerfile` - API image
- `Dockerfile.web` - Frontend image
- `docker-compose.yml` - Local development
- `.dockerignore` - Exclusions
- `Dockerfile.tests` - Tests (optional)

### 4.3 Environments

| Environment | Description | URL |
|-------------|-------------|-----|
| Development | docker-compose local | localhost |
| Staging | [Docker swarm/K8s] | staging.example.com |
| Production | [K8s/Cloud] | example.com |

---

## 5. Security Considerations

- Sensitive environment variables
- Exposed ports
- Containerized networks
- Secrets management

---

## 6. Costs and Resources

- Required hardware resources
- Monthly cost estimate
- Required licenses

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|-------------|
| [Risk 1] | [High/Medium/Low] | [How to avoid] |
| [Risk 2] | [High/Medium/Low] | [How to avoid] |

---

> **Once approved → create an ADR** at `docs/architecture/adr/ADR-NNN.md`
> using `templates/ADR_template.md`. The ADR is the permanent record of the decision.
> The RFC remains as history of the discussion.

## 8. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Tech Lead | [Name] | [Approved/Rejected/Pending] | [Date] |
| Team | - | [Reviewed] | [Date] |

---

## 9. Change History

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial version | [Author] |

---

## Usage Example

```bash
# Copy the template
cp docs/templates/architecture/RFC_template.md docs/architecture/rfc/001-my-decision.md

# Edit with the technical decision
# Then create task in docs/tasks/ to implement
```