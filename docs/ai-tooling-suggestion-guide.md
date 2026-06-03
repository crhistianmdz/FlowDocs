# AI Tooling Suggestion Guide

> Recommendations for configuring AI coding tools to work better with FlowDoc.
> These are **suggestions, not obligations**. They enhance the experience but are not required for FlowDoc to work.

---

## OpenCode

### Load project's AGENTS.md by default

**Problem**: OpenCode automatically reads the global `AGENTS.md` (`~/.config/opencode/AGENTS.md`) but NOT the project's `AGENTS.md` (`./AGENTS.md`). This means the agent starts each session without the project's specific context.

**Solution**: Add the following to your project's `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["./AGENTS.md"]
}
```

This loads the project's `AGENTS.md` automatically at the start of every session, giving the agent immediate context about your project without you having to reference it manually.

**Is this mandatory?**: No. Without it, OpenCode still works. With it, the agent has better context from the start.

**Why this matters for FlowDoc**: FlowDoc relies on the agent understanding the project structure, conventions, and workflow. Without this config, the agent may not have that context until you explicitly mention it.

---

## Claude Code

### Load project's AGENTS.md by default

**Problem**: Claude Code automatically reads `CLAUDE.md` (or `~/.claude/CLAUDE.md` for user-wide context), but it does NOT read `AGENTS.md`. This means the agent starts each session without the project's specific context if you're using `AGENTS.md` as your project file.

**Solution**: Create a `CLAUDE.md` file in your project root that imports `AGENTS.md`:

```markdown
@AGENTS.md
```

This loads the project's `AGENTS.md` content automatically at the start of every session, giving the agent immediate context about your project.

**Is this mandatory?**: No. Without it, Claude Code still works. With it, the agent has better context from the start.

**Why this matters for FlowDoc**: FlowDoc relies on the agent understanding the project structure, conventions, and workflow. Without this, the agent may not have that context until you explicitly mention it.

---

## GitHub Copilot (VS Code)

### Load project's AGENTS.md by default

**No action required**. GitHub Copilot in VS Code automatically detects an `AGENTS.md` file in the root of your workspace and applies its instructions to all chat requests.

This means FlowDoc's `AGENTS.md` is already recognized without any additional configuration.

**Is this mandatory?**: No. It's already configured by default.

**Why this matters for FlowDoc**: FlowDoc relies on the agent understanding the project structure, conventions, and workflow. With `AGENTS.md` in the project root, Copilot will automatically have that context.

---

## Antigravity

### Load project's AGENTS.md by default

**No action required**. Antigravity automatically detects an `AGENTS.md` file in the root of your project (or workspace root) and applies its instructions to all agent sessions.

Antigravity searches for `AGENTS.md` starting from the current directory and walks up the directory tree until it finds one. Placing it at the project root ensures that any command run from any subfolder will recognize it.

This means FlowDoc's `AGENTS.md` is already recognized without any additional configuration.

**Is this mandatory?**: No. It's already configured by default.

**Why this matters for FlowDoc**: FlowDoc relies on the agent understanding the project structure, conventions, and workflow. With `AGENTS.md` in the project root, Antigravity will automatically have that context.

---

## Cursor

### Load project's AGENTS.md by default

**No action required**. Cursor automatically detects an `AGENTS.md` file in the root of your project (and subdirectories) and applies its instructions to all agent sessions.

Cursor supports `AGENTS.md` in the project root and nested subdirectories. Instructions from nested `AGENTS.md` files are combined with parent directories, with more specific instructions taking precedence.

This means FlowDoc's `AGENTS.md` is already recognized without any additional configuration.

**Is this mandatory?**: No. It's already configured by default.

**Why this matters for FlowDoc**: FlowDoc relies on the agent understanding the project structure, conventions, and workflow. With `AGENTS.md` in the project root, Cursor will automatically have that context.

---

## More Tools (Coming Soon)

This guide will be expanded as we test and validate configurations for other AI coding tools.

---

**Note**: If you encounter issues where the agent doesn't seem to "know" your project, this config is likely the first thing to check.