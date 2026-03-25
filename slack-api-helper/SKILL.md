# Slack API Helper - Agent Skill

**名称：** slack-api-helper  
**用途：** 基于 Slack User Token 的完整 API 集成  
**类型：** REST API  
**状态：** 可用

---

## 一句话介绍

通过 Slack User Token 实现完整的 Slack 操作：读取频道/DM、搜索消息、发送消息、管理反应等。

---

## 功能

### ✅ 读取功能
- 列出所有频道
- 读取频道/DM 历史消息
- 搜索消息（跨频道）
- 获取用户信息
- 列出团队成员

### ✅ 写入功能
- 发送 DM
- 发送到频道
- 添加 emoji 反应
- 编辑/删除消息
- 上传文件

---

## 配置

### Token 存储位置
`~/.openclaw/secrets/slack-token`

### 环境变量
```bash
export SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
```

或在 OpenClaw 配置中添加：
```json
{
  "env": {
    "SLACK_TOKEN": "xoxp-..."
  }
}
```

---

## 使用方式

### 1. 列出频道

```bash
curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  'https://slack.com/api/conversations.list?types=public_channel,private_channel&limit=50' \
  | jq -r '.channels[] | "\(.name) (\(.id))"'
```

### 2. 读取频道消息

```bash
CHANNEL_ID="C079AKFJLTX"  # #dev
curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  "https://slack.com/api/conversations.history?channel=$CHANNEL_ID&limit=20" \
  | jq '.messages[] | {text, user, ts}'
```

### 3. 搜索消息

```bash
curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  'https://slack.com/api/search.messages?query=from:me&count=10' \
  | jq '.messages.matches[] | {text, channel: .channel.name}'
```

### 4. 发送 DM

```bash
USER_ID="U08MNQZGHBP"  # Roy
curl -X POST -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  'https://slack.com/api/chat.postMessage' \
  -d "{\"channel\":\"$USER_ID\",\"text\":\"Hello from API\"}"
```

### 5. 发送到频道

```bash
CHANNEL_ID="C079AKFJLTX"  # #dev
curl -X POST -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  'https://slack.com/api/chat.postMessage' \
  -d "{\"channel\":\"$CHANNEL_ID\",\"text\":\"Message from bot\"}"
```

### 6. 添加 emoji 反应

```bash
CHANNEL_ID="C079AKFJLTX"
MESSAGE_TS="1774435153.936579"
curl -X POST -H "Authorization: Bearer $SLACK_TOKEN" \
  'https://slack.com/api/reactions.add' \
  -d "channel=$CHANNEL_ID&timestamp=$MESSAGE_TS&name=thumbsup"
```

---

## OpenClaw 集成

### 在 Agent 中调用

```javascript
// 读取 #dev 频道消息
const token = await exec('cat ~/.openclaw/secrets/slack-token');
const messages = await exec(`
  curl -s -H "Authorization: Bearer ${token}" \
    'https://slack.com/api/conversations.history?channel=C079AKFJLTX&limit=20'
`);

// 发送消息
await exec(`
  curl -X POST -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    'https://slack.com/api/chat.postMessage' \
    -d '{"channel":"U08MNQZGHBP","text":"AI 助手回复"}'
`);
```

### 快捷脚本

创建 `~/Desktop/CognitiveCreators/Agent Skills/slack-api-helper/slack-read.sh`：

```bash
#!/bin/bash
SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
CHANNEL="${1:-C079AKFJLTX}"
LIMIT="${2:-20}"

curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  "https://slack.com/api/conversations.history?channel=$CHANNEL&limit=$LIMIT" \
  | jq -r '.messages[] | "\(.user): \(.text)"'
```

使用：
```bash
bash slack-read.sh C079AKFJLTX 10  # 读取 #dev 最近 10 条消息
```

---

## 常用频道 ID

根据测试结果，你的工作区常用频道：

| 频道名称 | Channel ID | 成员数 |
|---------|-----------|--------|
| `#general` | C070P69H01Z | 22 |
| `#dev` | C079AKFJLTX | 23 |
| `#aetheron-connect` | C07BK12LW4E | 23 |
| `#personal-projects` | C07972D16LE | 5 |
| `#random` | C070GLK3Y14 | 20 |

你的 DM Channel ID: `D08MNQZS18V`  
你的 User ID: `U08MNQZGHBP`

---

## API 参考

### 常用 Endpoints

| 功能 | Endpoint | 方法 |
|------|----------|------|
| 列出频道 | `/conversations.list` | GET |
| 读取历史 | `/conversations.history` | GET |
| 搜索消息 | `/search.messages` | GET |
| 发送消息 | `/chat.postMessage` | POST |
| 添加反应 | `/reactions.add` | POST |
| 用户信息 | `/users.info` | GET |
| 上传文件 | `/files.upload` | POST |

完整文档：https://api.slack.com/methods

---

## 安全提示

1. **Token 保护：** 绝不在代码中硬编码 token
2. **权限范围：** 仅使用必要的 API
3. **频率限制：** Slack 有 API 调用限制
4. **错误处理：** 检查 API 返回的 `ok` 字段

---

## 故障排查

### 401 Unauthorized
- 检查 token 是否正确
- 验证：`curl -H "Authorization: Bearer $SLACK_TOKEN" https://slack.com/api/auth.test`

### missing_scope
- Token 缺少对应权限
- 访问 https://api.slack.com/apps 重新生成 token

### channel_not_found
- 检查 Channel ID 是否正确
- 使用 `conversations.list` 获取正确 ID

---

## Tags

#slack #api #rest #messaging #automation #token

---

**创建日期：** 2026-03-25  
**作者：** Roy Li  
**测试状态：** ✅ 读取和写入功能均已验证
