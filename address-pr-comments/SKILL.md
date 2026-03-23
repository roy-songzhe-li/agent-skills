# Address PR Comments Skill

## Description

自动化处理 PR review comments 的工具。验证 comment 是否有效，如果有效则生成修复方案并回复；如果无效则礼貌地说明原因。

**核心功能：**
- 读取 PR 的所有 review comments
- 追踪已处理的 comments（避免重复）
- 使用 LLM 验证 comment 是否是真实问题
- 自动生成并应用修复代码
- 直接回复到原始 comment（quote reply）
- 如果 comment 不 valid，礼貌地说明原因

## Requirements

- `gh` CLI (GitHub CLI) - 已安装并认证
- `git` - 用于提交修复
- OpenClaw 可访问的 LLM API（用于验证和生成修复）

## Installation

```bash
# 确保 gh 已安装并认证
gh auth status

# 如果未认证
gh auth login
```

## Usage

### 基本用法

```bash
# 处理 PR 的所有 comments
bash address.sh <owner/repo> <pr-number>

# 只处理新的 comments（跳过已回复的）
bash address.sh <owner/repo> <pr-number> --new-only

# 示例
bash address.sh aetheron/api 123
```

### Workflow

1. **读取 comments** - 获取 PR 的所有 review comments
2. **过滤已处理** - 跳过已经回复的 comments
3. **验证有效性** - 使用 LLM 判断 comment 是否是真实问题
4. **生成修复** - 如果有效，生成代码修复方案
5. **应用修复** - 执行代码更改并 commit
6. **回复 comment** - 直接回复到原始 comment（quote reply）

## Comment 验证流程

对每个 comment，LLM 会判断：

### ✅ Valid (需要修复)

**条件：**
- 确实是 bug 或可改进的地方
- 在当前 PR 的 scope 内
- 技术上可行且合理

**行动：**
1. 生成修复代码
2. 应用修复
3. Commit（格式：`Fixed in <commit>: <description>`）
4. 回复 comment 并引用 commit hash

### ❌ Invalid (不需要修复)

**条件：**
- Out of scope（不在当前 PR 范围内）
- 已在其他地方处理
- 不是真实问题（误判）
- 需要更多讨论

**行动：**
1. 礼貌地说明原因
2. 回复 comment 并解释

## Reply 格式规范

### Fixed Comment 格式

```
Fixed in <commit-hash>: <one-sentence description of the fix>
```

**示例：**
```
Fixed in f2add5a: findLambda now constructs the exact expected name (ac-staging-email-worker) instead of using includes().
```

**规则：**
- ✅ 引用 commit hash
- ✅ 简洁的一句话描述
- ✅ 说明具体做了什么改动
- ✅ 使用英文
- ❌ 不使用破折号（em dash / en dash）
- ❌ 不过于啰嗦

### Invalid Comment 格式

**Out of Scope:**
```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

**Already Fixed:**
```
This was already addressed in commit abc123.
```

**Not a Real Issue:**
```
The current implementation is intentional here because [reason]. Could you clarify your concern?
```

**Needs Discussion:**
```
Thanks for the suggestion. Could we discuss this further? I think [your perspective].
```

**规则：**
- ✅ 一句话简短说明
- ✅ 礼貌、谦虚的语气
- ✅ 使用 "Perhaps", "Could", "Might" 等 tentative language
- ✅ 使用英文
- ❌ 不使用破折号
- ❌ 不生硬拒绝

## GitHub API 使用

### 读取 PR Comments

```bash
# 获取所有 review comments
gh api \
  -H "Accept: application/vnd.github+json" \
  "/repos/${REPO}/pulls/${PR_NUMBER}/comments"
```

### 回复 Comment (Reply)

```bash
# 直接回复到原始 comment（不是新建 comment）
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${REPO}/pulls/${PR_NUMBER}/comments/${COMMENT_ID}/replies" \
  -f body="Fixed in f2add5a: description of fix"
