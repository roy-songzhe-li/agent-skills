# Bad Review Comments Examples

这些是**糟糕**的 review comments 示例，展示了应该避免的反馈模式。

---

## 命令式 / 不尊重 (Commanding / Disrespectful)

### ❌ Bad

> You should use async/await here.

**为什么不好：**
- 命令式语气
- 没有说明为什么
- 没有给作者思考空间

### ✅ Better

> Perhaps `async/await` would make the error handling clearer? It would allow us to use try/catch instead of `.catch()` chains.

---

### ❌ Bad

> This is wrong. Use Prisma instead.

**为什么不好：**
- 粗鲁、否定性强
- 没有说明为什么 "wrong"
- 强制推荐方案没有解释

### ✅ Better

> Kysely is used in the rest of the codebase for consistency. Would it make sense to align with the existing pattern, or is there a specific reason to use a different ORM here?

---

## 不清晰 / 模糊 (Vague / Unclear)

### ❌ Bad

> This doesn't look right.

**为什么不好：**
- 完全没有说明什么不对
- 没有提供任何指导
- 浪费作者时间猜测

### ✅ Better

> The token expiry calculation seems to assume 30-day months (30 * 86400), but months have different lengths. Perhaps using a date library like date-fns would be more accurate?

---

### ❌ Bad

> Fix this.

**为什么不好：**
- 完全没有说明要 fix 什么
- 命令式语气
- 零价值

### ✅ Better

> The error message is generic ("Invalid request"). Could we make it more specific, like "Checkout link has expired" or "Invalid token signature"?

---

## 过于啰嗦 / 重复 (Too Verbose / Repetitive)

### ❌ Bad

> I think that perhaps maybe we could potentially consider the possibility of using a more descriptive variable name here because it would make the code easier to understand for future developers who might be reading this code and trying to figure out what it does, which would improve the overall maintainability of the codebase in the long run.

**为什么不好：**
- 太啰嗦，冲淡重点
- 充满废话（"I think", "perhaps maybe", "potentially consider"）
- 一句话能说完的事说了三行

### ✅ Better

> Could we rename `x` to `checkoutToken` for clarity?

---

## 缺乏 Context (Lacking Context)

### ❌ Bad

> Use repository pattern.

**为什么不好：**
- 没有说明为什么
- 没有指出当前的问题
- 没有说明如何改进

### ✅ Better

> **Architecture:** Direct database queries in the route handler make testing difficult. Perhaps extracting a `CheckoutLinkRepository` would improve testability and separation of concerns?

---

### ❌ Bad

> Remove this.

**为什么不好：**
- 没有说明为什么要删除
- 可能有充分的理由存在
- 命令式语气

### ✅ Better

> **Code Simplicity:** This defensive check seems unreachable since the middleware already validates `request.auth`. Could we remove it to reduce cognitive load?

---

## 过于主观 / 个人偏好 (Too Subjective / Personal Preference)

### ❌ Bad

> I don't like this approach.

**为什么不好：**
- 纯粹个人偏好
- 没有客观理由
- 不专业

### ✅ Better

> (不 comment，除非有客观的技术理由)

---

### ❌ Bad

> This code is ugly.

**为什么不好：**
- 主观、不专业
- 没有建设性
- 伤害作者感受

### ✅ Better

> **Readability:** The nested ternaries are hard to parse. Perhaps early returns or a lookup table would be clearer?

---

## 缺乏建设性 (Not Constructive)

### ❌ Bad

> This is terrible.

**为什么不好：**
- 纯粹负面
- 零建设性
- 打击作者积极性

### ✅ Better

> **Performance:** The N+1 query pattern here could become slow with many records. Could we batch-fetch all users in a single query?

---

### ❌ Bad

> Did you even test this?

**为什么不好：**
- 质疑作者能力
- 不尊重
- 没有指出具体问题

### ✅ Better

> **Potential Bug:** It looks like `result.data` might be `undefined` when the API returns an error. Perhaps adding a null check or using optional chaining would prevent runtime errors?

---

## 过度 Nitpick (Excessive Nitpicking)

### ❌ Bad

> Missing space after comma.

**为什么不好：**
- 这是 linter/prettier 的工作
- 浪费 review 时间
- 没有实际价值

