# Architecture Rules

根据下面的规则 Review 代码，确保这个 branch 内所有的代码变动没有违反下面的约束。

## 核心原则

**质问每一行代码：** 每次 review 时问："这真的必须吗？框架/library 是否已提供？有更简单的方式吗？" 避免过度防御式编程和不必要的抽象层。

**Every line of code must earn its keep. Remove unnecessary abstractions.**

---

## 36 条架构规则

### 架构与分层 (Architecture & Layering)

**1. 架构问题：缺少 repository layer，代码分层不清晰**
- Service 层应通过 repository 访问数据库，而非直接调用 Kysely
- 保持清晰的分层：route → service → repository → database

**19. API 端规范：route handler 只做参数校验、鉴权、调用 service、返回结果**
- 不要把业务逻辑和数据库查询全写在 route 文件里
- 业务逻辑属于 service 层

**33. PR 专注性原则：不要在功能 PR 中混入对基础设施的改动**
- CRUD Factory、全局工具函数等应独立 PR 处理
- 保持 PR 的单一职责

### 安全 (Security)

**2. 安全问题：使用 `getDb()` 绕过 RLS（最严重）**
- 必须使用 `request.db()` 或 `withScopedDb()` 确保 RLS 生效
- `getDb()` 仅用于系统级操作（需要明确注释说明原因）

**7. 请求处理原则：先检查 `request.auth` 有什么，再决定是否需要数据库查询**
- 避免不必要的数据库查询
- 利用 auth context 中已有的信息

**24. API 路由设计：可从 auth context 获取的信息（如 org ID）不要作为路径参数**
- 避免重复传递和忘记验证的安全风险
- 使用 `request.auth.orgId` 而非 `/api/org/:orgId/...`

**27. 敏感数据加密：Twilio auth_token 等敏感凭证应使用应用层加密（AES-256-GCM）**
- 密钥存于 SSM
- 在 repository 层透明加密/解密

**28. 信任 middleware 保证：受 RBAC 保护的路由（`roles: ['org_owner']`）无需再检查 `request.auth`**
- Middleware 已保证其存在且有效
- 避免冗余的权限检查

**36. 所有新添加的 env 要用 chamber 放到 SSM 里**
- 不要使用 `.env` 文件存储生产配置
- 使用 AWS SSM Parameter Store 集中管理

### 冗余与重复 (Redundancy & DRY)

**3. 冗余代码：手写 actions 而不用生成的 client**
- 使用自动生成的 API client
- 避免手写 fetch 逻辑

**26. 代码简洁性原则：删除"防御性"但实际上永不执行的代码**
- 如不存在的 legacy 数据迁移
- 代码应反映真实需求而非假设场景

**30. 信任框架行为：Kysely 的 `.set()` 自动跳过 `undefined` 值**
- 无需手写条件过滤
- 要设置 `NULL` 显式传 `null`，`undefined` 表示"不更新此字段"

**35. 质问每一行代码：每次 review 时问："这真的必须吗？框架/library 是否已提供？有更简单的方式吗？"**
- 避免过度防御式编程
- 避免不必要的抽象层

### 设计系统与组件 (Design System & Components)

**4. 不一致性：不使用 Design System，自定义组件**
- 优先使用团队的 Design System 组件
- 避免重复造轮子

**8. 组件规范：尽可能不要使用原生 HTML 组件，而是使用 Design System 里的组件**
- 使用 `<Button>` 而非 `<button>`
- 使用 `<Input>` 而非 `<input>`

**18. Web 端组件职责规范：组件不要自己管理一堆 loading 和 message 状态**
- 使用 React Query 或团队统一的状态管理
- 让全局 error boundary 处理错误

**23. Web 端错误处理：让 query client 全局处理，组件不要手动渲染 `mutation.error`**
- 使用 `onError` callback 或全局 error boundary
- 避免每个组件都写错误处理 UI

### API 设计 (API Design)

**5. API 设计问题：为什么需要在 body 里传 id**
- 从 auth context 或路径参数获取 id
- 避免冗余参数

**31. REST 语义规范：幂等操作（如 upsert）应使用 PUT 而非 POST**
- 路径应简洁（`PUT /resource` 优于 `POST /resource/create-and-submit`）
- 遵循 HTTP 方法语义

