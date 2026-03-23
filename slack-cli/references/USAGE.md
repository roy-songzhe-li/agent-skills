# Slack CLI 使用指南

## 快速开始

### 1. 启动 Slack 调试模式

```bash
bash ~/Desktop/CognitiveCreators/Agent\ Skills/slack-cli/start-slack-debug.sh
```

这会：
- 关闭现有 Slack 进程
- 启动 Slack 并启用 CDP（端口 9233）
- 显示验证和测试命令

### 2. 设置环境变量

```bash
export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"
```

或者添加到 shell 配置文件：

```bash
echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"' >> ~/.zshrc
source ~/.zshrc
```

### 3. 重建 OpenCLI

```bash
cd ~/Desktop/CognitiveCreators/opencli
npm run build
```

### 4. 测试命令

```bash
# 检查连接状态
opencli slack-app status

# 读取消息
opencli slack-app read --count 20

# 发送消息
opencli slack-app send "Hello from CLI!"

# 列出频道
opencli slack-app channels

# 搜索消息
opencli slack-app search "project" --limit 10
```

## 常见问题

### Q: 为什么需要重启 Slack？

A: CDP (Chrome DevTools Protocol) 只能在启动时通过 `--remote-debugging-port` 参数启用。

### Q: 如何验证 CDP 连接？

A: 打开浏览器访问 `http://127.0.0.1:9233`，应该看到 Slack 的调试页面。

### Q: 命令找不到消息输入框怎么办？

A: 确保 Slack 中打开了一个频道或 DM，并且消息输入框可见。

### Q: 如何在 OpenClaw 中使用？

A: 通过 `exec` 工具调用：

```javascript
// 读取 Slack 消息
const result = await exec('opencli slack-app read --count 50');

// 发送回复
await exec('opencli slack-app send "AI 助手回复：任务已记录"');
```

## 高级用法

### 自动化工作流

```bash
# 1. 切换到特定频道（需要实现 switch-channel 命令）
# 2. 读取未读消息
messages=$(opencli slack-app read --count 100)

# 3. 用 AI 总结
echo "$messages" | ai summarize

# 4. 发送总结
opencli slack-app send "📊 频道总结：..."
```

### 定期检查消息

在 OpenClaw 中设置 cron job：

```bash
opencli cron add \
  --name "Slack 消息检查" \
  --schedule "0 */2 * * *" \
  --command "opencli slack-app read --count 50 | ai analyze"
```

## 与 OpenClaw Agent Skills 集成

在 Agent Skill 的 SKILL.md 中：

```markdown
## Slack 消息访问

使用 OpenCLI Slack 适配器读取和发送消息。

**示例：**
```bash
# 读取频道消息
opencli slack-app read --count 20

# 发送回复
opencli slack-app send "收到，我会处理"
```

## 调试

### 查看 CDP 连接

```bash
curl http://127.0.0.1:9233/json
```

### OpenCLI 调试模式

```bash
DEBUG=opencli:* opencli slack-app status
```

---

**最后更新：** 2026-03-23
