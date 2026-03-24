---
name: agent-cube-auto
description: Execute coding tasks using Agent Cube autonomous workflow. Two AI writers compete, three judges review, system picks winner or synthesizes best solution, creates PR automatically. ONLY use when user explicitly mentions "cube" or "agent cube" in their request (e.g., "用 cube 帮我做 XXX", "agent cube 实现 XXX").
license: MIT
compatibility: Requires cube CLI installed and cursor-agent authenticated
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  created: "2026-03-24"
  cube-path: /Users/roy-songzhe-li/Desktop/CognitiveCreators/repos/agent-cube
---

# Agent Cube Auto

Execute coding tasks using Agent Cube's autonomous multi-agent workflow.

## ⚠️ ACTIVATION REQUIREMENT

**This skill is ONLY activated when the user explicitly mentions:**
- "cube 帮我做 XXX"
- "用 cube 实现 XXX"
- "agent cube 完成 XXX"
- "用 agent cube XXX"

**Do NOT use this skill for general coding requests like:**
- ❌ "帮我实现 XXX 功能"
- ❌ "写一个 XXX"
- ❌ "实现 XXX"

**The user must explicitly invoke "cube" or "agent cube" to trigger this workflow.**

## What Agent Cube Does

**The Process:**
1. **2 AI writers** implement the same task independently (Sonnet + Codex)
2. **3 AI judges** review both implementations
3. **System picks winner** or synthesizes best of both
4. **Peer review validates** final solution
5. **PR automatically created** for human approval

**The Result:**
- Dual approaches evaluated (not just 1)
- 3 independent reviews per feature
- Production-ready code with tests
- Automatic PR creation

## Quick Start

### 1. Create Task File

Create a task description in Markdown:

```bash
Write my-task.md
```

**Example task file:**
```markdown
# Add String Utilities

## Goal
Create capitalize() and slugify() functions in TypeScript.

## Requirements
- capitalize(str): Uppercase first letter
- slugify(str): Convert to URL-friendly slug
- Include comprehensive tests
- No external dependencies
- Export from index.ts

## Acceptance Criteria
- [ ] Functions implemented correctly
- [ ] Tests pass with 100% coverage
- [ ] TypeScript types correct
- [ ] No ESLint errors
```

### 2. Run Autonomous Workflow

```bash
cube auto my-task.md
```

**What happens:**
- Orchestrator plans the workflow
- 2 writers implement independently (parallel)
- 3 judges review both solutions
- System picks winner or synthesizes
- PR created automatically

### 3. Check Progress

```bash
# Check overall status
cube status my-task

# See judge decisions
cube decide my-task

# View logs
cube logs my-task
```

### 4. Review PR

```bash
# PR created automatically at:
# https://github.com/<owner>/<repo>/pulls
```

## Complete Workflow

### Step 1: Prepare Task

**Task file structure:**
```markdown
# <Task Title>

## Goal
One sentence: what you're building

## Requirements
- Bullet list of features
- Technical constraints
- Integration points

## Acceptance Criteria
- [ ] Checklist of must-haves
- [ ] Test coverage requirements
- [ ] Performance targets

## Context
Any relevant background, existing code to reference, etc.
```

**Save as:** `<task-id>.md` or `<feature-name>.md`

### Step 2: Run Auto Workflow

```bash
cd /path/to/your/project
cube auto <task-file>.md
```

**Flags:**
- `--resume` - Continue from where it left off
- `--skip-writers` - Skip to panel review (if writers done)
- `--skip-panel` - Skip to synthesis (if panel done)

### Step 3: Monitor Execution

**Watch status:**
```bash
# Terminal 2 (while auto runs)
watch -n 5 'cube status <task-id>'
```

**Check sessions:**
```bash
cube sessions
```

**View logs:**
```bash
# See what writers are doing
cube logs <task-id> --writer writer-a
cube logs <task-id> --writer writer-b

# See judge reviews
cube logs <task-id> --judge judge-1
```

### Step 4: Review Decisions

```bash
cube decide <task-id>
```

**Output shows:**
- Judge votes (Winner A / Winner B / Synthesis)
- Scores and reasoning
- Final decision (winner or synthesis needed)

### Step 5: Check PR

Auto-created PR includes:
- Winning implementation (or synthesized)
- All changes committed
- Ready for human review

## When to Use Agent Cube

### ✅ Good For

**Complex Features (2-8 hours scope):**
- API endpoints with validation
- UI components with state management
- Database migrations + queries
- Integration with external services

**Architecture Decisions:**
- Multiple valid approaches
- Trade-offs to evaluate
- Best practices to establish

**Production-Critical Code:**
- Needs thorough review
- Multiple perspectives valuable
- Quality > speed

### ❌ Not Good For

**Tiny Changes (<1 hour):**
- Simple bug fixes
- Typo corrections
- Config updates
→ Use regular coding instead

**Emergency Hotfixes:**
- Too slow (writers + judges + synthesis = 15-30 min)
→ Fix directly, review later

**Experimental Code:**
- Requirements unclear
- Just exploring ideas
→ Prototype first, then Agent Cube

## Advanced Usage

### Resume from Interruption

```bash
# If cube auto was interrupted
cube auto <task-file>.md --resume
```

### Skip Completed Stages

```bash
# Writers done, run panel only
cube auto <task-file>.md --skip-writers

# Panel done, run synthesis only
cube auto <task-file>.md --skip-panel
```

### Force PR Creation

```bash
# Create PR even if issues remain
cube pr <task-id> --force
```

