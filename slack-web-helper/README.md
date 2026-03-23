# Slack Web Helper

**不占用 Desktop App 的 Slack 消息访问方案**

---

## 🎯 核心优势

✅ **不占用 Desktop App** - 通过 Slack Web 访问  
✅ **后台运行** - 使用 OpenClaw browser 工具  
✅ **零配置** - 复用浏览器登录状态  
✅ **完整功能** - 读取/发送/搜索消息  

---

## 📋 方案对比

| 方案 | 占用 Desktop | 配置复杂度 | 功能完整性 |
|------|--------------|------------|------------|
| **Slack Web Helper** | ❌ 不占用 | ✅ 零配置 | ✅ 完整 |
| CDP Desktop | ✅ 占用 | ❌ 需要重启 | ✅ 完整 |
| User Token API | ❌ 不占用 | ⚠️ 需提取token | ✅ 完整 |

---

## 🚀 快速开始

### 1. 获取 Slack URL

打开 Slack Web，复制 URL：
```
https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN
                           ↑           ↑
                      Workspace   Channel
```

### 2. 通过 OpenClaw 读取消息

```
打开这个 Slack 频道并读取最近 20 条消息：
https://app.slack.com/client/T123/C456
```

OpenClaw 会自动：
1. 打开 browser 工具
2. 访问 Slack Web
3. 获取页面快照
4. 解析消息内容

### 3. 发送回复

```
在当前 Slack 频道发送消息："AI 助手已查看"
```

---

## 📚 文档

- **[SKILL.md](./SKILL.md)** - 完整功能说明
- **[read-messages.md](./read-messages.md)** - 使用示例和代码

---

## 🔧 技术实现

```
Slack Web (app.slack.com)
    ↓
OpenClaw Browser Tool
    ↓
Chrome (headless)
    ↓
Snapshot + AI 解析
    ↓
消息提取/回复
```

---

## 💡 使用场景

### 1. 监控重要频道
```
每 2 小时检查 #engineering 频道，如果有 @mention 我，总结消息
```

### 2. 自动回复
```
查看 #support 频道最新消息，如果有人求助，回复"收到，正在处理"
```

### 3. 消息搜索
```
在 Slack 中搜索"sprint planning"相关的讨论
```

---

## ⚠️ 限制

1. **需要登录：** 确保 Chrome 中已登录 Slack
2. **速度：** 比直接 API 慢（需加载页面）
3. **URL 必需：** 需要知道 Workspace/Channel ID

---

## 📦 安装

无需安装！OpenClaw 的 `browser` 工具已内置。

---

**创建日期：** 2026-03-23  
**作者：** Roy Li  
**GitHub：** https://github.com/roy-songzhe-li/agent-skills/tree/main/slack-web-helper
