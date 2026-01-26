# Codelabs Directory Structure

This directory contains all codelabs for the GDE Americas Hub.

## 📁 Directory Organization

```
docs/codelabs/
├── source/           ← 📝 SOURCE FILES (committed to Git)
│   ├── README.md
│   └── *.md         ← Write your codelabs here
│
├── android/
│   ├── index.md     ← ✅ Committed (category listing)
│   └── */           ← ❌ NOT committed (generated HTML)
│
├── firebase/
│   ├── index.md     ← ✅ Committed
│   └── */           ← ❌ NOT committed (generated HTML)
│
└── [other categories...]
```

## ⚠️ IMPORTANT: What Gets Committed

### ✅ DO Commit to Git:

- `source/*.md` - All source markdown files
- `*/index.md` - Category index pages
- `.gitkeep` files (to preserve empty directories)

### ❌ DO NOT Commit to Git:

- `android/your-codelab-id/` - Generated HTML directories
- `firebase/your-codelab-id/` - Generated HTML directories
- Any `*/` subdirectories in category folders (except `source/`)

**These are automatically git-ignored and generated during deployment!**

## 🔄 How It Works

### 1. You Write Source Markdown

```bash
# Create your codelab source
vim docs/codelabs/source/my-awesome-tutorial.md
```

### 2. (Optional) Preview Locally

```bash
# Export to preview your changes
./scripts/export-codelab.sh docs/codelabs/source/my-awesome-tutorial.md android

# This generates HTML in docs/codelabs/android/my-awesome-tutorial/
# But it's git-ignored, so it won't be committed
```

### 3. Commit Only the Source

```bash
git add docs/codelabs/source/my-awesome-tutorial.md
git add docs/codelabs/android/index.md  # If updated by script
git commit -m "Add codelab: My Awesome Tutorial"
git push
```

### 4. CI/CD Generates Everything

When you push or create a PR:

```bash
# Netlify automatically:
1. Installs claat tool
2. Exports ALL codelabs from source/*.md
3. Builds the full MkDocs site
4. Deploys to production/preview
```

## 🎯 Why This Approach?

| Benefit | Description |
|---------|-------------|
| **Clean Repo** | No generated files in Git |
| **No Conflicts** | Source is single source of truth |
| **Easy Reviews** | PRs only show source changes |
| **Consistency** | Always built fresh from source |
| **Smaller Size** | Repo stays lightweight |
| **Fast CI** | Incremental builds for PRs |

## 📚 More Information

- **Creating Codelabs**: See [`source/README.md`](source/README.md)
- **Contributing Guide**: See [`../CONTRIBUTING.md`](../CONTRIBUTING.md)

For more detailed information about deployment and scripts, visit the [GitHub repository](https://github.com/gde-americas/gde-americas-hub).

## 🆘 Common Mistakes

### ❌ Mistake 1: Trying to commit generated HTML

```bash
# This will fail (git-ignored):
git add docs/codelabs/android/my-tutorial/
# error: pathspec 'docs/codelabs/android/my-tutorial/' did not match any files
```

**Solution**: This is correct behavior! Only commit the source file.

### ❌ Mistake 2: Expecting to see HTML in the repo

After exporting locally, you won't see the HTML in `git status`. This is intentional!

**Solution**: The HTML is for local preview only. CI/CD generates it for deployment.

### ❌ Mistake 3: Manually updating category indexes

The export script automatically updates `index.md` files.

**Solution**: Use `./scripts/export-codelab.sh` and it will update the index for you.

---

**Questions?** Check the [source/README.md](source/README.md) or open an issue!
