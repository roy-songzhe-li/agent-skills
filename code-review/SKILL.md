# Code Review Skill

## Description

自动化代码审查工具，基于预定义的架构规则和最佳实践进行 PR review。

**核心功能：**
- 拉取 GitHub PR 的 diff 并逐行审查
- 生成符合规范的 review comments（concise, clear, tentative language）
- 使用 GitHub inline comments 直接标注问题位置
- 支持 Approve / Request Changes / Comment 三种 review 状态
- 自动检测违反架构规则的代码

## Requirements

- `gh` CLI (GitHub CLI) - 已安装并认证
- OpenClaw 可访问的 LLM API（用于生成 review comments）

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
# Review 指定 PR
bash review.sh <owner/repo> <pr-number>

# 示例
bash review.sh aetheron/api 123
```

### Review 模式

Skill 会自动：
1. 拉取 PR 的 diff
2. 根据架构规则检查每个文件
3. 生成 review comments（使用 LLM）
4. Post inline comments 到对应代码行
5. 提交 review（Approve/Request Changes/Comment）

## Review 流程

### 1. 拉取 PR Diff

```bash
gh pr diff <pr-number> --repo <owner/repo>
```

### 2. 逐行审查

对每个文件的每个改动：
- 检查是否违反架构规则（见 `architecture-rules.md`）
- 识别潜在 bug
- 发现代码改进机会

### 3. 生成 Comment

**格式要求：**
- **一句话**：Concise, clear
- **引用具体文件和代码段**
- **Tentative language**：
  - ✅ "Perhaps we could..."
  - ✅ "Might be worth considering..."
  - ✅ "Could potentially simplify..."
  - ✅ "Would it make sense to..."
  - ✅ "It looks like... might need..."
  
- **避免命令式：**
  - ❌ "You should..."
  - ❌ "This is wrong..."
  - ❌ "Must change..."

**分类标签：**
- `DRY: ...`
- `Potential Bug: ...`
- `Security: ...`
- `Architecture: ...`
- `Type Safety: ...`
- `Performance: ...`
- `[NITPICK]` - 可选的微小改进

### 4. Post Inline Comments

使用 GitHub API：

```bash
# 添加 inline comment
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo}/pulls/{pr}/reviews \
  -f body='Review comments' \
  -f event='COMMENT' \
  -F 'comments[][path]=apps/api/src/routes/billing.ts' \
  -F 'comments[][position]=10' \
  -F 'comments[][body]=Perhaps we could simplify this logic?'
```

### 5. 提交 Review

根据发现的问题严重程度：

- **APPROVE** - 没有问题，或只有 nitpick
- **REQUEST_CHANGES** - 发现重大问题（安全、架构违规、潜在 bug）
- **COMMENT** - 提出建议，但不阻止合并

```bash
# Approve
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo}/pulls/{pr}/reviews \
  -f event='APPROVE' \
  -f body='LGTM! 🚀'

# Request Changes
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo}/pulls/{pr}/reviews \
  -f event='REQUEST_CHANGES' \
  -f body='Found several issues that need attention.'
```

## Comment 示例

### ✅ Good Examples

> **DRY:** Since `process()` throws on failure, `processed` is always `true`. Perhaps we could simplify the interface?

> **Potential Bug:** It looks like the return value might not be stored. Could we capture the key and update the record?

> **Security:** The `billingCheckoutSigningSecret` is optional in config, so the API can start without it configured. Consider making it required in staging/production.

> **Type Safety:** Might be worth using `Type.Integer()` instead of `Type.Number()` since fractional days would produce incorrect expiry times.

### ❌ Bad Examples

> ❌ This is redundant. Remove it.

> ❌ You must use spread operator here.

> ❌ Wrong approach.

## Architecture Rules

所有架构规则定义在 `architecture-rules.md`。

**重点检查：**
1. 安全问题（使用 `getDb()` 绕过 RLS）
2. 架构分层（缺少 repository layer）
3. 类型安全（TypeBox vs SDK 原生类型）
4. API 设计（路径参数 vs body 参数）
5. 组件规范（Design System vs 原生 HTML）
6. 错误处理（全局 error boundary vs 手动处理）

## Advanced Usage

### 批量 Review

```bash
# Review 所有 open PRs
gh pr list --repo <owner/repo> --json number --jq '.[].number' | while read pr; do
  bash review.sh <owner/repo> $pr
done
```

### 自定义规则

编辑 `architecture-rules.md` 添加项目特定规则。

### 集成到 CI/CD

```yaml
# .github/workflows/code-review.yml
name: AI Code Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: AI Review
        run: bash review.sh ${{ github.repository }} ${{ github.event.pull_request.number }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Workflow Integration

### 与 AGENTS.md 规则配合

Review 时会参考 `AGENTS.md` 里的规则（如果存在）：
- 代码风格偏好
- 团队约定
- 项目特定的最佳实践

### 避免重复 Comments

检查 PR 上已有的 comments，避免重复提出相同问题。

### 确认 Context

在 post comment 前，确认：
- 代码 context 是否完整？
- 是否真的是问题而非合理设计？
- 是否值得 comment（避免过多 nitpick）？

## Tips

1. **优先级排序：** 先关注安全和架构问题，再关注代码风格
2. **Context 感知：** 理解代码的业务 context，避免误判
3. **建设性反馈：** 不仅指出问题，还提供解决方案或替代方案
4. **尊重作者：** 使用 tentative language，给作者思考空间

## Files

- `SKILL.md` - 本文档
- `review.sh` - 主要 review 脚本
- `architecture-rules.md` - 架构规则清单
- `review-prompt.txt` - LLM review prompt 模板
- `examples/good-comments.md` - 优秀 comment 示例
- `examples/bad-comments.md` - 糟糕 comment 示例

## License

MIT
