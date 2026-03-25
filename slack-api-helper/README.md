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
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-api-helper/slack-send.sh U08MNQZGHBP "测试消息"
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

```javascript
// 读取消息
const messages = await exec('bash ~/Desktop/CognitiveCreators/Agent\\ Skills/slack-api-helper/slack-read.sh C079AKFJLTX 20');

// 发送消息
await exec('bash ~/Desktop/CognitiveCreators/Agent\\ Skills/slack-api-helper/slack-send.sh U08MNQZGHBP "AI 助手回复"');
```

---

## 📚 相关资源

- **Slack API 文档：** https://api.slack.com/methods
- **Token 管理：** https://api.slack.com/apps
- **Agent Skills Repo：** https://github.com/roy-songzhe-li/agent-skills

---

**创建日期：** 2026-03-25  
**作者：** Roy Li  
**测试状态：** ✅ 全部功能已验证
