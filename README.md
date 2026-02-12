# GDE Americas Hub 🌎

The central technical hub for Google Developer Experts across the Americas.

Website https://gde-americas-hub.netlify.app/

## 🎯 About This Project

The **GDE Americas Hub** is a community-driven knowledge repository that brings together technical content, learning resources, and expertise from Google Developer Experts (GDEs) throughout North, Central, and South America, and the Caribbean.

### Why This Hub Exists

As the GDE community in the Americas continues to grow, we identified the need for a centralized platform where:

- **🌍 Regional Expertise** is accessible to all developers in the Americas
- **🤝 Collaboration** happens across countries, languages, and time zones
- **📚 Knowledge Sharing** is systematized and easily discoverable
- **🎓 Learning Paths** guide developers from beginner to expert
- **💡 Best Practices** are documented and shared by experienced practitioners

This hub serves as:

1. **A Learning Platform** - Codelabs, tutorials, and articles for developers at all levels
2. **A Resource Library** - Presentations, videos, and tools from conferences and events
3. **A Community Directory** - Connect with GDEs across the Americas
4. **A Collaboration Space** - Where GDEs contribute and maintain quality technical content

### Project Goals

- ✅ Provide high-quality, practical technical content in multiple languages
- ✅ Lower barriers to learning Google technologies across the Americas
- ✅ Foster collaboration among GDEs in the region
- ✅ Create a sustainable, community-maintained knowledge base
- ✅ Showcase the expertise and contributions of Americas GDEs

## 🚀 What's Inside

- **📚 Codelabs**: Hands-on coding tutorials across all Google technologies
- **✍️ Blog**: Technical articles and insights from GDEs
- **📊 Resources**: Presentations, videos, papers, and tools
- **🎓 Learning Paths**: Structured journeys to master Google technologies
- **👥 Community**: GDE directory, events, and forums

## 🗂️ Project Structure

```
docs/
├── codelabs/          # Interactive tutorials
│   ├── android/
│   ├── firebase/
│   ├── cloud/
│   ├── flutter/
│   ├── ai-ml/
│   ├── web/
│   ├── maps/
│   ├── ads/
│   └── workspace/
├── blog/              # Technical articles
│   ├── android/
│   ├── firebase/
│   ├── cloud/
│   ├── flutter/
│   ├── ai-ml/
│   ├── web/
│   ├── maps/
│   ├── ads/
│   ├── workspace/
│   └── general/
├── resources/         # Curated content
│   ├── presentations/
│   ├── videos/
│   ├── papers/
│   └── tools/
├── learning-paths/    # Structured learning
│   ├── mobile/
│   ├── web/
│   ├── cloud/
│   ├── ai-ml/
│   └── data/
└── community/         # Connect with GDEs
    ├── gdes/          # GDE directory
    ├── events/        # Calendar and meetups
    └── forums/        # Discussions
```

## 🛠️ Local Development

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)

### Setup

```bash
# Clone the repository
git clone https://github.com/gde-americas/gde-americas-hub.git
cd gde-americas-hub

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start development server
mkdocs serve
```

