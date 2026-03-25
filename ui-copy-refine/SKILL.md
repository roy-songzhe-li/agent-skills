---
name: ui-copy-refine
description: Review and refine existing UI copy using Apple WWDC principles. Analyze user-facing text to identify fillers, repetition, unclear messaging, and terminology inconsistencies, then suggest improvements. Use when reviewing buttons, labels, error messages, tooltips, notifications, or any existing UI text. Checks consistency across provided text even without a formal word list. Inspired by Apple UX Writing guidelines.
license: MIT
metadata:
  author: roy-songzhe-li
  version: "1.2.0"
  created: "2026-03-25"
  updated: "2026-03-25"
  based-on: WWDC25 - Enhance your app with great writing
---

# UI Copy Refine

Review and optimize existing UI text for clarity, conciseness, and impact using Apple WWDC UX writing principles.

## ⚠️ Core Philosophy

> "Does each word add value?" — Apple UX Writing Team

UX writing is about **economy of language**. Apps have no minimum word count—usually, you should *remove* words, not add them.

## Primary Use Case

**This skill is for REVIEWING and IMPROVING existing UI copy, not writing from scratch.**

When the user provides UI text (buttons, labels, messages, etc.), analyze it using the 3 principles below and suggest improvements.

---

## The 4 Review Principles

### 1. Remove Fillers 🗑️

Delete unnecessary adverbs, adjectives, interjections, and pleasantries.

**Common fillers:**
- Adverbs: *easily*, *quickly*, *simply*
- Adjectives: *fast*, *simple*, *great*
- Interjections: *Uh oh*, *Oops*, *Hooray*
- Pleasantries: *Sorry*, *Thank you*, *Please*

**Examples:**

❌ "Simply enter your email to quickly get started"
✅ "Enter your email to get started"

❌ "Oops! Something went wrong. We're sorry!"
✅ "Something went wrong. Try again."

**When to keep descriptive words:**

✅ "**Automatically** feed your pets when you're away"
→ "Automatically" clarifies a key feature

---

### 2. Avoid Repetition 🔁

Don't say the same thing in different ways. Resist the urge to fill blank space.

**Examples:**

❌ **Title:** "We're running late"  
   **Body:** "Your delivery driver won't make it on time. They'll be there in 10 minutes."

✅ **Title:** "Delivery delayed 10 minutes"  
   **Body:** "Check the app for your driver's location"

❌ **Button:** "Save Changes"  
   **Tooltip:** "Click to save your changes"

✅ **Button:** "Save"  
   **Tooltip:** "Changes are saved automatically"

---

### 3. Lead with Benefits 🎯

Put the "why" (benefit) before the "how" (action).

**Formula:** To [benefit], do [action]

**Examples:**

❌ "Enter your phone number to get reservation updates"
✅ "To get reservation updates, enter your phone number"

❌ "Solve today's crossword to keep your streak going"
✅ "Keep your streak going—solve today's crossword"

❌ "Enable notifications to never miss a message"
✅ "Never miss a message—enable notifications"

**Where to apply:**
- Error messages
- Push notifications
- Action prompts
- Onboarding steps
- Feature descriptions

---

### 4. Check Terminology Consistency 📋

Ensure terms are used consistently across the UI.

**What to check:**
- Same action uses same verb (e.g., always "Delete", not mix "Delete"/"Remove"/"Erase")
- Same concept uses same noun (e.g., always "Project", not mix "Project"/"Workspace")
- Authentication terms consistent (e.g., "Sign in" everywhere, not "Log in" somewhere)

**How to check:**

If you know similar UI text from the same app, compare:
- Does this button say "Delete" but another says "Remove"?
- Does this page say "Username" but another says "User ID"?
- Does this flow say "Sign in" but another says "Log in"?

**Examples:**

❌ **Inconsistent:**
- Button A: "Remove project"
- Button B: "Delete task"
- Modal: "Are you sure you want to erase this file?"

✅ **Consistent:**
- Button A: "Delete project"
- Button B: "Delete task"
- Modal: "Delete this file?"

❌ **Inconsistent:**
- Header: "Log in"
- Auth page: "Sign in to continue"
- Settings: "You're signed in as..."

✅ **Consistent:**
- Header: "Sign in"
- Auth page: "Sign in to continue"
- Settings: "You're signed in as..."