### Manual Steps

**Launch writers manually:**
```bash
cube writers <task-id> <task-file>.md
```

**Launch judges manually:**
```bash
cube panel <task-id> <panel-prompt-file>.md
```

**Apply synthesis manually:**
```bash
cube feedback winner-a <task-id> <synthesis-instructions>.md
```

## Task File Best Practices

### 1. Be Specific

❌ **Bad:**
```markdown
# Add user features
Make the user stuff work better.
```

✅ **Good:**
```markdown
# Add User Profile Editing

Allow users to update their name, email, and avatar.
Include validation and error handling.
```

### 2. Include Technical Details

```markdown
## Technical Requirements
- Use Zod for validation
- Update `users` table schema
- Add `PUT /api/users/:id` endpoint
- Return updated user object
```

### 3. Define Success Clearly

```markdown
## Acceptance Criteria
- [ ] User can update name (max 100 chars)
- [ ] Email validation (must be valid format)
- [ ] Avatar upload (max 5MB, jpg/png only)
- [ ] Tests cover all validation cases
- [ ] API returns 400 with clear error messages
```

### 4. Provide Context

```markdown
## Context
Current user schema:
\`\`\`typescript
type User = {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
};
\`\`\`

Existing API pattern (for reference):
\`\`\`typescript
// apps/api/src/routes/users.ts
export const usersRoutes = (fastify) => {
  fastify.get('/users/:id', getUserHandler);
  // Add PUT endpoint here
};
\`\`\`
```

## Configuration

Agent Cube config: `/Users/roy-songzhe-li/Desktop/CognitiveCreators/repos/agent-cube/python/cube.yaml`

**Default models:**
- Writer A: `sonnet-4.5-thinking`
- Writer B: `gpt-5-codex-high`
- Judge 1: `sonnet-4.5-thinking`
- Judge 2: `gpt-5-codex-high`
- Judge 3: `gemini-2.5-pro`

**Customize if needed** (edit cube.yaml)

## Performance Metrics

**Observed from production use:**
- Writer completion: 3-8 minutes per agent
- Judge review: 2-5 minutes per judge
- Synthesis: 3-6 minutes
- **Total cycle: 15-30 minutes** (vs 2-8 hours manual)

**Cost:**
- $5-15 per task (LLM API costs)
- 4-5x ROI vs developer time
- Higher quality through competition

## Troubleshooting

### "cube: command not found"

```bash
# Check if installed
which cube

# If not found, install
cd /Users/roy-songzhe-li/Desktop/CognitiveCreators/repos/agent-cube
./install.sh
```

### "cursor-agent not authenticated"

```bash
cursor-agent login
```

### Writers not committing

Writers should auto-commit and push. If not:
```bash
# Check writer branches
git fetch origin
git log origin/writer-sonnet/<task-id>
git log origin/writer-codex/<task-id>

# If empty, check logs
cube logs <task-id> --writer writer-a
```

### Synthesis not applying

```bash
# Check if synthesis instructions were created
ls implementation/panel/synthesis-instructions-<task-id>.md

# Manually apply if needed
cube feedback winner-a <task-id> <synthesis-file>.md
```

### PR not created

```bash
# Create manually
cube pr <task-id>

# Force creation (ignore remaining issues)
cube pr <task-id> --force
```

## Complete Example

### Task: Add API Rate Limiting

**1. Create task file:**
```markdown
# Add API Rate Limiting

## Goal
Implement rate limiting for all API routes using Redis.

## Requirements
- Limit: 100 requests per minute per IP
- Return 429 Too Many Requests when exceeded
- Add rate limit headers (X-RateLimit-*)
- Redis-based storage (shared across instances)
- Exclude health check endpoint

## Technical
- Use `ioredis` client
- Add middleware to fastify
- Configure Redis connection from env
- Add rate limit reset time to headers

## Acceptance Criteria
- [ ] Rate limiting works correctly
- [ ] Headers show limit/remaining/reset
- [ ] Redis connection handling
- [ ] Tests cover limit reached scenario
- [ ] Health check excluded
- [ ] No new dependencies beyond ioredis

## Context
Existing middleware pattern:
\`\`\`typescript
// apps/api/src/plugins/auth.ts
export const authPlugin = (fastify) => {
  fastify.addHook('onRequest', authMiddleware);
};
\`\`\`

Add similar pattern for rate limiting.
```

**2. Run workflow:**
```bash
cd ~/Desktop/CognitiveCreators/repos/my-project
cube auto rate-limiting.md
```

**3. Monitor:**
```bash
# Check progress
cube status rate-limiting

# See decisions
cube decide rate-limiting
```

**4. Review PR:**
PR created at: `https://github.com/myorg/my-project/pulls`

**5. Merge:**
Human reviews and merges PR.

## Resources

- [Agent Cube Docs](references/AGENT-CUBE-DOCS.md) - Complete documentation
- [Automation Guide](references/AUTOMATION-GUIDE.md) - Advanced workflows
- [Task Templates](assets/task-templates/) - Example task files
- [Agent Cube Repo](https://github.com/aetheronhq/agent-cube) - Source code

## Key Insights

**From production use (Aetheron Connect v2):**
- Synthesis improved 40% of tasks
- Sonnet wins UI/frontend (100%)
- Codex wins backend (88%)
- Multiple reviews catch bugs early
- Task-model matching > "best model for everything"

**The AI Village:**
Like pair programming × 5. Multiple perspectives, ideas you wouldn't have thought of, issues you would've missed.
