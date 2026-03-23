# Agent Skills

开发相关的 Agent Skills 集合。

**与 OpenClaw Skills 的区别：**
- OpenClaw Skills：存放在 `~/.openclaw/workspace/skills/`，通过 OpenClaw 安装和管理
- Agent Skills（本目录）：独立的开发工具和脚本，手动管理，专注开发工作流

## 目录结构

```
Agent Skills/
├── skill-name-1/
│   ├── README.md
│   ├── script.sh
│   └── ...
└── skill-name-2/
    └── ...
```

## 使用规则

1. 每个 skill 独立子目录
2. 必须包含 README.md 说明用途
3. 所有修改自动同步到 GitHub
4. 专注开发相关功能（编码、构建、测试、部署等）

---

**创建时间：** 2026-03-23  
**管理者：** Roy Li  
**GitHub：** https://github.com/roy-songzhe-li/agent-skills