**If project has no established word list:**

Look for patterns in the provided text:
- If multiple pieces use "Sign in", flag any that say "Log in"
- If multiple pieces use "Delete", flag any that say "Remove"
- Recommend the most common term as the standard

---

## Review Workflow

When the user provides UI text to review, follow this process:

### Step 1: Identify Issues

Read the provided text and flag problems:

**Check for:**
- 🚩 **Fillers**: Unnecessary adverbs, adjectives, interjections
- 🚩 **Repetition**: Same information said differently
- 🚩 **Unclear benefits**: Action without explaining "why"
- 🚩 **Terminology inconsistencies**: Different terms for the same thing

**Mark problematic text:**
```markdown
🚩 "Simply click the button below to quickly get started with our amazing app!"
   ↳ Fillers: "Simply", "quickly", "amazing"
   ↳ Repetition: "click" + "button"
```

### Step 2: Apply the 4 Principles

For each flagged issue, apply improvements:

**1. Remove Fillers:**
```markdown
Original: "Simply click the button below to quickly get started"
After: "Click the button below to get started"
Removed: "Simply", "quickly"
```

**2. Avoid Repetition:**
```markdown
After Step 1: "Click the button below to get started"
After Step 2: "Get started"
Removed: "Click the button below" (redundant for a button)
```

**3. Lead with Benefits:**
```markdown
After Step 2: "Get started"
Improved: "Start your first project"
Added: Specific benefit instead of generic "get started"
```

**4. Check Terminology Consistency:**
```markdown
After Step 3: "Start your first project"

Check: Does the app use "project" consistently?
- If other places say "workspace" → Flag inconsistency
- If everywhere says "project" → ✅ Consistent
```

### Step 3: Present Comparison

Show before/after in a clear table:

```markdown
| Component | Original | Issues | Refined | Improvement |
|-----------|----------|--------|---------|-------------|
| CTA Button | "Simply click here to get started" | Fillers, repetition | "Get started" | 71% shorter, clearer |
| Error | "Oops! Something went wrong. Please try again." | Fillers | "Something went wrong. Try again." | 33% shorter |
| Notification | "Enable notifications to stay updated" | Benefit not prioritized | "Stay updated—enable notifications" | Benefit-first |
```

### Step 4: Summarize Terminology Consistency

After reviewing all provided text, note any inconsistencies:

```markdown
⚠️ **Terminology Inconsistencies:**

- "Log in" (button A) vs "Sign in" (button B)
  → Recommend: Use "Sign in" everywhere (more common in provided text)

- "Remove" (menu) vs "Delete" (modal)
  → Recommend: Use "Delete" everywhere (clearer and standard)

- "Workspace" (nav) vs "Project" (content)
  → Clarify: Are these the same concept? If yes, use one term consistently.
```

**If only reviewing one piece of text:**

Note what terms are used and flag potential conflicts:

```markdown
✅ **Terms Used:**
- Action: "Delete"
- Object: "Project"
- Auth: "Sign in"

💡 **Recommendation:** Check if these match other parts of the app. 
If elsewhere uses "Remove", "Workspace", or "Log in", standardize to one term.
```

---

## Common UI Copy Patterns

### Buttons

**Primary actions:**
- ✅ "Save", "Send", "Continue", "Get started"
- ❌ "Click here to save", "Send message now"

**Secondary actions:**
- ✅ "Cancel", "Go back", "Skip"
- ❌ "No thanks", "Maybe later"

**Destructive actions:**
- ✅ "Delete", "Remove", "Discard changes"
- ❌ "Delete forever", "Are you sure?"

### Error Messages

**Format:** [Problem]. [Solution].

✅ "Email already in use. Try signing in instead."
❌ "Oops! It looks like this email is already registered in our system. Please try logging in."

✅ "Connection lost. Check your internet and try again."
❌ "We're sorry, but we couldn't connect to the server. Please check your network connection and retry."

### Success Messages

**Format:** [What happened]. [Optional: Next step].

✅ "Project created. Add your first task."
❌ "Great! Your project has been successfully created! Now you can start adding tasks."

✅ "Changes saved."
❌ "Your changes have been saved successfully!"

### Empty States

**Format:** [Context]. [Action to populate].

