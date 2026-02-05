# AGENTS.md — GDE Americas Hub

Context and instructions for AI coding agents working on this project.

---

## Project overview

**GDE Americas Hub** is the central technical hub for Google Developer Experts (GDEs) across the Americas. It is a static documentation site built with **MkDocs + Material theme**, hosted on **Netlify**, and contains blog posts, interactive codelabs (via Google's `claat` tool), learning paths, and curated resources.

---

## Repository layout

```
.
├── docs/                        # All site content (source of truth)
│   ├── blog/posts/              # Blog posts (markdown + YAML frontmatter)
│   ├── blog/.authors.yml        # Author profiles for the blog plugin
│   ├── codelabs/source/         # Codelab source files (committed)
│   ├── codelabs/<category>/     # Generated codelab HTML (git-ignored, do NOT commit)
│   ├── learning-paths/          # Structured learning journeys
│   ├── resources/               # Curated external links
│   └── index.md                 # Site homepage
├── hooks/
│   └── copy_codelabs.py         # MkDocs post-build hook: copies generated codelabs into site/
├── scripts/                     # Build and content-management scripts
│   ├── export-codelab.sh        # Export a single codelab with claat
│   ├── export-all-codelabs.sh   # Batch export (incremental by default, --all for full)
│   ├── import-from-devto.sh     # Import a blog post from a dev.to URL
│   ├── validate-blog-posts.sh   # Validate blog frontmatter (has --fix mode)
│   └── git-hooks/pre-commit     # Pre-commit hook source (installed via install-git-hooks.sh)
├── mkdocs.yml                   # MkDocs configuration
├── netlify.toml                 # Netlify build & deploy configuration
└── requirements.txt             # Python dependencies
```

**Generated / not committed:**
- `docs/codelabs/<category>/<id>/` — HTML output from `claat`. Only `index.md` per category is tracked.
- `site/` — MkDocs build output.

---

## Setup and build commands

```bash
# 1. Create and activate a Python virtual environment
python3 -m venv .venv
source .venv/bin/activate          # Linux/macOS
# source .venv/Scripts/activate    # Windows

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Install claat (requires Go)
go install github.com/googlecodelabs/tools/claat@latest
export PATH=$PATH:$(go env GOPATH)/bin

# 4. Install git hooks (optional, recommended)
./scripts/install-git-hooks.sh

# 5. Build the full site
./scripts/export-all-codelabs.sh --all   # export all codelabs
mkdocs build                             # generate site/

# 6. Run dev server locally
mkdocs serve                             # http://127.0.0.1:8000
```

For a quick incremental build (only changed codelabs):

```bash
./scripts/export-all-codelabs.sh   # no flag = incremental
mkdocs build
```

---

## Blog posts

Blog posts live in `docs/blog/posts/`. Filename convention: `YYYY-MM-DD-slug.md`.

### Frontmatter rules (enforced by pre-commit hook)

```yaml
---
draft: false
date: 2026-01-23          # MUST be unquoted (no quotes around the date)
authors:
  - gde_americas          # Must be a list; keys must exist in .authors.yml
categories:
  - General               # Must be a list; values must match the allowed set below
---
```

**Allowed categories** (from `mkdocs.yml`):
`Android`, `Firebase`, `Google Cloud`, `Flutter`, `AI & ML`, `Web`, `Maps`, `Ads`, `Workspace`, `General`

**Excerpt separator:** Place `<!-- more -->` after the introduction to control what appears in the blog listing.

### Adding a new author

Edit `docs/blog/.authors.yml` and add an entry:

```yaml
  handle:
    name: Full Name
    description: GDE specialty
    avatar: https://github.com/handle.png
    url: https://github.com/handle       # optional
```

Then reference `handle` in the post's `authors` list.

### Importing from dev.to

```bash
./scripts/import-from-devto.sh https://dev.to/user/post-slug
```

The script converts the post, maps tags to allowed categories, and sets the correct date format.

---

## Codelabs

Source files live in `docs/codelabs/source/`. Each file uses Google's claat markdown format with a specific header (no YAML frontmatter):

```
author: Author Name
summary: Short description
id: unique-codelab-id
categories: tag1,tag2
environments: Web
status: Published
feedback link: https://github.com/gde-americas/gde-americas-hub/issues
analytics account: 0
```

### Exporting a single codelab

```bash
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md <category>
# Example:
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md firebase
```

Valid categories: `android`, `firebase`, `cloud`, `flutter`, `ai-ml`, `web`, `maps`, `ads`, `workspace`, `general`

The script runs `claat`, places the output in the correct folder, and updates the category `index.md`.

---

## Validation and git hooks

A pre-commit hook validates blog posts before every commit:

```bash
# Install the hook
./scripts/install-git-hooks.sh

# Run validation manually
./scripts/validate-blog-posts.sh

# Auto-fix common issues (unquoted dates, list format)
./scripts/validate-blog-posts.sh --fix
```

Common errors the validator catches:
- Date wrapped in quotes (`date: "2026-01-23"` → must be `date: 2026-01-23`)
- `categories` or `authors` as a plain string instead of a YAML list
- Missing required frontmatter fields

---

## CI/CD (Netlify)

Defined in `netlify.toml`. Three build contexts:

| Context | Trigger | Codelab build |
|---|---|---|
| `production` | Push to `main` | Full (`--all`) |
| `deploy-preview` | Pull request | Incremental |
| `branch-deploy` | Other branches | Incremental |

Every PR automatically gets a deploy preview URL from Netlify.

---

## Gemini CLI skills

Task-specific skills for Gemini CLI are in `.gemini/skills/`. Each skill is a self-contained directory with a `SKILL.md` and optional reference files. They are activated automatically when relevant.

| Skill | When it activates |
|---|---|
| `new-blog-post` | Creating or importing a blog post |
| `new-codelab` | Writing a new interactive codelab |

---

## Key constraints for agents

- **Do not commit generated files.** Everything under `docs/codelabs/<category>/<id>/` and `site/` is git-ignored and auto-generated at build time.
- **Date format in blog frontmatter must be unquoted.** The MkDocs blog plugin parses it as a native YAML date; quoting it breaks the sort and the plugin.
- **Categories and authors must be YAML lists**, not plain strings.
- **Do not modify `mkdocs.yml` navigation (`nav`) when adding codelabs.** The export script handles category indexes automatically.
- **Run `validate-blog-posts.sh` before committing** any blog post changes to catch format issues early.
- **Python 3.11** is the expected runtime (matches Netlify build environment).
