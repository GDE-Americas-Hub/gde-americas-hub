# Codelab Source Files

This directory contains the **source markdown files** for all codelabs in the GDE Americas Hub.

## 📁 Directory Purpose

- **Keep all `.md` source files here**
- Generated HTML goes in category folders (e.g., `../android/`, `../firebase/`)
- This separation makes it easy to:
  - Track changes in source files
  - Regenerate codelabs when needed
  - Maintain version history

## ✍️ Creating a New Codelab

### Quick Start

1. **Copy the template** or check existing codelabs for reference
2. **Write your codelab** following the [How to Create a Codelab](how-to-create-a-codelab.md) guide
3. **Export it** using the helper script:
   ```bash
   ./scripts/export-codelab.sh docs/codelabs/source/your-codelab.md android
   ```

### Codelab Template

```markdown
author: Your Name
summary: What users will learn in one sentence
id: unique-codelab-id
categories: android,kotlin,beginner
environments: Web
status: Published
feedback link: https://github.com/gde-americas/gde-americas-hub/issues

# Codelab Title

## Overview
Duration: 0:02:00

What you'll learn...

## Prerequisites
Duration: 0:01:00

What's needed before starting...

## Step 1
Duration: 0:05:00

Content here...

## Conclusion
Duration: 0:02:00

Summary and next steps...
```

## 📋 Metadata Fields

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `author` | Yes | Your name | `Jane Doe` |
| `summary` | Yes | Brief description | `Learn Android Jetpack Compose` |
| `id` | Yes | Unique lowercase ID | `android-compose-basics` |
| `categories` | Yes | Comma-separated tags | `android,compose,beginner` |
| `environments` | Yes | Where it runs | `Web` |
| `status` | Yes | Publication status | `Published`, `Draft`, `Hidden` |
| `feedback link` | No | Issue tracker URL | GitHub issues link |
| `analytics account` | No | Google Analytics ID | `0` (or your tracking ID) |

## 🎨 Formatting Guide

### Sections

Use `##` for main sections (steps):

```markdown
## Step Title
Duration: 0:05:00

Content here...
```

### Callouts

**Positive (Green):**
```markdown
Positive
: This is a helpful tip or success message!
```

**Negative (Yellow):**
```markdown
Negative
: This is a warning or important note.
```

### Code Blocks

Use triple backticks with language:

````markdown
```kotlin
fun hello() {
    println("Hello, World!")
}
```
````

### Images

```markdown
![Image description](https://example.com/image.png)
```

Or use relative paths for local images:

```markdown
![Architecture diagram](../assets/images/architecture.png)
```

### Links

```markdown
[Link text](https://example.com)
```

## 🚀 Exporting Your Codelab

### Option 1: Using the Helper Script (Recommended)

```bash
# From repo root
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md android
```

This script:
- ✅ Exports your codelab using claat
- ✅ Organizes files into correct directories
- ✅ Updates the category index page
- ✅ Shows next steps

**IMPORTANT**: The generated HTML is **only for local preview**. Do NOT commit it to Git!

### Option 2: Manual Export

```bash
# Navigate to source directory
cd docs/codelabs/source

# Export using claat
claat export my-codelab.md

# Move generated folder to category
mv my-codelab-id ../android/
```

**Note**: Manual exports are also NOT committed - they're for preview only.

## 🔍 Testing Your Codelab

### Preview Locally

**Option A - Full Site:**
```bash
mkdocs serve
```

**Option B - Just the Codelab:**
```bash
cd docs/codelabs/android/my-codelab-id
python3 -m http.server 8080
```

Visit: http://127.0.0.1:8080/

### Checklist

Before submitting:

- [ ] All links work
- [ ] Images display correctly
- [ ] Code examples are tested
- [ ] Durations are accurate
- [ ] No typos or grammar errors
- [ ] Metadata is complete
- [ ] Source file is in `source/` directory
- [ ] Generated files are in correct category

## ⚠️ IMPORTANT: What to Commit vs. NOT Commit

### ✅ DO Commit to Git:

```bash
# Commit your source markdown file
git add docs/codelabs/source/your-codelab.md

# Commit the updated category index (if modified)
git add docs/codelabs/android/index.md

# Commit your changes
git commit -m "Add codelab: Your Tutorial Title"
```

### ❌ DO NOT Commit to Git:

**NEVER commit the generated HTML directories!**

```bash
# ❌ DO NOT ADD THESE:
docs/codelabs/android/your-codelab-id/
docs/codelabs/firebase/your-codelab-id/
# etc.
```

**Why?**
- Generated HTML is automatically created during CI/CD deployment
- Committing generated files leads to:
  - ❌ Large repository size
  - ❌ Merge conflicts
  - ❌ Difficult code reviews
  - ❌ Inconsistencies between source and generated files

**The Pipeline Does It:**
- When you push to GitHub, Netlify automatically:
  1. Installs `claat` tool
  2. Exports all codelabs from source markdown
  3. Builds the site
  4. Deploys everything

**Local Preview Only:**
- Export locally to preview your changes: `./scripts/export-codelab.sh ...`
- The generated HTML is git-ignored automatically
- Only commit the `.md` source file

## 📂 File Organization

```
docs/codelabs/
├── source/                           # ← All source .md files go here
│   ├── how-to-create-a-codelab.md   # ✅ Committed to Git
│   ├── android-compose-basics.md     # ✅ Committed to Git
│   ├── firebase-auth-tutorial.md     # ✅ Committed to Git
│   └── your-new-codelab.md           # ✅ Committed to Git
├── android/
│   ├── index.md                      # ✅ Committed to Git
│   ├── how-to-create-a-codelab/     # ❌ NOT committed (generated)
│   └── android-compose-basics/       # ❌ NOT committed (generated)
├── firebase/
│   ├── index.md                      # ✅ Committed to Git
│   └── firebase-auth-tutorial/       # ❌ NOT committed (generated)
└── ...
```

## 🎯 Best Practices

1. **Use clear, descriptive IDs** - `android-jetpack-compose-basics` not `tutorial1`
2. **Set realistic durations** - Test your codelab to estimate time
3. **Keep sections focused** - 5-10 minutes per section is ideal
4. **Include working code** - Test all code examples
5. **Add prerequisites** - Be clear about what users need to know
6. **Provide context** - Explain the "why" not just the "how"
7. **End with next steps** - Guide users to further learning

## 📚 Resources

- [How to Create a Codelab](how-to-create-a-codelab.md) - Full tutorial
- [Google Codelabs Tools](https://github.com/googlecodelabs/tools) - Official repo
- [Claat Documentation](https://github.com/googlecodelabs/tools/tree/master/claat)
- [Markdown Formatting Guide](https://github.com/googlecodelabs/tools/tree/master/claat/parser/md)
- [Sample Codelab](https://github.com/googlecodelabs/tools/blob/main/sample/codelab.md)

## ❓ Questions?

- Check the [Contributing Guidelines](../../CONTRIBUTING.md)
- Read the full [How to Create a Codelab](how-to-create-a-codelab.md) tutorial
- Open an issue on GitHub
- Ask in community forums

---

**Happy codelab authoring!** 🎉
