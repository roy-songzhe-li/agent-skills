# Slack Web Helper - 读取消息示例

## 快速开始

### 1. 获取 Slack Workspace 和 Channel URL

打开 Slack Web，复制 URL：
```
https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN
```

### 2. 通过 OpenClaw 读取消息

在 OpenClaw 中直接调用：

```
打开 Slack 频道：https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN
等待 3 秒加载
获取页面快照
总结最近的消息
```

或者使用 browser 工具：

```javascript
// 1. 打开 Slack 频道
await tools.browser.open("https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN");

// 2. 等待页面加载
await tools.browser.act({ kind: "wait", timeMs: 3000 });

// 3. 获取页面内容
const snapshot = await tools.browser.snapshot();

// 4. AI 会自动解析 snapshot 中的消息
```

---

## 完整工作流示例

### 场景：监控 #engineering 频道并总结

```javascript
async function monitorEngineeringChannel() {
  // 1. 打开频道
  await browser.open("https://app.slack.com/client/T123/C456");
  await browser.act({ kind: "wait", timeMs: 3000 });
  
  // 2. 获取消息
  const page = await browser.snapshot();
  
  // 3. AI 总结（OpenClaw 会自动调用 LLM）
  const summary = `
    基于以下 Slack 页面内容，总结最近的重要讨论：
    ${page}
  `;
  
  // 4. 返回总结
  return summary;
}
```

---

## 发送回复示例

```javascript
async function replyToSlack(message) {
  // 1. 确保频道已打开
  await browser.act({ kind: "wait", timeMs: 1000 });
  
  // 2. 点击消息输入框
  await browser.act({
    kind: "click",
    selector: '[data-qa="message_input"]'
  });
  
  // 3. 输入消息
  await browser.act({
    kind: "type",
    text: message
  });
  
  // 4. 发送（按 Enter）
  await browser.act({
    kind: "press",
    key: "Enter"
  });
}

// 使用
await replyToSlack("AI 助手回复：已记录此任务");
```

---

## 搜索消息示例

```javascript
async function searchSlack(query) {
  // 1. 打开搜索（Cmd+F）
  await browser.act({
    kind: "press",
    key: "Meta+F"
  });
  
  await browser.act({ kind: "wait", timeMs: 500 });
  
  // 2. 输入搜索词
  await browser.act({
    kind: "type",
    text: query
  });
  
  // 3. 等待搜索结果
  await browser.act({ kind: "wait", timeMs: 2000 });
  
  // 4. 获取结果
  const results = await browser.snapshot();
  
  return results;
}

// 使用
const projectMessages = await searchSlack("sprint planning");
```

---

## 切换频道示例

```javascript
async function switchChannel(channelName) {
  // 1. 打开频道切换器（Cmd+K）
  await browser.act({
    kind: "press",
    key: "Meta+K"
  });
  
  await browser.act({ kind: "wait", timeMs: 500 });
  
  // 2. 输入频道名
  await browser.act({
    kind: "type",
    text: channelName
  });
  
  // 3. 按 Enter 进入频道
  await browser.act({
    kind: "press",
    key: "Enter"
  });
  
  await browser.act({ kind: "wait", timeMs: 2000 });
}

// 使用
await switchChannel("engineering");
```

---

## 实用技巧

### 1. 提取消息时间戳

Slack 消息通常包含时间信息，snapshot 会自动捕获。

### 2. 检测 @mention

```javascript
const page = await browser.snapshot();
if (page.includes('@roy')) {
  // 发现提及，发送通知
}
```

### 3. 批量操作

```javascript
const channels = ['engineering', 'product', 'design'];

for (const channel of channels) {
  await switchChannel(channel);
  const messages = await browser.snapshot();
  // 处理消息
}
```

---

## 与 OpenClaw Cron 集成

在 cron job 中定期检查：

```javascript
{
  "schedule": { "kind": "cron", "expr": "0 */2 * * *" },
  "payload": {
    "kind": "agentTurn",
    "message": "检查 Slack #engineering 频道最近的消息，如果有重要讨论，总结并记录到知识库"
  }
}
```

---

## 下一步

1. **测试连接：** 手动打开 Slack Web，复制 URL
2. **试运行：** 通过 OpenClaw 调用 browser 工具
3. **自动化：** 设置 cron job 定期检查
4. **优化：** 根据实际 DOM 结构调整选择器

---

**提示：** 所有操作都在 browser 工具的隔离环境中运行，不会影响你的 Desktop App！
