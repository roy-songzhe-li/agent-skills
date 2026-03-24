## Agent Cube - Quick Reference

### Essential Commands

```bash
# Run autonomous workflow
cube auto <task-file>.md

# Check status
cube status <task-id>

# See decisions
cube decide <task-id>

# Create PR
cube pr <task-id>

# Resume if interrupted
cube auto <task-file>.md --resume
```

### Task File Template

```markdown
# <Task Title>

## Goal
One sentence: what you're building

## Requirements
- Feature 1
- Feature 2
- Technical constraint

## Acceptance Criteria
- [ ] Must have 1
- [ ] Must have 2
- [ ] Test coverage

## Context
Relevant code, patterns, schemas...
```

### Workflow Stages

1. **Writers** (3-8 min each)
   - Writer A (Sonnet): Independent implementation
   - Writer B (Codex): Independent implementation

2. **Panel** (2-5 min each)
   - Judge 1 (Sonnet): Review + vote
   - Judge 2 (Codex): Review + vote
   - Judge 3 (Gemini): Review + vote

3. **Synthesis** (3-6 min)
   - If needed: Combine best of both
   - Winner applies synthesis instructions

4. **PR Creation** (automatic)
   - Winning branch → PR
   - Ready for human review

### When Something Goes Wrong

```bash
# Writers stuck?
cube logs <task-id> --writer writer-a
cube logs <task-id> --writer writer-b

# Judges disagree?
cube decide <task-id>  # See reasoning

# Need to restart?
cube auto <task-file>.md --resume

# Force PR creation?
cube pr <task-id> --force
```

### Monitoring

```bash
# Watch real-time (in separate terminal)
watch -n 5 'cube status <task-id>'

# List all active sessions
cube sessions

# View specific log
cube logs <task-id> --writer writer-a
cube logs <task-id> --judge judge-2
```

### Good Use Cases

✅ API endpoints (2-6 hours)
✅ UI components with state
✅ Database migrations
✅ Integration with services
✅ Refactoring with tests

❌ Quick fixes (<1 hour)
❌ Emergency hotfixes
❌ Simple typos
❌ Config changes

### Performance

- **Total time**: 15-30 minutes
- **vs Manual**: 2-8 hours
- **Cost**: $5-15 per task
- **ROI**: 4-5x

### Troubleshooting Checklist

- [ ] cube CLI installed? (`which cube`)
- [ ] cursor-agent authenticated? (`cursor-agent status`)
- [ ] In project directory? (`cd <project>`)
- [ ] Task file exists? (`ls <task>.md`)
- [ ] Git clean? (`git status`)

### Model Strengths

- **Sonnet 4.5**: UI, frontend, user-facing
- **Codex High**: Backend, APIs, data processing
- **Gemini 2.5 Pro**: Balanced judge, catches both