**32. Webhook 错误处理：允许 webhook 在验证失败时抛出 4xx 错误（而非总是返回 200）**
- 便于监控告警和临时错误重试
- 成功返回 `204 No Content`

### 类型安全 (Type Safety)

**6. 类型安全问题：SDK response 类型改动需要解释**
- 说明为什么修改类型定义
- 确保不破坏现有代码

**14. Web 端数据返回规范：所有返回数据都必须有类型**
- 使用 TypeScript 类型或 Typebox schema
- 避免 `any` 或 `unknown`

**15. Web 端数据访问规范：不要使用 `Reflect.get`**
- 使用类型安全的属性访问
- 让 TypeScript 检查类型错误

**16. Web 端不确定后端返回时：使用 Typebox 校验后再进入业务逻辑**
- 运行时验证不可信数据
- 提供清晰的错误信息

**20. 优先使用 SDK 定义的类型而不是 TypeBox 自己定义**
- 避免类型重复定义
- 利用 SDK 的类型推导

**21. 第三方 SDK 类型：优先使用 SDK 原生类型，不要用 TypeBox 重新定义**
- 除非验证不可信输入如 webhook
- 保持类型一致性

**22. TypeBox schema 使用：在路由层定义并在模块间共享，不要在 service 层写手动类型守卫函数**
- Schema 作为 single source of truth
- 复用类型定义

**29. 避免不必要的类型复杂度：单一操作场景不需要 `Db | Transaction` union type**
- 只用简单的 `Db` 类型除非真正需要同时支持两者
- 保持类型简单

### Web 端规范 (Frontend Standards)

**9. Web 端获取用户信息或 claims 时：优先使用 session 或团队 auth helper**
- 不要直接读取 cookie 或 localStorage
- 使用统一的认证 API

**10. Web 端获取用户信息或 claims 时：不要 decode JWT**
- JWT 解码应在后端完成
- 前端只使用后端提供的用户信息

**11. Web 端调用后端 API 时：优先使用 server action 或 API client**
- 不要手写 fetch 逻辑
- 利用类型安全的 API 封装

**12. Web 端调用后端 API 时：不要在页面 `useEffect` 里手写 fetch**
- 使用 React Query 或 SWR
- 避免竞态条件和内存泄漏

**13. Web 端调用后端 API 时：不要为了转发再造 Next `/api` route，除非团队明确需要**
- 直接从 server component 调用后端
- 减少不必要的中间层

**17. Web 端表单提交和请求状态：使用 react query mutation 或团队统一 pattern**
- 统一的 loading/error/success 状态管理
- 避免手写状态机

### 数据库规范 (Database Standards)

**25. 数据库 migration 规范：对租户表使用 `createTenantTable()` helper**
- 自动处理复合主键、RLS、索引等标准配置
- 避免手写重复的数据库设置代码

### 日志与监控 (Logging & Monitoring)

**34. 日志 context 规范：在 route handler 中使用 `request.log` 而非全局 `logger`**
- 保留 request context（requestId、traceId、spanId）
- 支持分布式追踪

---

## Review Checklist

每次 Review 时，按以下顺序检查：

1. ✅ **安全问题** - 规则 2, 7, 24, 27, 28, 36
2. ✅ **架构分层** - 规则 1, 19, 33
3. ✅ **类型安全** - 规则 6, 14, 15, 16, 20, 21, 22, 29
4. ✅ **API 设计** - 规则 5, 31, 32
5. ✅ **代码冗余** - 规则 3, 26, 30, 35
6. ✅ **组件规范** - 规则 4, 8, 18, 23
7. ✅ **Web 端规范** - 规则 9, 10, 11, 12, 13, 17
8. ✅ **数据库规范** - 规则 25
9. ✅ **日志规范** - 规则 34

---

## Priority Levels

- **🔴 Blocker** - 安全问题、绕过 RLS、明显 bug（必须修复才能合并）
- **🟠 Major** - 架构违规、类型安全问题（强烈建议修复）
- **🟡 Minor** - 代码冗余、不一致性（建议改进）
- **⚪ Nitpick** - 代码风格、微小改进（可选）

根据发现的问题严重程度决定 review 状态：
- 有 🔴 Blocker → **REQUEST_CHANGES**
- 只有 🟠 Major → **COMMENT**（建议修复）
- 只有 🟡 Minor 或 ⚪ Nitpick → **APPROVE**（可合并）