✅ "No projects yet. Create your first one."
❌ "You don't have any projects right now. To get started, you can create a new project by clicking the button below."

✅ "No messages. Start a conversation."
❌ "Your inbox is empty! You haven't received any messages yet."

### Loading States

**Be specific about what's loading:**

✅ "Loading projects..."
❌ "Loading..."

✅ "Saving changes..."
❌ "Please wait..."

### Tooltips

**Don't repeat the button label:**

❌ Button: "Save" | Tooltip: "Click to save"
✅ Button: "Save" | Tooltip: "Cmd+S"

❌ Button: "Export" | Tooltip: "Export your data"
✅ Button: "Export" | Tooltip: "Download as CSV or JSON"

### Notifications

**Lead with the benefit/news:**

✅ "New comment on your post"
❌ "You have a new notification"

✅ "Build complete. View results."
❌ "Your build has finished. Click here to see the results."

---

## Real-World Example: Authentication Flow

### Before Optimization

**Sign Up Page:**
- Headline: "Welcome! Let's get you started!"
- Subheading: "Simply fill out the form below to create your account and get started quickly"
- Email field: "Please enter your email address"
- Password field: "Please enter a strong password"
- Button: "Click here to create your account"

**Sign In Page:**
- Headline: "Welcome back! We're glad to see you again!"
- Email field: "Please enter your registered email"
- Password field: "Please enter your password"
- Button: "Click here to log in"
- Forgot link: "Oops! Forgot your password? Click here to reset it."

### After Optimization

**Sign Up Page:**
- Headline: "Create your account"
- Subheading: *removed* (headline is clear enough)
- Email field: "Email"
- Password field: "Password (8+ characters)"
- Button: "Sign up"

**Sign In Page:**
- Headline: "Sign in"
- Email field: "Email"
- Password field: "Password"
- Button: "Sign in"
- Forgot link: "Forgot password?"

**Improvements:**
- ✅ Removed fillers ("Simply", "Please", "Click here")
- ✅ Avoided repetition (removed redundant subheading)
- ✅ Consistent terminology ("Sign up" / "Sign in" everywhere)
- ✅ Concise and clear

---

## Advanced Techniques

### 1. Context-Aware Copy

**Bad:**
```
Button: "Delete"
Modal: "Are you sure?"
```

**Good:**
```
Button: "Delete project"
Modal: "Delete 'My Project'?"
Explanation: "This cannot be undone."
Actions: "Cancel" | "Delete"
```

### 2. Progressive Disclosure

Don't overwhelm users with all information upfront.

**Bad:**
```
"Enable two-factor authentication to add an extra layer of security 
to your account. We'll send a code to your phone every time you sign 
in from a new device, which you'll need to enter along with your password."
```

**Good:**
```
Title: "Enable two-factor authentication"
Subtitle: "Extra security for your account"
Link: "How it works"
```

### 3. Tone Consistency

**Formal/Professional:**
- ✅ "Sign in", "Account settings", "Contact support"
- ❌ "Log in", "Your stuff", "Get help"

**Casual/Friendly:**
- ✅ "Log in", "Your workspace", "Need help?"
- ❌ "Authenticate", "User preferences", "Support inquiry"

**Pick one tone and stick to it.**

### 4. Localization Awareness

Write copy that translates well:
- Avoid idioms ("piece of cake", "hit the ground running")
- Avoid humor that may not translate
- Keep sentences short (easier to translate)
- Use simple vocabulary

---

## Review Checklist

Use this when analyzing UI text:

### Content
- [ ] Every word adds value (no fillers)
- [ ] No repetition of the same information
- [ ] Benefits stated before actions (where appropriate)
- [ ] Terminology is consistent (matches word list)

### Clarity
- [ ] Read aloud—sounds natural?
- [ ] First-time user would understand?
- [ ] No jargon or technical terms (unless unavoidable)
- [ ] Actionable (user knows what to do next)

### Tone
- [ ] Consistent with brand voice
- [ ] Appropriate for context (error vs success)
- [ ] Not overly apologetic or enthusiastic
- [ ] Respects user's time

