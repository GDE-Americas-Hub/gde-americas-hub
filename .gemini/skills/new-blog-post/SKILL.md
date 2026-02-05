---
name: new-blog-post
description: Use this skill when creating or adding a new blog post to the GDE Americas Hub. Covers correct frontmatter format, author registration, allowed categories, excerpt separator, and validation.
---

# New Blog Post

This skill guides the full workflow of creating a blog post that passes the project's pre-commit validation and integrates correctly with the MkDocs Material blog plugin.

---

## When to activate this skill

- The user wants to write or add a new blog post.
- The user wants to import an existing post from dev.to.
- The user is unsure about frontmatter format or categories.

---

## Step 1: Check author registration

Every post requires at least one author. Open `docs/blog/.authors.yml` and verify the author's handle exists. If it does not, add one before proceeding:

```yaml
  your_handle:
    name: Full Name
    description: GDE specialty (e.g. "GDE for Android, GDE for Cloud")
    avatar: https://github.com/your_handle.png
    url: https://github.com/your_handle   # optional
```

The `your_handle` key is what goes in the post's `authors` list.

---

## Step 2: Create the file

Create the post at:

```
docs/blog/posts/YYYY-MM-DD-your-slug.md
```

Use the date the post should appear as published. The slug should be lowercase, hyphen-separated, and descriptive. Use the template at `references/post-template.md` as a starting point.

---

## Step 3: Write the frontmatter

The frontmatter block must follow these rules exactly:

```yaml
---
draft: false
date: 2026-02-04
authors:
  - your_handle
categories:
  - General
---
```

### Rules that break the build if violated

| Field | Correct | Wrong |
|---|---|---|
| `date` | `date: 2026-02-04` (bare value) | `date: "2026-02-04"` (quoted — breaks date sorting) |
| `authors` | A YAML list (`- handle`) | A plain string (`authors: handle`) |
| `categories` | A YAML list (`- Category`) | A plain string (`categories: Category`) |

### Allowed categories

These are the only values accepted by the blog plugin (defined in `mkdocs.yml`):

- `Android`
- `Firebase`
- `Google Cloud`
- `Flutter`
- `AI & ML`
- `Web`
- `Maps`
- `Ads`
- `Workspace`
- `General`

A post can belong to multiple categories — just add more items to the list.

---

## Step 4: Add the excerpt separator

Place `<!-- more -->` after the introductory paragraph(s). Everything before it appears on the blog listing page; everything after requires the reader to click into the post.

---

## Step 5: Write the body

Standard Markdown. The Material theme supports these extras out of the box:

- **Admonitions:** `!!! note`, `!!! warning`, `!!! tip`, `!!! danger`
- **Code blocks:** Fenced with a language tag for syntax highlighting.
- **Mermaid diagrams:** Fenced code block with `mermaid` as the language.
- **Tabbed content:** `=== "Tab Title"` (indented block below).
- **Task lists:** `- [ ]` and `- [x]`.
- **Icons:** Octicons and Twemoji are available.

---

## Step 6: Validate before committing

Run the validator to catch frontmatter issues before the pre-commit hook does:

```bash
./scripts/validate-blog-posts.sh
```

If issues are reported, the auto-fix mode handles the most common ones (quoted dates, string-instead-of-list):

```bash
./scripts/validate-blog-posts.sh --fix
```

---

## Alternative: Import from dev.to

If the post already exists on dev.to, skip Steps 2–5 entirely and use the import script:

```bash
./scripts/import-from-devto.sh https://dev.to/user/post-slug
```

It fetches the content, converts the format, maps tags to allowed categories, and writes the file to `docs/blog/posts/`. Run the validator afterward to confirm everything is correct.

### How the script resolves the author

The URL path username (e.g. `gde` in `dev.to/gde/article`) may be an **organization or publication**, not the individual author. The script always extracts `user.username` from the article JSON and uses that as the actual author identity.

Resolution order (first match wins):

1. **CLI argument** — if a second argument is provided (`./scripts/import-from-devto.sh <url> <slug>`), it is used directly.
2. **`user.username`** from the article JSON — checked against `.authors.yml`. The script will inform you if this differs from the URL path username.
3. **`user.github_username`** from the article JSON — checked against `.authors.yml` as a fallback (covers the case where the `.authors.yml` key is a GitHub handle).
4. **Interactive prompt** — if neither matched, the script lists available authors and prompts. Default is `gde_americas`.

After resolution the script validates the final slug against `.authors.yml`. If it does not exist the import **aborts** with an error and prints a suggested entry pre-filled from the dev.to profile (see the procedure below).

### Register a new author from the dev.to profile

When the import script aborts with `Author 'X' not found`, it already printed a **suggested entry** using data it fetched from the article's `user` object (`name` and `avatar` come pre-filled from dev.to; `github_username` is shown as a comment if available). The only field that cannot be fetched automatically is `description` — that is the author's GDE specialty.

Follow these steps:

**1. Read the suggested entry** the script printed to the terminal. It looks like:

```
    username:
      name: Real Name          ← fetched from dev.to
      description: GDE for ... ← ONLY this needs filling
      avatar: https://...      ← fetched from dev.to
      # github: gh-handle      ← informational, optional
```

**2. Ask the user for their GDE specialty.** This goes into `description`. It can cover multiple areas, e.g. `"GDE for Cloud, GDE for AI & ML"`.

**3. Confirm the final entry with the user** before writing. Present:

```yaml
  username:
    name: <from script output>
    description: <user-provided specialty>
    avatar: <from script output>
```

**4. Write to `docs/blog/.authors.yml`.** Insert the confirmed entry before the commented-out example block at the bottom of the file. Indentation convention: 2 spaces for the author key, 4 spaces for its fields. Do not touch any other entries.

**5. Re-run the import script** with the original dev.to URL. The script will find the now-registered author and complete the import.

### Troubleshooting common import issues

| Symptom | Cause | Fix |
|---|---|---|
| `Author 'X' not found in .authors.yml` | The slug has no matching entry. | Follow the "Register a new author from the dev.to profile" procedure above. |
| Duplicate title at the top of the post | The original dev.to `body_markdown` contained a `# Title` H1 that matched the article title. | The script strips it automatically. If a duplicate still appears, remove it manually from the generated file. |
| Duplicate frontmatter block inside the body | The original post on dev.to included its own `---` frontmatter. | The script strips the leading frontmatter block automatically. If remnants remain, remove them manually. |
| Category is a single string instead of a list | Older runs of the script wrote categories as `- Android, Firebase` (one item). | Run `./scripts/validate-blog-posts.sh --fix` to auto-correct, or edit the file and split into separate `- ` lines. |
| Tags mapped to the same category appear once | e.g. both `ai` and `ml` tags map to `AI & ML`. | Expected — the script deduplicates automatically. |

---

## Reference

A copy-paste ready template is available at `references/post-template.md` in this skill directory.
