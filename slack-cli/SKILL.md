# Slack CLI - Agent Skill

**名称：** slack-cli  
**用途：** 通过 CDP 控制 Slack Desktop App，代表用户读取和发送消息  
**类型：** OpenCLI Adapter  
**状态：** 开发中

---

## 一句话介绍

通过 Chrome DevTools Protocol (CDP) 控制 Slack Desktop App，让 AI Agent 代表你访问和回复 Slack 消息。

---

## 功能

- ✅ 读取频道/DM 消息
- ✅ 发送消息（使用你的身份，非 Bot）
- ✅ 搜索消息历史
- ✅ 列出频道和成员
- ✅ 检查连接状态

---

## 安装与配置

### 1. 启动 Slack 调试模式

```bash
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-cli/start-slack-debug.sh
```

### 2. 设置环境变量

```bash
export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"
```

或永久添加到 shell 配置：

```bash
echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"' >> ~/.zshrc
source ~/.zshrc
```

### 3. 验证连接

```bash
opencli slack-app status
```

---

## 命令列表

| 命令 | 描述 | 示例 |
|------|------|------|
| `status` | 检查 CDP 连接，显示当前工作区/频道 | `opencli slack-app status` |
| `read` | 读取当前频道消息 | `opencli slack-app read --count 20` |
| `send` | 发送消息到当前频道 | `opencli slack-app send "Hello"` |
| `channels` | 列出所有频道（含未读数） | `opencli slack-app channels` |
| `search` | 搜索消息 | `opencli slack-app search "project"` |

---

## 使用场景

### 场景 1：监控 Slack 消息

```bash
# 读取最新 50 条消息
opencli slack-app read --count 50

# 检查是否有 @mention
opencli slack-app read --count 100 | grep "@roy"
```

### 场景 2：自动回复

```bash
# AI 分析消息后自动回复
opencli slack-app read --count 10 | ai analyze
opencli slack-app send "收到，我会处理这个问题"
```

### 场景 3：搜索历史消息

```bash
# 搜索项目相关讨论
opencli slack-app search "sprint planning" --limit 20
```

### 场景 4：频道管理

```bash
# 列出所有频道和未读数
opencli slack-app channels

# 切换到特定频道（需手动或脚本实现）
# opencli slack-app switch-channel "engineering"
```

---

## 与 OpenClaw 集成

### 在 Agent Skill 中调用

```javascript
// 读取 Slack 消息
const messages = await exec('opencli slack-app read --count 20');

// 发送回复
await exec('opencli slack-app send "AI 助手回复：任务已记录"');
```

### 在 Cron Job 中使用

```bash
opencli cron add \
  --name "Slack 消息检查" \
  --schedule "0 */2 * * *" \
  --payload '{"kind":"agentTurn","message":"检查 Slack 消息并总结"}'
```

---

## 技术架构

```
Slack Desktop App (Electron)
    ↓
Chrome DevTools Protocol (CDP)
    ↓
http://127.0.0.1:9233
    ↓
OpenCLI Slack Adapter (TypeScript)
    ↓
CLI 命令
    ↓
OpenClaw Agent / 用户脚本
```

---

## 开发状态

- [x] 项目结构
- [x] TypeScript 命令实现
- [x] 启动脚本
- [x] 文档和使用指南
- [ ] DOM 选择器验证（需要测试）
- [ ] 错误处理和边界情况
- [ ] 单元测试
- [ ] 发布到 ClawHub

---

## 限制与注意事项

1. **需要重启 Slack：** CDP 只能在启动时启用
2. **DOM 选择器可能变化：** Slack 更新时可能需要调整选择器
3. **频道必须打开：** 发送消息时需要在 Slack 中打开目标频道
4. **非官方 API：** Slack 官方不支持 CDP 控制，仅供个人使用

---

## 相关资源

- **OpenCLI 项目：** https://github.com/jackwener/opencli
- **Agent Skills Repo：** https://github.com/roy-songzhe-li/agent-skills
- **使用指南：** [USAGE.md](./USAGE.md)
- **启动脚本：** [start-slack-debug.sh](./start-slack-debug.sh)

---

## Tags

#slack #opencli #cdp #agent #automation #messaging

---

**创建日期：** 2026-03-23  
**作者：** Roy Li  
**GitHub：** https://github.com/roy-songzhe-li/agent-skills/tree/main/slack-cli
