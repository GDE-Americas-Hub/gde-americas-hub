---
name: new-codelab
description: Use this skill when creating a new interactive codelab for the GDE Americas Hub. Covers the claat source format, the step-duration structure, and the full export-to-preview workflow.
---

# New Codelab

This skill guides the creation of a Google Codelab that integrates with the GDE Americas Hub build pipeline.

---

## When to activate this skill

- The user wants to write a new interactive tutorial / codelab.
- The user needs help with the claat markdown format.
- The user wants to export or preview a codelab locally.

---

## How codelabs work in this repo

1. Source files live in `docs/codelabs/source/` and are written in Google's claat Markdown format.
2. The export script (`scripts/export-codelab.sh`) runs `claat` to generate the interactive HTML.
3. The generated HTML goes into `docs/codelabs/<category>/<id>/` — this directory is **git-ignored**.
4. On deploy, Netlify rebuilds all codelabs automatically.

**Only the source `.md` file is committed to git.**

---

## Step 1: Create the source file

```
docs/codelabs/source/your-codelab-id.md
```

The filename (without `.md`) should match the `id` field in the header. Use lowercase and hyphens.

A minimal template is available at `references/codelab-template.md` in this skill directory.

---

## Step 2: Write the claat header

The header sits at the very top of the file. It is **not** YAML frontmatter — it uses a plain `key: value` format with no delimiters:

```
author: Your Full Name
summary: One-sentence description of what the reader will build or learn.
id: your-codelab-id
categories: tag1,tag2
environments: Web
status: Published
feedback link: https://github.com/gde-americas/gde-americas-hub/issues
analytics account: 0
```

### Field reference

| Field | Notes |
|---|---|
| `author` | Your full name (not a GitHub handle). |
| `summary` | Short description. Shown in the codelab listing. |
| `id` | Unique slug. Must match the filename. Lowercase, hyphens only. |
| `categories` | Comma-separated tags. Include at least one Google product area. |
| `environments` | `Web` for browser-based codelabs. `Android` or `iOS` if a native device/emulator is required. |
| `status` | `Published` when ready for the site. `Draft` while still in progress. |
| `feedback link` | Keep the default GitHub issues URL. |
| `analytics account` | Keep `0`. |

---

## Step 3: Structure the body

Each `##` heading becomes a visible step in the codelab UI. Every step **must** have a `Duration:` line as its first content line — claat uses these to calculate the total estimated time shown to the reader.

```markdown
# Codelab Title

## Overview
Duration: 0:03:00

What the reader will accomplish by the end of this codelab. Keep it concise.

## Prerequisites
Duration: 0:02:00

- Item one the reader needs (tool, account, knowledge).
- Item two.

## First Step Title
Duration: 0:10:00

Content for this step. Use `###` for sub-headings within a step; they do not create new steps.

### Sub-section

More detail here.

## Second Step Title
Duration: 0:15:00

Continue building toward the final result.

## What you've learned
Duration: 0:01:00

Recap checklist:

- Learned thing one.
- Learned thing two.

## Next steps
Duration: 0:01:00

Links to related documentation or follow-up codelabs.
```

### Supported content inside steps

- **Code blocks:** Standard fenced blocks with a language tag.
- **Images:** `![alt](image.png)` — place image files in the same `source/` directory.
- **Info boxes:** Use HTML aside elements:
  - `<aside class="positive">` — success / tip
  - `<aside class="negative">` — warning / caution
  - `<aside class="callout">` — neutral note
- **Download buttons and file attachments:** Supported via claat's syntax (consult the claat docs for details).

---

## Step 4: Export the codelab

Run the export script from the **repository root**:

```bash
./scripts/export-codelab.sh docs/codelabs/source/your-codelab-id.md <category>
```

### Valid categories

`android`, `firebase`, `cloud`, `flutter`, `ai-ml`, `web`, `maps`, `ads`, `workspace`, `general`

### Example

```bash
./scripts/export-codelab.sh docs/codelabs/source/firebase-auth-quickstart.md firebase
```

The script:
1. Runs `claat` on the source file.
2. Moves the output into `docs/codelabs/<category>/<id>/`.
3. Updates the category `index.md` if needed.

---

## Step 5: Preview locally

```bash
mkdocs serve
```

Open `http://127.0.0.1:8000/codelabs/<category>/<id>/` in a browser to verify the codelab renders correctly. Walk through each step to make sure durations, code blocks, and info boxes display as expected.

---

## Step 6: Commit and submit a PR

Only the source file should be staged. The generated HTML is git-ignored:

```bash
git add docs/codelabs/source/your-codelab-id.md
git commit -m "Add <codelab title> codelab"
```

Open a PR. Netlify will automatically generate a deploy preview with the codelab included.

---

## Reference

A minimal working template is available at `references/codelab-template.md` in this skill directory.
