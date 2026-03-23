# Slack Web Helper - Agent Skill

**名称：** slack-web-helper  
**用途：** 通过 Slack Web 访问和回复消息（不占用 Desktop App）  
**类型：** Browser Automation  
**状态：** 可用

---

## 一句话介绍

通过 OpenClaw 的 `browser` 工具访问 Slack Web，在后台读取和回复消息，不干扰你正常使用 Slack Desktop App。

---

## 功能

- ✅ 读取频道/DM 消息
- ✅ 发送消息（使用你的身份）
- ✅ 搜索消息历史
- ✅ 不占用 Desktop App
- ✅ 可以在后台运行

---

## 使用方式

### 1. 读取消息

```javascript
// 打开 Slack Web
await browser.open("https://app.slack.com/client/YOUR_WORKSPACE_ID/CHANNEL_ID");

// 等待加载
await browser.act({ kind: "wait", timeMs: 2000 });

// 获取页面快照
const snapshot = await browser.snapshot();

// 提取消息内容
// snapshot 会包含页面上的所有文本和元素
```

### 2. 发送消息

```javascript
// 找到消息输入框并输入
await browser.act({
  kind: "fill",
  selector: '[data-qa="message_input"]',
  text: "Hello from AI assistant"
});

// 按 Enter 发送
await browser.act({
  kind: "press",
  key: "Enter"
});
```

### 3. 搜索消息

```javascript
// 打开搜索（Cmd+F）
await browser.act({
  kind: "press",
  key: "Meta+F"
});

// 输入搜索词
await browser.act({
  kind: "type",
  text: "project deadline"
});

// 等待搜索结果
await browser.act({ kind: "wait", timeMs: 1500 });

// 获取搜索结果
const results = await browser.snapshot();
```

---

## 完整示例脚本

创建 `read-slack.js`：

```javascript
// 读取 Slack 频道消息的示例脚本

// 1. 打开 Slack Web
await browser.open("https://app.slack.com/client/T123/C456");
await browser.act({ kind: "wait", timeMs: 3000 });

// 2. 获取页面内容
const page = await browser.snapshot();

// 3. 提取消息（通过 snapshot 中的文本）
// OpenClaw 会自动解析页面内容

// 4. 发送回复
await browser.act({
  kind: "click",
  selector: '[data-qa="message_input"]'
});

await browser.act({
  kind: "type",
  text: "AI 助手已查看此消息"
});

await browser.act({
  kind: "press",
  key: "Enter"
});
```

---

## 获取 Workspace 和 Channel ID

### 方法 1：从 URL 提取

打开 Slack Web，URL 格式：
```
https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN
                              ↑           ↑
                         Workspace ID  Channel ID
```

### 方法 2：通过 API

```bash
# 如果有 User Token
curl -H "Authorization: Bearer xoxp-..." \
  https://slack.com/api/conversations.list
```

---

## 与 OpenClaw Agent 集成

在 Agent Skill 或 cron job 中调用：

```javascript
// 定期检查 Slack 消息
async function checkSlackMessages() {
  // 打开频道
  await browser.open("https://app.slack.com/client/T123/C456");
  await browser.act({ kind: "wait", timeMs: 2000 });
  
  // 获取内容
  const snapshot = await browser.snapshot();
  
  // AI 分析消息
  const summary = await ai.analyze(snapshot);
  
  // 如果需要回复
  if (summary.needsReply) {
    await browser.act({
      kind: "fill",
      selector: '[data-qa="message_input"]',
      text: summary.replyText
    });
    
    await browser.act({ kind: "press", key: "Enter" });
  }
}
```

---

## 优势

| 特性 | Slack Web Helper | CDP Desktop |
|------|------------------|-------------|
| **占用 Desktop App** | ❌ 不占用 | ✅ 占用 |
| **后台运行** | ✅ 可以 | ❌ 需要前台 |
| **登录状态** | ✅ 复用浏览器登录 | ✅ 复用应用登录 |
| **配置复杂度** | ✅ 零配置 | ❌ 需要重启 Slack |
| **稳定性** | ✅ 高（Web 界面稳定） | ⚠️ 中（依赖应用版本） |

---

## 限制

1. **首次需要登录：** 确保 Chrome 中已登录 Slack
2. **Workspace/Channel ID：** 需要知道 URL 中的 ID
3. **速度：** 比 API 慢（需要等待页面加载）
4. **DOM 变化：** Slack 更新时可能需要调整选择器

---

## 故障排查

### 找不到消息输入框

尝试不同的选择器：

```javascript
// 选择器选项
'[data-qa="message_input"]'
'[role="textbox"][aria-label*="message"]'
'.ql-editor'
```

### 页面加载慢

增加等待时间：

```javascript
await browser.act({ kind: "wait", timeMs: 5000 });
```

---

## 相关资源

- **OpenClaw Browser Tool:** 内置工具，无需安装
- **Slack Web:** https://app.slack.com
- **Agent Skills Repo:** https://github.com/roy-songzhe-li/agent-skills

---

## Tags

#slack #browser-automation #openclaw #messaging #no-cdp

---

**创建日期：** 2026-03-23  
**作者：** Roy Li  
**优势：** 不占用 Desktop App