### Technical
- [ ] Fits in UI (doesn't overflow)
- [ ] Works in different screen sizes
- [ ] Translatable (if app is localized)
- [ ] Accessible (screen reader friendly)

---

## Resources

- **Original Tutorial:** [references/WWDC-TUTORIAL.md](references/WWDC-TUTORIAL.md)
- **Common Patterns:** [references/UI-COPY-PATTERNS.md](references/UI-COPY-PATTERNS.md)
- **Apple Style Guide:** https://support.apple.com/guide/applestyleguide/
- **Apple HIG:** https://developer.apple.com/design/human-interface-guidelines/

---

## Quick Tips

1. **Read it out loud** - Easiest way to catch fillers and awkward phrasing
2. **One idea per sentence** - Don't combine multiple concepts
3. **Active voice** - "Delete this file" vs "This file will be deleted"
4. **Specific numbers** - "in 2 minutes" vs "soon"
5. **Front-load important info** - Put key words at the beginning
6. **Test with real users** - What's clear to you may not be clear to them

---

## Example: Multi-Component Review

### User Provides Multiple UI Texts

**Button 1 (Homepage):**
```
"Simply click here to quickly and easily create your very first amazing project!"
```

**Button 2 (Dashboard):**
```
"Click here to remove your workspace"
```

**Button 3 (Settings):**
```
"Log in to continue"
```

**Error Message:**
```
"Oops! We're really sorry, but something went wrong. Please try again later."
```

---

### Review Output

#### Step 1: Issues Identified

**Button 1:**
- 🚩 Fillers: "Simply", "quickly", "easily", "very", "amazing"
- 🚩 Repetition: "click here" (button is clickable)

**Button 2:**
- 🚩 Terminology: Uses "remove" and "workspace"

**Button 3:**
- 🚩 Terminology: Uses "Log in"

**Error Message:**
- 🚩 Fillers: "Oops!", "really", "Please"
- 🚩 Over-apologetic: "We're sorry"
- 🚩 Vague: "something went wrong"

---

#### Step 2: Apply 4 Principles

**Button 1:**
1. Remove Fillers: "Click here to create your first project"
2. Avoid Repetition: "Create your first project"
3. Lead with Benefits: "Start your first project"
4. Check Terminology: Uses "project" ✅

**Button 2:**
1-3. Already concise
4. Check Terminology: "remove" vs "delete"? "workspace" vs "project"? 🚩

**Button 3:**
1-3. Already concise
4. Check Terminology: "Log in" vs "Sign in"? 🚩

**Error Message:**
1. Remove Fillers: "Something went wrong. Try again later."
2. Avoid Repetition: ✅
3. Lead with Benefits: "Try again later" (solution first)
4. Check Terminology: ✅

---

#### Step 3: Before/After Comparison

| Component | Original | Refined | Issues Fixed |
|-----------|----------|---------|--------------|
| Button 1 | "Simply click here to quickly and easily create your very first amazing project!" | "Start your first project" | Fillers, repetition |
| Button 2 | "Click here to remove your workspace" | "Delete project" | Terminology |
| Button 3 | "Log in to continue" | "Sign in to continue" | Terminology |
| Error | "Oops! We're really sorry, but something went wrong. Please try again later." | "Something went wrong. Try again." | Fillers, clarity |

---

#### Step 4: Terminology Consistency

⚠️ **Inconsistencies Detected:**

1. **Delete vs Remove**
   - Button 2 uses "remove"
   - Recommend: Use "Delete" (more standard and clear)

2. **Project vs Workspace**
   - Button 1 uses "project"
   - Button 2 uses "workspace"
   - Question: Are these the same? If yes, standardize.
   - Recommend: Use "Project" (matches Button 1)

3. **Log in vs Sign in**
   - Button 3 uses "Log in"
   - Should match: "Sign in" (more modern and common)

✅ **Terms Used Consistently:**
- Error handling: Clear and actionable

💡 **Recommendations:**
- Standardize all delete actions to "Delete"
- Use "Project" everywhere (not "Workspace")
- Use "Sign in" everywhere (not "Log in")

---

**Summary:**
- **Words reduced:** 48 → 19 (60% reduction)
- **Clarity improved:** Removed fillers, fixed repetition
- **Consistency improved:** Identified 3 terminology conflicts
- **Action-oriented:** All buttons now lead with clear actions

---

**Remember:** Great UI copy is invisible. Users shouldn't notice the words—they should just understand what to do.
