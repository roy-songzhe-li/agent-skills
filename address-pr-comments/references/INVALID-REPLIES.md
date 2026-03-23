# Invalid Reply Examples

当 review comment 不是真实问题或不在当前 PR scope 内时，如何礼貌地回复。

---

## 回复原则

1. **礼貌、谦虚** - 使用 tentative language
2. **简洁** - 一句话说清楚
3. **提供理由** - 说明为什么不 valid
4. **邀请讨论** - 如果不确定，邀请进一步讨论
5. **使用英文** - 所有回复使用英文
6. **避免破折号** - 使用逗号或句号

---

## Out of Scope

### Example 1

**Comment:**
> We should add rate limiting to all API endpoints.

**Reply:**
```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

**为什么好：**
- 明确说明不在 scope 内
- 建议在后续 PR 处理
- 使用 "Perhaps" 保持礼貌

---

### Example 2

**Comment:**
> The error messages should be internationalized (i18n).

**Reply:**
```
This is a good point, but i18n is outside the scope of this billing feature PR. Could we track this separately?
```

**为什么好：**
- 认可 comment 的价值（"good point"）
- 说明为什么不在 scope
- 建议跟踪（track separately）

---

### Example 3

**Comment:**
> Should we add unit tests for all edge cases?

**Reply:**
```
Unit tests are planned for a follow-up PR focused on test coverage. This PR focuses on the core implementation.
```

**为什么好：**
- 说明测试有计划
- 明确当前 PR 的重点

---

## Already Addressed

### Example 4

**Comment:**
> Missing null check for `result.data`.

**Reply:**
```
This was already addressed in commit a7c3f21.
```

**为什么好：**
- 简洁
- 引用具体 commit

---

### Example 5

**Comment:**
> Should use repository pattern instead of direct DB calls.

**Reply:**
```
Good catch! This was refactored in commit 5e8d2b4 to use CheckoutLinkRepository.
```

**为什么好：**
- 认可 comment（"Good catch!"）
- 引用 commit
- 说明已经修复

---

## Intentional Design

### Example 6

**Comment:**
> Why not use async/await instead of promises?

**Reply:**
```
The Promise.all() pattern here allows concurrent execution, which async/await would serialize. Could you clarify if you see a specific issue?
```

**为什么好：**
- 说明设计理由（并发执行）
- 邀请进一步讨论
- 使用问句形式

---

### Example 7

**Comment:**
> This function is 200 lines long. Should we split it?

**Reply:**
```
The function is intentionally kept together because splitting would require passing many dependencies. Perhaps we could revisit this if it becomes harder to maintain?
```

**为什么好：**
- 说明设计理由
- 提出未来重新考虑的条件
- 使用 "Perhaps"

---

### Example 8

**Comment:**
> Using `Buffer` instead of `TextEncoder`?

**Reply:**
```
Buffer is used here for compatibility with the HMAC signing library, which expects Buffer input. TextEncoder would require additional conversion.
```

**为什么好：**
- 说明技术原因
- 解释为什么不能换

---

## Not a Real Issue (Misunderstanding)

### Example 9

**Comment:**
> This endpoint is missing authentication.

**Reply:**
```
This is a public endpoint by design (config: { auth: { public: true } }). It verifies the HMAC token instead of using session auth.
```

**为什么好：**
- 说明设计意图
- 指出配置证据
- 解释替代的认证方式

---

### Example 10

**Comment:**
> The error should return 500 instead of 400.

**Reply:**
```
400 is correct here because the error is due to invalid client input (expired token), not a server error. Could you clarify your concern?
```

**为什么好：**
- 解释为什么是 400
- 邀请进一步讨论

---

## Needs Discussion

### Example 11

**Comment:**
> Should we use Redis for caching here?

**Reply:**
```
Thanks for the suggestion. Could we discuss this further? I think the current in-memory cache is sufficient for our scale, but Redis might be worth considering if we see performance issues.
```

**为什么好：**
- 表示感谢
- 邀请讨论
- 说明当前方案的理由
- 提出未来可能的场景

---

### Example 12

**Comment:**
> This approach seems overcomplicated.

**Reply:**
```
Could you clarify which part seems overcomplicated? I'm happy to simplify if there's a better approach.
```

**为什么好：**
- 请求具体反馈
- 表示愿意改进
- 谦虚的语气

---

## Framework Behavior

### Example 13

**Comment:**
> Should we manually filter undefined values before calling `.set()`?

**Reply:**
```
Kysely's .set() automatically skips undefined values, so manual filtering isn't needed. We only need to explicitly pass null if we want to set NULL.
```

**为什么好：**
- 说明框架行为
- 解释什么时候需要手动处理

---

### Example 14

**Comment:**
> Missing error handling for this promise.

**Reply:**
```
The error is caught by the global error handler middleware (apps/api/src/plugins/error-handler.ts), which is why there's no explicit try/catch here.
```

**为什么好：**
- 说明全局错误处理机制
- 指出具体文件位置

---

## Already Handled Elsewhere

### Example 15

**Comment:**
> We should validate the email format.

**Reply:**
```
Email validation is handled by the Typebox schema at the route level (EmailSchema with format: 'email').
```

**为什么好：**
- 说明已经处理
- 指出具体机制

---

### Example 16

**Comment:**
> Missing authorization check.

**Reply:**
```
Authorization is enforced by the route config (roles: ['org_owner']), which the auth middleware validates before reaching this handler.
```

**为什么好：**
- 说明中间件处理
- 引用配置

---

## Linter / Auto-fix Issues

### Example 17

**Comment:**
> Missing semicolon.

**Reply:**
```
This will be auto-fixed by Prettier on commit. No manual change needed.
```

**为什么好：**
- 说明自动化工具会处理
- 不浪费时间手动修复

---

### Example 18

**Comment:**
> Inconsistent quote style.

**Reply:**
```
ESLint is configured to enforce single quotes and will auto-fix this on save.
```

**为什么好：**
- 指出自动化配置
- 不需要手动干预

---

## Personal Preference (Subjective)

### Example 19

**Comment:**
> I prefer using `const` instead of `let` here.

**Reply:**
```
The variable is reassigned on line 45, so let is required. Could you clarify if you see a way to make it const?
```

**为什么好：**
- 说明为什么用 `let`
- 邀请建议

---

### Example 20

**Comment:**
> This could be written more functionally.

**Reply:**
```
Could you suggest a specific functional approach? I'm open to refactoring if it improves readability.
```

**为什么好：**
- 请求具体建议
- 表示愿意改进
- 关注可读性

---

## Bad Examples (Avoid)

❌ `No, this is wrong.` (生硬拒绝)

❌ `You don't understand the design.` (不尊重)

❌ `This is intentional.` (没有解释)

❌ `Already fixed.` (没有引用 commit)

❌ `Out of scope.` (太简短，没有建议)

❌ `这个不在范围内` (使用中文)

❌ `This is out of scope – we'll handle it later.` (使用了破折号)

❌ `I disagree with this comment.` (对抗性)

---

## Summary

优秀的 invalid 回复特点：

1. **Polite** - 礼貌、尊重
2. **Specific** - 说明具体理由
3. **Tentative** - 使用 "Perhaps", "Could", "Might"
4. **Inviting** - 邀请进一步讨论
5. **English** - 使用英文
6. **No dashes** - 避免破折号
7. **Concise** - 简洁明了
8. **Constructive** - 建设性，不对抗
