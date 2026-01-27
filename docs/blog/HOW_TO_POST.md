# How to Write a Blog Post 📝

Choose your path based on where you're starting from:

## 🚀 Quick Start

### Option 1: Import from dev.to (Easiest!) ⭐

Already have a post on dev.to? Import it with one command:

```bash
./scripts/import-from-devto.sh https://dev.to/yourname/your-post-title-123
```

**That's it!** The script will:
- ✅ Fetch your post from dev.to
- ✅ Convert it to the correct format
- ✅ Fix date format automatically
- ✅ Add "General" category if none found
- ✅ Create the file in the right location

Then skip to [Step 4: Validate](#4-validate-before-submitting-recommended).

### Option 2: Write from Scratch

Continue reading below for the full guide.

---

## ⚠️ CRITICAL: Date Format Warning

**The #1 reason blog builds fail is incorrect date format.**

```yaml
# ✅ CORRECT - Unquoted date (date object)
date: 2026-01-27

# ❌ WRONG - Quoted date (string) - BUILD WILL FAIL!
date: "2026-01-27"
date: '2026-01-27'

# ❌ WRONG - Other formats
date: "January 27, 2026"
date: 27-01-2026
```

**Why it matters:** MkDocs Material blog plugin requires a date **object**, not a string. Quotes make it a string.

**How to avoid:** Use our validation script (see below) or import from dev.to.

---

## 📝 Writing from Scratch

### 1. File Naming Convention

Blog posts must follow this pattern:

```
YYYY-MM-DD-post-slug.md
```

**Examples:**
- `2026-01-23-getting-started-android.md`
- `2026-02-15-firebase-tips-tricks.md`
- `2026-03-10-cloud-run-tutorial.md`

**Location:** `docs/blog/posts/`

### 2. Post Template

Create your file with this template:

```yaml
---
draft: false
date: 2026-01-27
authors:
  - your_author_id
categories:
  - Android
---

# Your Awesome Post Title

A brief introduction (1-2 sentences that hook the reader).

<!-- more -->

## Introduction

Your content starts here...

## Main Content

Add your sections...

## Conclusion

Wrap it up!

---

*About the author: Brief bio or link*
```

### 3. Front Matter Fields Explained

```yaml
draft: false              # true = hidden, false = published
date: 2026-01-27         # ⚠️ UNQUOTED! Format: YYYY-MM-DD
authors:                 # From .authors.yml (see below)
  - your_id
categories:              # Pick from list below
  - Android              # At least one required
  - Firebase             # Can have multiple
```

**Categories Available:**
- Android
- Firebase
- Google Cloud
- Flutter
- AI & ML
- Web
- Maps
- Ads
- Workspace
- General *(default if none specified)*

### 4. The `<!-- more -->` Separator (Important!)

**All blog posts must include the `<!-- more -->` separator.**

This separator:
- Creates an excerpt for the blog list page
- Adds a "Continue reading" button
- Improves user experience

```markdown
# Your Post Title

Your introduction paragraph (1-3 sentences).

<!-- more -->

## Full Content Starts Here

The rest of your post...
```

**What happens without it:**
- ❌ The entire post shows on the blog list page
- ❌ No "Continue reading" button appears
- ❌ Poor user experience

**Note:** The pre-commit hook will warn you if it's missing!

### 5. Adding Yourself as an Author

Edit `docs/blog/.authors.yml`:

```yaml
your_github_username:
  name: Your Full Name
  description: GDE for Android
  avatar: https://github.com/your_username.png
  url: https://your-website.com
```

---

## ✅ 4. Validate Before Submitting (Recommended)

**Always run the validator before committing:**

```bash
# Validate all posts
./scripts/validate-blog-posts.sh

# Validate specific post
./scripts/validate-blog-posts.sh docs/blog/posts/2026-01-27-my-post.md

# Auto-fix common issues (date format, missing categories)
./scripts/validate-blog-posts.sh --fix
```

**What it checks:**
- ✅ Date format (quoted vs. unquoted)
- ✅ Categories format (string vs. list)
- ✅ Required fields (date, authors, categories)
- ✅ Author exists in `.authors.yml`
- ✅ Categories are valid
- 🔧 Auto-fix: Removes quotes from dates
- 🔧 Auto-fix: Converts categories string → list
- 🔧 Auto-fix: Adds "General" if no categories

**Example output:**
```
Validating: 2026-01-27-my-post.md
  ✓ Date format: ✓ (unquoted date object)
  ✓ Authors field: ✓
  ✓ Categories field: ✓ (2 categories)
  Status: PASS
```

---

## 🔒 5. Enforce Quality with Git Hooks (Recommended)

**Automatic validation on every commit!**

Install the pre-commit hook to automatically validate blog posts before committing:

```bash
# One-time setup
./scripts/install-git-hooks.sh
```

**What it does:**
- ✅ Runs automatically before every commit
- ✅ Validates all blog posts in the commit
- ✅ Blocks commits with errors (date format, categories, etc.)
- ✅ Shows clear error messages
- ✅ Suggests fixes

**Example:**

```bash
git add docs/blog/posts/2026-01-27-my-post.md
git commit -m "Add blog post"

# Hook runs automatically:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  GDE Americas Hub - Pre-commit Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✗ Date is quoted (string) - this will BREAK the build!
  Current: date: "2026-01-27"
  Should be: date: 2026-01-27

✗ COMMIT BLOCKED

Fix with: ./scripts/validate-blog-posts.sh --fix
```

**Bypass the hook (use sparingly!):**

```bash
git commit --no-verify
```

---

## 6. Preview Locally

```bash
# Install dependencies (first time only)
pip install -r requirements.txt

# Start local server
mkdocs serve

# Visit: http://127.0.0.1:8000/gde-americas-hub/blog/
```

Your post will appear in the blog list!

---

## 7. Submit Your Post

```bash
# Create a branch
git checkout -b blog/my-awesome-post

# Add your files
git add docs/blog/posts/2026-01-27-my-post.md
git add docs/blog/.authors.yml  # If you added yourself

# Commit
git commit -m "Add blog post: My Awesome Post"

# Push
git push origin blog/my-awesome-post

# Open PR on GitHub
```

---

## 📊 Complete Workflow (Visual)

```
┌─────────────────────────────────────────────────────┐
│  ONE-TIME SETUP:                                    │
│  ./scripts/install-git-hooks.sh                    │
│  (Automatic validation on every commit)            │
│                                                     │
│  ──────────────────────────────────────────────    │
│                                                     │
│  Have post on dev.to?                               │
│  ├─ YES → ./scripts/import-from-devto.sh URL       │
│  └─ NO  → Write from scratch (template above)      │
│                                                     │
│  ↓                                                  │
│  Add <!-- more --> separator after intro           │
│                                                     │
│  ↓                                                  │
│  Run validator (optional, hook does this):          │
│  ./scripts/validate-blog-posts.sh --fix           │
│                                                     │
│  ↓                                                  │
│  Preview locally:                                   │
│  mkdocs serve                                       │
│                                                     │
│  ↓                                                  │
│  git commit (hook validates automatically!)         │
│                                                     │
│  ↓                                                  │
│  git push                                           │
│                                                     │
│  ↓                                                  │
│  Open PR → Get reviewed → Merge → Published! 🎉    │
└─────────────────────────────────────────────────────┘
```

---

## 💡 Best Practices

1. **Clear titles** - Descriptive and specific
2. **Code examples** - Working, tested code snippets
3. **Images** - Place in `/docs/assets/images/blog/`
4. **Links** - Reference official docs
5. **Proofread** - Check spelling and grammar
6. **Use `<!-- more -->`** - Separates excerpt from full content
7. **Validate first** - Always run the validator before submitting

---

## 🆘 Common Issues & Solutions

### Issue 1: Build fails with "expected date object"

**Cause:** Date is quoted (string)

**Solution:**
```bash
./scripts/validate-blog-posts.sh --fix
```

This removes quotes automatically.

### Issue 2: Build fails with "Expected a list of items, but a string was given"

**Cause:** Categories is a STRING instead of a LIST

**Example of problem:**
```yaml
categories: "Events"  # ❌ String
```

**Solution:**
```bash
./scripts/validate-blog-posts.sh --fix
```

This converts to proper list format:
```yaml
categories:
  - Events  # ✅ List
```

### Issue 3: "Author not found"

**Cause:** Author ID not in `.authors.yml`

**Solution:** Add yourself to `.authors.yml` first

### Issue 3: No categories

**Cause:** Forgot to add categories

**Solution:**
```bash
./scripts/validate-blog-posts.sh --fix
```

This adds "General" category automatically.

### Issue 4: Post not appearing

**Cause:** `draft: true` in frontmatter

**Solution:** Change to `draft: false`

### Issue 5: No "Continue reading" button

**Cause:** Missing `<!-- more -->` separator

**Solution:** Add the separator after your introduction:

```markdown
Your introduction paragraph here.

<!-- more -->

Rest of your content...
```

The pre-commit hook will warn you about this!

---

## 📁 File Structure

```
docs/blog/
├── .authors.yml              # Author definitions
├── index.md                  # Blog homepage
├── HOW_TO_POST.md           # This guide
└── posts/
    ├── 2026-01-23-welcome.md
    └── your-posts-here.md
```

---

## 🛠️ Helper Scripts

| Script | Purpose |
|--------|---------|
| `import-from-devto.sh` | Import post from dev.to |
| `validate-blog-posts.sh` | Validate frontmatter |
| `validate-blog-posts.sh --fix` | Auto-fix common issues |
| `install-git-hooks.sh` | Install pre-commit validation hook |

---

## 📚 Resources

- **Example post:** See `posts/2026-01-23-welcome.md`
- **Contributing guide:** [CONTRIBUTING.md](../CONTRIBUTING.md)
- **MkDocs Material blog:** [Official docs](https://squidfunk.github.io/mkdocs-material/plugins/blog/)

---

## ❓ Questions?

- Check [CONTRIBUTING.md](../CONTRIBUTING.md)
- Open an issue on GitHub
- Ask in community forums

---

**Happy blogging!** 🎉

*Remember: Validate before submitting! It saves everyone time.*