### ✅ Better

> (不 comment，让自动化工具处理)

---

### ❌ Bad

> Use single quotes instead of double quotes.

**为什么不好：**
- 纯粹风格偏好
- 应该在 ESLint 配置中统一
- 不值得 review 时间

### ✅ Better

> (配置 ESLint/Prettier，不手动 comment)

---

## 重复已有 Comments (Duplicate Comments)

### ❌ Bad

> (已有人指出) Use repository pattern here.
> 
> (你又重复) Yeah, repository pattern would be better.

**为什么不好：**
- 浪费作者时间
- 增加噪音
- 没有新价值

### ✅ Better

> +1 to @alice's suggestion about repository pattern. It would also help with mocking in unit tests.

(或者直接 👍 react，不额外 comment)

---

## 没有引用具体代码 (No Specific Reference)

### ❌ Bad

> Some of the functions are too long.

**为什么不好：**
- 没有指出哪些函数
- 作者需要猜测
- 不 actionable

### ✅ Better

> **Readability:** The `processCheckout()` function is ~200 lines. Could we extract the token validation and session creation logic into separate helper functions?

---

## 质疑动机而非代码 (Questioning Intent, Not Code)

### ❌ Bad

> Why did you even write it this way?

**为什么不好：**
- 质疑作者的决策过程
- 可能是defensive
- 不专业

### ✅ Better

> **Curiosity:** Is there a specific reason for using `Buffer` here instead of the built-in `TextEncoder`? Just wondering if there's a performance consideration I'm missing.

---

## 绝对化 / 过度自信 (Absolutist / Overconfident)

### ❌ Bad

> This will definitely break in production.

**为什么不好：**
- 过度自信
- 可能是误判
- 没有说明具体场景

### ✅ Better

> **Potential Issue:** The hardcoded timeout of 5s might be too short for slow network conditions. Perhaps making it configurable or using a retry mechanism would be more robust?

---

### ❌ Bad

> This must be changed immediately.

**为什么不好：**
- 命令式
- 制造紧迫感但可能不必要
- 没有说明为什么"必须"

### ✅ Better

> **Security:** This endpoint is missing authentication. Could we add the `auth` middleware to prevent unauthorized access?

---

## 过时的知识 / 错误信息 (Outdated Knowledge / Wrong Info)

### ❌ Bad

> You should use `var` instead of `let` for better compatibility.

**为什么不好：**
- 完全错误的建议
- 显示缺乏现代 JS 知识
- 会让代码变差

### ✅ Better

> (不 comment，因为建议是错的)

---

## 混合多个问题 (Mixing Multiple Issues)

### ❌ Bad

> This function is too long, uses the wrong naming convention, has poor error handling, and should be async. Also the comments are outdated and there's a typo in the docstring.

**为什么不好：**
- 一次提太多问题
- 作者不知道从哪里开始
- 应该分成多个 comments

### ✅ Better

> (拆成多个 inline comments，每个关注一个问题)

---

## Summary

糟糕的 review comments 特点：

1. **Commanding** - 命令式语气，不尊重作者
2. **Vague** - 模糊不清，没有具体指出问题
3. **Verbose** - 过于啰嗦，冲淡重点
4. **Subjective** - 纯粹个人偏好，没有客观理由
5. **Unconstructive** - 只批评不提供解决方案
6. **Nitpicky** - 过度关注微小细节（应该自动化）
7. **Duplicate** - 重复已有的 comments
8. **Absolute** - 过度自信，缺乏 tentative language
9. **Wrong** - 基于错误或过时的知识

---

## How to Improve

1. **Use tentative language** - "Perhaps", "Could", "Might"
2. **Be specific** - 引用具体文件、行、代码段
3. **Provide context** - 说明为什么重要，有什么影响
4. **Offer solutions** - 不仅指出问题，还提供改进方向
5. **Be respectful** - 尊重作者的工作和决策
6. **Be concise** - 一句话说清楚
7. **Categorize** - 使用标签（Security, DRY, etc.）
8. **Check for duplicates** - 不重复已有 comments
9. **Ask questions** - 使用问句形式，给作者思考空间
10. **Recognize good work** - 也要认可好的实践