```

**注意：** 这是 **reply to comment**，不是 post new comment。

### 查看已回复的 Comments

```bash
# 检查 comment 是否已有 replies
gh api \
  -H "Accept: application/vnd.github+json" \
  "/repos/${REPO}/pulls/${PR_NUMBER}/comments/${COMMENT_ID}"
```

## 修复流程

### 1. 分析 Comment

使用 LLM 分析：
- Comment 指出的问题是什么？
- 在哪个文件的哪一行？
- 是否是真实问题？
- 是否在当前 PR 的 scope 内？

### 2. 生成修复方案

如果 valid，LLM 生成：
- 需要修改的文件
- 具体的代码更改
- 修改的原因

### 3. 应用修复

```bash
# 读取当前文件
cat path/to/file.ts

# 应用修复（可以用 edit 或重写文件）
# ... 修改代码 ...

# Commit
git add path/to/file.ts
git commit -m "Fix: description from comment"
```

### 4. 回复 Comment

```bash
COMMIT_HASH=$(git rev-parse --short HEAD)

gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${REPO}/pulls/${PR_NUMBER}/comments/${COMMENT_ID}/replies" \
  -f body="Fixed in ${COMMIT_HASH}: description of fix"
```

## 追踪已处理的 Comments

使用状态文件避免重复处理：

```bash
# 保存到 .addressed-comments.json
{
  "pr_123": {
    "comment_456": {
      "status": "fixed",
      "commit": "f2add5a",
      "timestamp": "2026-03-23T19:00:00Z"
    },
    "comment_789": {
      "status": "invalid",
      "reason": "out of scope",
      "timestamp": "2026-03-23T19:05:00Z"
    }
  }
}
```

## Advanced Usage

### 只处理特定 Comment

```bash
# 处理单个 comment
bash address.sh <owner/repo> <pr-number> --comment-id <comment-id>
```

### 批量处理多个 PRs

```bash
# 处理所有 open PRs 的 comments
gh pr list --repo <owner/repo> --json number --jq '.[].number' | while read pr; do
  bash address.sh <owner/repo> $pr --new-only
done
```

### 自定义 LLM 配置

```bash
# 使用不同的模型
API_MODEL="gpt-4" bash address.sh <owner/repo> <pr-number>

# 使用不同的 API endpoint
API_BASE_URL="https://api.openai.com/v1" bash address.sh <owner/repo> <pr-number>
```

## Safety Features

1. **Dry Run Mode** - 预览修复但不应用
2. **Human Approval** - 对重大修改要求人工确认
3. **Rollback** - 如果修复失败，自动回滚
4. **State Tracking** - 记录所有处理过的 comments

## Integration

### CI/CD

```yaml
# .github/workflows/address-comments.yml
name: Address PR Comments
on:
  pull_request_review_comment:
    types: [created]

jobs:
  address:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Address Comment
        run: bash address.sh ${{ github.repository }} ${{ github.event.pull_request.number }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### OpenClaw

通过 agent 调用：

```
Address all comments in PR #123
```

## Tips

1. **优先级排序：** 先处理 blocker 和 major issues
2. **Context 感知：** 理解 comment 的上下文，避免误判
3. **谦虚回复：** 即使 comment 无效，也要礼貌说明
4. **引用 commit：** 修复后一定要引用 commit hash
5. **避免破折号：** 使用逗号或句号分隔
6. **全英文：** 所有回复使用英文

## Files

- `SKILL.md` - 本文档
- `address.sh` - 主要处理脚本
- `verify-prompt.txt` - 验证 comment 的 LLM prompt
- `fix-prompt.txt` - 生成修复的 LLM prompt
- `reply-templates.md` - 回复模板
- `examples/fixed-replies.md` - Fixed comment 示例
- `examples/invalid-replies.md` - Invalid comment 回复示例

## License

MIT
