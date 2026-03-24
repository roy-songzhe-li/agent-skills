# agent-cube-auto

Execute coding tasks using Agent Cube's autonomous multi-agent workflow.

## Quick Start

```bash
# 1. Create task file
cat > my-task.md << 'EOF'
# Add String Utilities
Create capitalize() and slugify() functions in TypeScript.
Include tests. No external dependencies.
EOF

# 2. Run autonomous workflow
cube auto my-task.md

# 3. Check progress
cube status my-task

# 4. PR created automatically!
```

## What It Does

1. **2 AI writers** implement independently (Sonnet + Codex)
2. **3 AI judges** review both solutions
3. **System picks winner** or synthesizes best
4. **PR created** automatically

**Total time:** 15-30 minutes (vs 2-8 hours manual)

## Documentation

- **[SKILL.md](SKILL.md)** - Complete guide (official format)
- **[references/QUICK-REFERENCE.md](references/QUICK-REFERENCE.md)** - Command cheat sheet
- **[assets/task-template-simple.md](assets/task-template-simple.md)** - Simple task template
- **[assets/task-template-detailed.md](assets/task-template-detailed.md)** - Detailed task template

## Requirements

- `cube` CLI installed
- `cursor-agent` authenticated
- Git repository

## When to Use

✅ **Good for:**
- Features (2-8 hours scope)
- Architecture decisions
- Production-critical code

❌ **Not for:**
- Quick fixes (<1 hour)
- Emergency hotfixes
- Simple typos

## License

MIT
