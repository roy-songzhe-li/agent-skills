# Common UI Copy Patterns

Quick reference for common UI components.

---

## Buttons

### Primary Actions
✅ **Good:** "Save", "Send", "Continue", "Get started"  
❌ **Avoid:** "Click here to save", "Send message now", "Click to continue"

### Secondary Actions
✅ **Good:** "Cancel", "Go back", "Skip"  
❌ **Avoid:** "No thanks", "Maybe later", "Not now"

### Destructive Actions
✅ **Good:** "Delete", "Remove", "Discard changes"  
❌ **Avoid:** "Delete forever", "Are you sure?", "Remove permanently"

---

## Error Messages

**Format:** [Problem]. [Solution].

### Examples

✅ "Email already in use. Try signing in instead."  
❌ "Oops! It looks like this email is already registered. Please try logging in."

✅ "Connection lost. Check your internet and try again."  
❌ "We're sorry, but we couldn't connect to the server."

✅ "Password must be at least 8 characters."  
❌ "Your password is too short. Please enter a password with 8 or more characters."

---

## Success Messages

**Format:** [What happened]. [Optional: Next step].

### Examples

✅ "Project created. Add your first task."  
❌ "Great! Your project has been successfully created!"

✅ "Changes saved."  
❌ "Your changes have been saved successfully!"

✅ "Email sent. Check your inbox."  
❌ "Success! We've sent the email to your inbox."

---

## Empty States

**Format:** [Context]. [Action to populate].

### Examples

✅ "No projects yet. Create your first one."  
❌ "You don't have any projects. Click below to get started."

✅ "No messages. Start a conversation."  
❌ "Your inbox is empty! You haven't received any messages yet."

✅ "No results found. Try a different search."  
❌ "We couldn't find anything matching your search query."

---

## Loading States

**Be specific about what's loading:**

✅ "Loading projects..."  
❌ "Loading..."

✅ "Saving changes..."  
❌ "Please wait..."

✅ "Uploading file..."  
❌ "Processing..."

---

## Tooltips

**Don't repeat the button label. Add new information:**

❌ Button: "Save" | Tooltip: "Click to save"  
✅ Button: "Save" | Tooltip: "Cmd+S"

❌ Button: "Export" | Tooltip: "Export your data"  
✅ Button: "Export" | Tooltip: "Download as CSV or JSON"

❌ Button: "Delete" | Tooltip: "Delete this item"  
✅ Button: "Delete" | Tooltip: "This cannot be undone"

---

## Notifications

**Lead with the news/benefit:**

✅ "New comment on your post"  
❌ "You have a new notification"

✅ "Build complete. View results."  
❌ "Your build has finished. Click here to see the results."

✅ "Payment received. Invoice sent."  
❌ "We've received your payment and sent you an invoice."

---

## Confirmation Dialogs

**Format:** [Question]. [Consequences if applicable]. [Actions].

### Delete Confirmation

✅ **Title:** "Delete 'Project Name'?"  
   **Body:** "This cannot be undone."  
   **Actions:** "Cancel" | "Delete"

❌ **Title:** "Are you sure?"  
   **Body:** "Are you sure you want to delete this project? This action is permanent."  
   **Actions:** "No, go back" | "Yes, delete it"

### Discard Changes

✅ **Title:** "Discard changes?"  
   **Body:** "Your changes won't be saved."  
   **Actions:** "Cancel" | "Discard"

❌ **Title:** "Warning: Unsaved Changes"  
   **Body:** "You have unsaved changes. If you leave now, they will be lost."  
   **Actions:** "Stay on page" | "Leave without saving"

---

## Form Fields

### Labels
✅ "Email", "Password", "Full name"  
❌ "Enter your email address", "Type your password here"

### Placeholders
✅ "name@example.com", "••••••••", "John Doe"  
❌ "Please enter your email", "Your password goes here"

### Helper Text
✅ "We'll never share your email"  
❌ "Don't worry, we take your privacy seriously and won't share this"

### Error Messages
✅ "Enter a valid email address"  
❌ "Oops! The email you entered is not valid. Please check and try again."

---

## Onboarding

### Welcome Screen

✅ **Title:** "Welcome to [App Name]"  
   **Subtitle:** "[One sentence value proposition]"  
   **CTA:** "Get started"

❌ **Title:** "Welcome! We're excited to have you!"  
   **Subtitle:** "Our amazing app helps you do amazing things easily!"  
   **CTA:** "Click here to start your journey with us"

### Feature Introduction

✅ **Title:** "[Feature name]"  
   **Description:** "[What it does in one sentence]"  
   **CTA:** "Next"

❌ **Title:** "Introducing our awesome [Feature]!"  
   **Description:** "This powerful feature allows you to easily [action]..."  
   **CTA:** "Continue to next step"

### Permission Request

✅ **Title:** "Enable notifications"  
   **Description:** "Get updates when someone mentions you"  
   **CTA:** "Enable" | "Not now"

❌ **Title:** "We'd like to send you notifications"  
   **Description:** "Please allow us to send you push notifications so you can stay updated..."  
   **CTA:** "Allow notifications" | "No thanks, maybe later"

---

## Search

### Search Bar Placeholder

✅ "Search projects"  
❌ "What are you looking for?"

✅ "Search by name or email"  
❌ "Type here to search..."

### No Results

✅ "No results for '[query]'. Try a different search."  
❌ "We couldn't find anything matching your search. Please try again with different keywords."

### Search Suggestions

✅ "Recent searches" / "Suggested"  
❌ "Here are some suggestions that might help you"

---

## Settings

### Section Headers

✅ "Account", "Notifications", "Privacy"  
❌ "Account Settings", "Notification Preferences", "Privacy & Security Options"

### Toggle Labels

✅ "Email notifications"  
❌ "Receive email notifications about activity"

✅ "Dark mode"  
❌ "Enable dark mode theme"

### Descriptions

✅ "Receive emails about project activity"  
❌ "If enabled, you will receive email notifications whenever there is activity on your projects"

---

## Navigation

### Back Buttons

✅ "Back", "← Projects"  
❌ "Go back to previous page", "← Back to projects list"

### Breadcrumbs

✅ "Home > Projects > Project Name"  
❌ "You are here: Home / Projects / Project Name"

### Menu Items

✅ "Dashboard", "Projects", "Settings"  
❌ "Go to dashboard", "View all projects", "Open settings"

---

## Quick Rules

1. **Buttons:** Action verbs only
2. **Errors:** Problem + Solution
3. **Success:** What happened + Optional next step
4. **Empty states:** Context + Action
5. **Tooltips:** New information, not repetition
6. **Notifications:** Lead with news
7. **Confirmations:** Question + Consequence + Clear actions
8. **Forms:** Short labels, helpful placeholders
9. **Onboarding:** Value proposition, not excitement
10. **Search:** Specific, actionable

---

**Remember:** Every word should add value. If it doesn't, delete it.