Open [http://127.0.0.1:8000](http://127.0.0.1:8000) in your browser.

### Build

```bash
# Build static site
mkdocs build

# Output will be in site/ directory
```

## 🚀 Deployment

This site is automatically deployed using **Netlify** with continuous deployment from GitHub.

### How It Works

**Every time code is pushed:**

1. **Main Branch** → Automatic production deployment
   - Generates all codelabs from source markdown
   - Builds the MkDocs site
   - Deploys to production URL

2. **Pull Requests** → Automatic deploy previews
   - Each PR gets a unique preview URL
   - Perfect for reviewing codelabs before merging
   - No local setup needed for reviewers!

3. **Other Branches** → Branch deployments
   - Test features before creating a PR

### What Gets Deployed

The build process automatically:
- Installs `claat` tool
- Exports all codelabs from `docs/codelabs/source/*.md`
- Builds the MkDocs site with all content
- Deploys to Netlify's global CDN

### Local vs Production

**Local Development:**
```bash
# 1. Write your codelab source
vim docs/codelabs/source/my-codelab.md

# 2. Export locally to preview (OPTIONAL)
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md android

# 3. Preview with MkDocs
mkdocs serve

# 4. Commit ONLY the source file
git add docs/codelabs/source/my-codelab.md
git commit -m "Add codelab: My Tutorial"
```

**⚠️ IMPORTANT**: Generated HTML files are **automatically git-ignored**. Do NOT commit them!

**Production Build (Automatic):**
```bash
# When you push to GitHub, Netlify automatically:
1. Installs claat tool
2. Exports codelabs from source/*.md (incremental for PRs, full for production)
3. Builds MkDocs site
4. Deploys to production/preview URL
```

**Why This Approach?**
- ✅ Clean repository (no generated files)
- ✅ No merge conflicts on HTML
- ✅ Faster PR reviews
- ✅ Always consistent (generated from source)
- ✅ Smaller repo size

See [`netlify.toml`](netlify.toml) for the full build configuration.

## 🤝 Contributing

We welcome contributions from all GDEs! This project thrives on community participation.

### How to Get Started

1. **📖 Read the Guidelines**: Start with our [Contributing Guidelines](CONTRIBUTING.md)
2. **🎯 Pick Your Area**: Choose from codelabs, blog posts, resources, or learning paths
3. **✍️ Create Content**: Follow our templates and quality standards
4. **🔍 Submit for Review**: Open a Pull Request for community review
5. **🎉 Get Published**: After approval, your content goes live!

### Becoming a Reviewer

Interested in helping review contributions? See our [Governance Document](GOVERNANCE.md) for requirements and the path to becoming a trusted reviewer.

**Quick Summary**: Active GDEs with at least 5 quality contributions can be nominated as reviewers.

### Quick Start for Contributors

1. **Fork** this repository
2. **Create a branch**: `git checkout -b content/my-awesome-tutorial`
3. **Add your content** following our [guidelines](CONTRIBUTING.md)
4. **Test locally**: `mkdocs serve`
5. **Submit PR**: Open a Pull Request with clear description

### Content Types

- **Codelabs**: Step-by-step tutorials using `claat` format
  - Use `./scripts/export-codelab.sh` for export
- **Blog Posts**: Technical articles in Markdown
  - Import from dev.to: `./scripts/import-from-devto.sh URL`
  - Validate before submitting: `./scripts/validate-blog-posts.sh --fix`
- **Resources**: Presentations, videos, papers with metadata
- **Learning Paths**: Curated learning journeys (discuss first)

## 📋 Technology Categories

Content is organized by Google product categories:

| Category | Products |
|----------|----------|
| 📱 **Mobile** | Android, Flutter |
| 🔥 **Firebase** | Authentication, Firestore, Functions, Hosting |
| ☁️ **Cloud** | Google Cloud Platform, Cloud Run, Kubernetes |
| 🤖 **AI & ML** | Gemini API, TensorFlow, ML Kit, Vertex AI |
| 🌐 **Web** | Web Platform, PWAs, Chrome Extensions |
| 🗺️ **Maps** | Maps Platform, Geolocation APIs |
| 💰 **Ads** | Google Ads, AdMob |
| 💼 **Workspace** | Apps Script, Workspace APIs |
| 📊 **Data** | BigQuery, Analytics, Looker |

## 🎨 Built With

- [MkDocs](https://www.mkdocs.org/) - Static site generator
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) - Material Design theme
- [Google Codelabs Tools](https://github.com/googlecodelabs/tools) - Codelab format
- [Netlify](https://netlify.com) - Deployment and hosting

## 📚 Documentation

### For Contributors

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute content
- **[docs/codelabs/source/README.md](docs/codelabs/source/README.md)** - Codelab authoring guide
- **[scripts/README.md](scripts/README.md)** - Helper scripts documentation

### For Maintainers

- **[GOVERNANCE.md](GOVERNANCE.md)** - Governance model and roles
- **[MAINTAINERS.md](MAINTAINERS.md)** - Current maintainers list
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Deployment and CI/CD setup
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community standards

### Important Notes

- **[docs/codelabs/README.md](docs/codelabs/README.md)** - ⚠️ **Read this**: What to commit vs. NOT commit
- **[WORKFLOW_SUMMARY.md](WORKFLOW_SUMMARY.md)** - Complete workflow documentation

## 📜 License

Content in this repository is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

Code samples are licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

## 🌟 Governance & Maintainers

This hub is maintained by the GDE Americas community following an open governance model.

- **👥 Current Maintainers**: See [MAINTAINERS.md](MAINTAINERS.md)
- **📜 Governance Model**: See [GOVERNANCE.md](GOVERNANCE.md)
- **🎯 Community Roles**: Contributor → Reviewer → Maintainer

We follow established best practices from successful open source communities like [Backstage](https://github.com/backstage/community/blob/main/GOVERNANCE.md) and [Istio](https://github.com/istio/community/blob/master/ROLES.md).

## 📧 Contact

- **Issues**: [GitHub Issues](https://github.com/gde-americas/gde-americas-hub/issues)
- **Discussions**: [GitHub Discussions](#)
- **Community Forums**: [Visit Forums](https://gde-americas-hub.github.io/community/forums/)

---

Made with ❤️ by Google Developer Experts across the Americas
