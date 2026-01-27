# Contributing to GDE Americas Hub

Thank you for your interest in contributing! This document provides guidelines for contributing content to the hub.

## Table of Contents

- [Getting Started](#getting-started)
- [Content Types](#content-types)
- [Submission Process](#submission-process)
- [Content Guidelines](#content-guidelines)
- [Technical Setup](#technical-setup)

## Getting Started

1. **Fork** this repository
2. **Clone** your fork locally
3. **Create a branch** for your contribution
4. **Add your content** following the guidelines below
5. **Submit a Pull Request**

## Content Types

### 📚 Codelabs

Codelabs are interactive, step-by-step tutorials using Google's official `claat` tool.

**📖 Full Guide**: See [How to Create a Codelab](docs/codelabs/source/how-to-create-a-codelab.md) for complete instructions

**Quick Start**:

1. **Install claat**:
   ```bash
   # Download from releases
   # https://github.com/googlecodelabs/tools/releases

   # Or build from source (requires Go)
   go install github.com/googlecodelabs/tools/claat@latest
   ```

2. **Create source file**: `docs/codelabs/source/your-codelab.md`

3. **Add metadata header**:
   ```markdown
   author: Your Name
   summary: Brief description
   id: unique-codelab-id
   categories: android,kotlin,beginner
   environments: Web
   status: Published
   feedback link: https://github.com/gde-americas/gde-americas-hub/issues

   # Codelab Title

   ## Overview
   Duration: 0:02:00

   Content here...
   ```

4. **Export locally to preview** (optional):
   ```bash
   ./scripts/export-codelab.sh docs/codelabs/source/your-codelab.md android
   ```
   This script automatically:
   - Exports your markdown to HTML
   - Updates the category index page
   - Shows you how to preview locally

5. **Commit ONLY the source**:
   ```bash
   git add docs/codelabs/source/your-codelab.md
   git add docs/codelabs/android/index.md  # If updated
   git commit -m "Add codelab: Your Codelab Title"
   ```

**⚠️ CRITICAL - What to Commit:**

```bash
# ✅ DO commit these:
git add docs/codelabs/source/your-codelab.md  # Source file
git add docs/codelabs/android/index.md        # Category index (if updated)

# ❌ NEVER commit these:
# docs/codelabs/android/your-codelab-id/      # Generated HTML (git-ignored)
```

**Why?**
- Generated HTML is **automatically created** by Netlify during deployment
- Committing generated files causes:
  - ❌ Repository bloat (100-500KB per codelab)
  - ❌ Merge conflicts
  - ❌ Difficult PR reviews
  - ❌ Inconsistencies

**The `.gitignore` protects you** - generated directories are automatically ignored!

**Locations**:
- Source files: `docs/codelabs/source/` (markdown) ← **Commit these**
- Generated files: `docs/codelabs/{category}/{id}/` (HTML) ← **Git-ignored**

**Format Details**:
- Use `##` for sections (steps)
- Add `Duration: 0:XX:00` after section titles
- Use `Positive:` for tips (green boxes)
- Use `Negative:` for warnings (yellow boxes)
- Include working code examples

**Resources**:
- [Codelab Source Directory README](docs/codelabs/source/README.md)
- [Helper Scripts](scripts/README.md)
- [Google Codelabs Tools](https://github.com/googlecodelabs/tools)
- [Sample Codelab](https://github.com/googlecodelabs/tools/blob/main/sample/codelab.md)

### ✍️ Blog Posts

Technical articles, insights, and best practices.

**Location**: `docs/blog/posts/`

**Format**: Markdown with YAML frontmatter

**🔒 ONE-TIME SETUP (Recommended):**
```bash
# Install git hook for automatic validation
./scripts/install-git-hooks.sh
```

This installs a pre-commit hook that automatically validates blog posts before commits!

**Quick Start - Two Options:**

**Option 1: Import from dev.to (Easiest!)**
```bash
./scripts/import-from-devto.sh https://dev.to/yourname/your-post
```

**Option 2: Write from Scratch**
Follow the template in [`docs/blog/HOW_TO_POST.md`](docs/blog/HOW_TO_POST.md)

**⚠️ CRITICAL Requirements:**

1. **Date format MUST be unquoted:**
   ```yaml
   date: 2026-01-27  # ✅ Correct
   date: "2026-01-27"  # ❌ Build fails
   ```

2. **Categories MUST be a list:**
   ```yaml
   categories:        # ✅ Correct
     - Android
   categories: "Android"  # ❌ Build fails
   ```

3. **Include `<!-- more -->` separator:**
   ```markdown
   Your introduction...

   <!-- more -->

   Full content...
   ```
   This creates the excerpt and "Continue reading" button.

**Before Submitting (if no git hook installed):**
```bash
# Validate and auto-fix common issues
./scripts/validate-blog-posts.sh --fix
```

**With git hook installed:** Validation happens automatically on commit!

**Structure**:
```markdown
---
title: "Your Blog Post Title"
description: "Brief description"
author: "Your Name"
author_link: "https://yourwebsite.com"
date: 2026-01-23
tags:
  - android
  - kotlin
  - jetpack-compose
products:
  - Android
difficulty: intermediate
---

# Your Blog Post Title

Your content here...
```

**Naming**: Use date prefix, e.g., `2026-01-23-awesome-android-tips.md`

### 📊 Resources

Presentations, videos, papers, and tools.

**Presentations** (`docs/resources/presentations/`):
- Upload PDF or link to Google Slides
- Include metadata file (YAML)

**Videos** (`docs/resources/videos/`):
- Link to YouTube or other platforms
- Include metadata file (YAML)

**Example metadata** (`my-presentation.yml`):
```yaml
title: "Building Scalable Apps with Firebase"
author: "Jane Doe"
author_link: "https://example.com"
date: 2026-01-15
event: "Google I/O Extended 2026"
products:
  - Firebase
  - Cloud Functions
tags:
  - serverless
  - architecture
  - scalability
links:
  slides: "https://docs.google.com/presentation/d/..."
  video: "https://youtube.com/watch?v=..."
  code: "https://github.com/..."
```

### 🎓 Learning Paths

Curated learning journeys with multiple resources.

**Location**: `docs/learning-paths/{category}/`

**Contact**: Please open an issue to discuss adding a learning path before submitting.

## Submission Process

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/gde-americas-hub.git
cd gde-americas-hub
```

### 2. Create Branch

```bash
git checkout -b content/your-content-name
```

### 3. Add Content

Follow the structure for your content type above.

### 4. Test Locally

```bash
# Install dependencies
pip install -r requirements.txt

# Run local server
mkdocs serve

# Open http://127.0.0.1:8000 in browser
```

### 5. Submit PR

```bash
git add .
git commit -m "Add: [Content Type] Your Content Title"
git push origin content/your-content-name
```

Then open a Pull Request on GitHub.

## Content Guidelines

### Writing Style

- ✅ **Clear and concise**: Use simple language
- ✅ **Technical accuracy**: Verify all code and commands
- ✅ **Practical examples**: Include working code samples
- ✅ **Inclusive language**: Use welcoming, accessible language
- ❌ **No promotional content**: Focus on education, not products

### Code Examples

- Use proper syntax highlighting
- Include complete, runnable examples when possible
- Add comments for clarity
- Test all code before submitting

### Images & Media

- Optimize images (compress, resize)
- Use descriptive alt text
- Place images in `docs/assets/images/{section}/`
- Credit sources when required

### Links

- Use relative links for internal pages
- Verify all external links work
- Use descriptive link text (not "click here")

## Technical Setup

### Prerequisites

- Python 3.8+
- pip (Python package manager)
- Git

### Install MkDocs

```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Project Structure

```
gde-americas-hub/
├── docs/
│   ├── index.md
│   ├── codelabs/
│   │   ├── android/
│   │   ├── firebase/
│   │   └── ...
│   ├── blog/
│   │   ├── android/
│   │   ├── firebase/
│   │   └── ...
│   ├── resources/
│   │   ├── presentations/
│   │   ├── videos/
│   │   └── ...
│   └── learning-paths/
│       ├── mobile/
│       ├── web/
│       └── ...
├── mkdocs.yml
├── requirements.txt
└── CONTRIBUTING.md (this file)
```

### MkDocs Commands

```bash
# Start development server
mkdocs serve

# Build static site
mkdocs build

# Deploy to GitHub Pages (maintainers only)
mkdocs gh-deploy
```

## Questions?

- Open an [issue](https://github.com/gde-americas/gde-americas-hub/issues)
- Join our community forums
- Reach out to GDE Americas leadership

## Code of Conduct

All contributors must follow our [Code of Conduct](CODE_OF_CONDUCT.md).

---

Thank you for contributing to GDE Americas Hub! 🎉
