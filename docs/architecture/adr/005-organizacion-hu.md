# ADR-005: HU Organization by 100 Ranges

**Date**: 2026-05-29  
**Related RFC**: None (organization decision)  
**Status**: Accepted

---

## Context

In large projects with many user stories, file systems start to degrade when there are too many files in a single folder (typically >1,000 files, but performance can be affected from >100). Also, finding an HU specified long ago becomes difficult in a flat folder with hundreds of files.

Teams need:
- Fast navigation between HUs
- Historical context of which "era" work was done in
- Acceptable filesystem performance

---

## Decision

We adopt the following structure for `docs/tasks/`:

```
docs/tasks/
├── HU-001-HU-099/
│   ├── HU-001-first-feature.md
│   └── ...
├── HU-100-HU-199/
│   └── ...
├── HU-200-HU-299/
│   └── ...
└── HU-900-HU-999/
    └── ...
```

**Rule**: Folders are created when the HU number reaches the range limit. Empty folders are not created in advance.

| Phase | Range | When to create |
|------|-------|----------------|
| Phase 1 | HU-001 to HU-099 | At start (first HU) |
| Phase 2 | HU-100 to HU-199 | When HU-099 exists |
| Phase 3 | HU-200 to HU-299 | When HU-199 exists |
| ... | ... | And so on |

---

## Application Criteria

| Project size | Application |
|--------------|-------------|
| < 50 HUs | Optional — flat folder acceptable |
| 50-100 HUs | Recommended — create next folder |
| > 100 HUs | Mandatory — folder per range |

---

## Implementation

### Scripts

The script `scripts/hu-to-issues.sh` must automatically detect which folder the HU is in:

```bash
# Pseudocode
function get_hu_folder(hunumber) {
 hunum=$(echo $hunumber | sed 's/HU-//' | sed 's/-.*//')
  folder=$((hunum / 100 * 100 + 1))"-"$(((hunum / 100 + 1) * 100))
  echo "HU-${folder}"
}
```

### Git

The full HU path includes the folder:
```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

In commits:
```
feat: HU-042 - add login page
```

---

## Consequences

### ✅ Positive

- Stable filesystem performance
- Easier navigation (100 files per folder is manageable)
- Implicit historical context (folder = project era)
- Scalable to any number of HUs

### ❌ Negative

- When an HU moves ranges (e.g. 099 → 100), files need to be moved
- Existing scripts may need updates
- A bit more work when reorganizing

### 🔄 Neutral

- Requires discipline to create folder at the right moment
- For small projects it is unnecessary overhead

---

## How to Migrate an Existing Project

If you have a project with flat HUs and it already has > 100:

```bash
# 1. Create the next range folder
mkdir -p docs/tasks/HU-100-HU-199

# 2. Move the HUs in the range
mv docs/tasks/HU-100*.md docs/tasks/HU-100-HU-199/
mv docs/tasks/HU-101*.md docs/tasks/HU-100-HU-199/
# ... etc

# 3. Commit
git add .
git commit -m "chore: reorganize HUs into HU-100-HU-199 folder"
```

---

## Related Documents

| Document | Location |
|----------|---------|
| Template guide | `templates/TEMPLATE_GUIDE.md` |
| Example HU | `docs/tasks/HU-001-onboarding-docs.md` |

---

## Implementation Checklist

- [ ] Scripts `hu-to-issues.*` updated to detect folder
- [ ] `TEMPLATE_GUIDE.md` updated with this rule
- [ ] First folder HU-001-HU-099 created
- [ ] Example HU moved to correct folder (post-100)