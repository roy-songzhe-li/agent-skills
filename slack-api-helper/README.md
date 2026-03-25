# Slack API Helper

**基于 Slack User Token 的完整 API 集成**

---

## 🎯 核心优势

✅ **完整功能** - 读取/写入/搜索/反应  
✅ **不占用应用** - 纯 API，不干扰 Desktop/Web  
✅ **已配置** - Token 已安全存储  
✅ **即用脚本** - 4 个快捷脚本，开箱即用  

---

## 📦 包含内容

### 1. **SKILL.md** - 完整文档
- API 使用指南
- 常用频道 ID
- OpenClaw 集成示例
- 故障排查

### 2. **快捷脚本**

| 脚本 | 功能 | 示例 |
|------|------|------|
| `slack-channels.sh` | 列出所有频道 | `bash slack-channels.sh` |
| `slack-read.sh` | 读取频道消息 | `bash slack-read.sh C079AKFJLTX 10` |
| `slack-search.sh` | 搜索消息 | `bash slack-search.sh "from:me" 20` |
| `slack-send.sh` | 发送消息 | `bash slack-send.sh U08MNQZGHBP "Hi"` |

---

## ⚠️ 消息发送规范

**所有发送到 Slack 的消息必须使用英文：**
- **Concise** - 简洁明了
- **Clear** - 表达清晰
- **Easy** - 易于理解
- **Friendly** - 友好专业

**示例：**
✅ "PR ready for review. All tests passed ✅"  
✅ "Meeting rescheduled to 2pm. See you there!"  
❌ "我已经完成了代码审查"（不要用中文）  
❌ "The aforementioned pull request has been meticulously reviewed..."（太复杂）

---

## 🚀 快速开始

### 列出所有频道
```bash
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-api-helper/slack-channels.sh
```

### 读取 #dev 频道消息
```bash
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-api-helper/slack-read.sh C079AKFJLTX 20
```

### 搜索你的消息
```bash
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-api-helper/slack-search.sh "from:me" 10
```

### 发送 DM 给自己
```bash
# ⚠️ 必须使用英文（concise, clear, easy, friendly）
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-api-helper/slack-send.sh U08MNQZGHBP "Test message. All systems go ✅"
```

---

## 🔐 Token 配置

**存储位置：** `~/.openclaw/secrets/slack-token`  
**权限：** 600（仅你可读）  
**当前权限：**
- ✅ channels:read (列出频道)
- ✅ channels:history (读取历史)
- ✅ chat:write (发送消息)
- ✅ search:read (搜索消息)
- ✅ users:read (用户信息)
- ✅ files:read/write (文件操作)
- ✅ reactions:read/write (emoji 反应)

---

## 📋 常用 Channel ID

| 频道 | Channel ID |
|------|-----------|
| `#general` | C070P69H01Z |
| `#dev` | C079AKFJLTX |
| `#aetheron-connect` | C07BK12LW4E |
| `#personal-projects` | C07972D16LE |
| **你的 DM** | D08MNQZS18V |
| **你的 User ID** | U08MNQZGHBP |

---

## 🔧 OpenClaw 集成

在 OpenClaw Agent 中调用：

**⚠️ 发送消息时必须使用英文（concise, clear, easy, friendly）**

```javascript
// 读取消息
const messages = await exec('bash ~/Desktop/CognitiveCreators/Agent\\ Skills/slack-api-helper/slack-read.sh C079AKFJLTX 20');

// 发送消息（英文，简洁友好）
await exec('bash ~/Desktop/CognitiveCreators/Agent\\ Skills/slack-api-helper/slack-send.sh U08MNQZGHBP "Task completed. Everything looks good ✅"');
```

### 推荐消息风格

**状态更新：**
- "Build finished. Ready to deploy 🚀"
- "Tests passed. No issues found ✅"
- "PR merged. Thanks for the review!"

**提醒通知：**
- "Meeting in 10 minutes. See you there!"
- "Review needed for PR #456"
- "Don't forget to update the docs 📝"

**回复确认：**
- "Got it. Will handle this today."
- "Thanks! This helps a lot 🙏"
- "Updated. Please check again."

---

## 📚 相关资源

- **Slack API 文档：** https://api.slack.com/methods
- **Token 管理：** https://api.slack.com/apps
- **Agent Skills Repo：** https://github.com/roy-songzhe-li/agent-skills

---

**创建日期：** 2026-03-25  
**作者：** Roy Li  
**测试状态：** ✅ 全部功能已验证
