# Slack CLI - OpenCLI Adapter

通过 Chrome DevTools Protocol (CDP) 控制 Slack Desktop App。

## 功能

- ✅ 读取频道/DM 消息
- ✅ 发送消息（代表用户）
- ✅ 搜索消息历史
- ✅ 切换频道/工作区
- ✅ 列出频道和成员

## 安装

### 1. 启动 Slack 并启用远程调试

**macOS:**
```bash
# 关闭现有 Slack 进程
pkill -9 Slack

# 启动 Slack 并启用 CDP
/Applications/Slack.app/Contents/MacOS/Slack --remote-debugging-port=9233
```

**验证连接:**
打开浏览器访问 `http://127.0.0.1:9233`，应该看到 CDP 调试界面。

### 2. 配置环境变量

```bash
export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"
```

或者在 `~/.zshrc` / `~/.bashrc` 中添加：
```bash
echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"' >> ~/.zshrc
source ~/.zshrc
```

### 3. 注册到 OpenCLI

```bash
cd ~/Desktop/CognitiveCreators/opencli
npm run build

# 测试命令
opencli slack-app status
```

## 命令列表

| 命令 | 描述 | 示例 |
|------|------|------|
| `opencli slack-app status` | 检查 CDP 连接状态 | `opencli slack-app status` |
| `opencli slack-app read` | 读取当前频道消息 | `opencli slack-app read --count 20` |
| `opencli slack-app send "text"` | 发送消息到当前频道 | `opencli slack-app send "Hello from CLI"` |
| `opencli slack-app channels` | 列出所有频道 | `opencli slack-app channels` |
| `opencli slack-app search "query"` | 搜索消息 | `opencli slack-app search "project"` |
| `opencli slack-app switch-channel "name"` | 切换到指定频道 | `opencli slack-app switch-channel "general"` |

## 使用场景

### 1. 读取未读消息
```bash
opencli slack-app read --count 50 | grep "unread"
```

### 2. 自动回复
```bash
opencli slack-app send "收到，我稍后处理"
```

### 3. 搜索历史消息
```bash
opencli slack-app search "deadline" --limit 10
```

### 4. 批量操作
```bash
# 切换频道 → 读取消息 → AI 总结
opencli slack-app switch-channel "engineering"
opencli slack-app read --count 100 | ai summarize
```

## 与 OpenClaw 集成

在 OpenClaw 的 `AGENTS.md` 或 skill 中调用：

```javascript
// 读取 Slack 消息
const messages = await exec('opencli slack-app read --count 20');

// 发送回复
await exec('opencli slack-app send "AI 助手回复：..."');
```

## 架构

```
Slack Desktop App
    ↓ (启用 CDP)
http://127.0.0.1:9233
    ↓
OpenCLI Slack Adapter
    ↓
TypeScript 命令实现
    ↓
OpenCLI CLI
```

## 技术实现

- **CDP 连接:** Chrome DevTools Protocol
- **DOM 操作:** `page.evaluate()` 执行 JavaScript
- **消息提取:** 解析 Slack 的 DOM 结构
- **输入模拟:** `document.execCommand()` + `pressKey()`

## 开发状态

- [x] 项目结构
- [ ] CDP 连接实现
- [ ] `status` 命令
- [ ] `read` 命令
- [ ] `send` 命令
- [ ] `channels` 命令
- [ ] `search` 命令
- [ ] 文档和测试

---

**创建日期:** 2026-03-23  
**作者:** Roy Li  
**GitHub:** https://github.com/roy-songzhe-li/agent-skills/tree/main/slack-cli
