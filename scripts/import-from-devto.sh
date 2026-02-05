#!/bin/bash

# GDE Americas Hub - Import Blog Post from dev.to
# This script imports a blog post from dev.to and converts it to the correct format

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

# Check if running from repo root
if [ ! -f "mkdocs.yml" ]; then
    print_error "Please run this script from the repository root directory"
fi

# Usage
if [ $# -lt 1 ]; then
    echo "Usage: $0 <dev.to-url> [author-slug]"
    echo ""
    echo "Simply copy the URL from your browser and paste it here!"
    echo ""
    echo "Examples:"
    echo "  $0 https://dev.to/username/my-post-title-abc123"
    echo "  $0 https://dev.to/username/my-post-title-abc123 john_doe"
    echo ""
    echo "The author-slug should match an entry in docs/blog/.authors.yml"
    echo "If not provided, will prompt for it."
    echo ""
    echo "Requirements: Python3"
    exit 1
fi

DEVTO_URL=$1
AUTHOR_SLUG=$2

# Extract username and slug from URL
# Accepts any dev.to URL format: https://dev.to/username/article-slug
if [[ $DEVTO_URL =~ dev\.to/([^/]+)/([^/]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    ARTICLE_SLUG="${BASH_REMATCH[2]}"
    print_info "Fetching article from dev.to..."

    # Detect if URL has numeric ID (long number) or hash suffix
    # If it ends with a long number (6+ digits), it's an ID -> use /api/articles/{id}
    # Otherwise it's a slug with hash -> use /api/articles/{username}/{slug}
    if [[ $ARTICLE_SLUG =~ -([0-9]{6,})$ ]]; then
        # URL has numeric ID (e.g., -3158567)
        ARTICLE_ID="${BASH_REMATCH[1]}"
        API_URL="https://dev.to/api/articles/${ARTICLE_ID}"
    else
        # URL has hash or no special suffix (e.g., -4ceh or just slug)
        API_URL="https://dev.to/api/articles/${USERNAME}/${ARTICLE_SLUG}"
    fi
else
    print_error "Invalid dev.to URL format. Expected: https://dev.to/username/article-slug"
fi

# Fetch with curl
ARTICLE_JSON=$(curl -s "$API_URL")

# Check if response is empty or is an actual API error (has "status" field with error code)
if [ -z "$ARTICLE_JSON" ] || [[ "$ARTICLE_JSON" == *'"status"'* ]] || [[ "$ARTICLE_JSON" == *'"error":'* ]]; then
    print_error "Failed to fetch article. Check the URL and try again."
fi

# Extract metadata using Python (more reliable than sed for JSON parsing)
# Python is available on virtually all systems and handles JSON properly
PARSED_DATA=$(python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
    title = data.get('title', '')
    body = data.get('body_markdown', '')

    # --- Clean imported body ---
    # 1. Strip any leading frontmatter block (--- ... ---)
    body = body.strip()
    if body.startswith('---'):
        end = body.find('---', 3)
        if end != -1:
            body = body[end + 3:].strip()

    # 2. Strip the first H1 heading if it duplicates the title
    lines = body.split('\n')
    if lines and lines[0].strip().startswith('# '):
        heading_text = lines[0].strip().lstrip('#').strip()
        if heading_text.lower() == title.lower():
            lines = lines[1:]
            body = '\n'.join(lines).strip()

    print('TITLE=' + title)
    print('|||TITLE_END|||')
    print('DESCRIPTION=' + data.get('description', ''))
    print('|||DESCRIPTION_END|||')
    print('PUBLISHED_AT=' + data.get('published_at', ''))
    print('|||PUBLISHED_AT_END|||')
    print('CANONICAL_URL=' + data.get('canonical_url', ''))
    print('|||CANONICAL_URL_END|||')
    print('TAG_LIST=' + ','.join(data.get('tag_list', [])))
    print('|||TAG_LIST_END|||')

    # --- Author profile from article metadata ---
    # NOTE: user.username is the actual author; the URL path may be an org/publication.
    user = data.get('user', {})
    print('DEVTO_USERNAME=' + (user.get('username') or ''))
    print('|||DEVTO_USERNAME_END|||')
    print('DEVTO_NAME=' + (user.get('name') or ''))
    print('|||DEVTO_NAME_END|||')
    print('DEVTO_AVATAR=' + (user.get('profile_image_90') or ''))
    print('|||DEVTO_AVATAR_END|||')
    print('DEVTO_GITHUB=' + (user.get('github_username') or ''))
    print('|||DEVTO_GITHUB_END|||')

    print('BODY_MARKDOWN_START|||')
    print(body)
    print('|||BODY_MARKDOWN_END')
except Exception as e:
    print('ERROR: ' + str(e), file=sys.stderr)
    sys.exit(1)
" <<< "$ARTICLE_JSON")

if [ $? -ne 0 ]; then
    print_error "Failed to parse JSON. Is Python3 installed?"
fi

# Extract fields from parsed data
TITLE=$(echo "$PARSED_DATA" | sed -n '/^TITLE=/,/|||TITLE_END|||/p' | head -1 | sed 's/^TITLE=//')
DESCRIPTION=$(echo "$PARSED_DATA" | sed -n '/^DESCRIPTION=/,/|||DESCRIPTION_END|||/p' | head -1 | sed 's/^DESCRIPTION=//')
PUBLISHED_AT=$(echo "$PARSED_DATA" | sed -n '/^PUBLISHED_AT=/,/|||PUBLISHED_AT_END|||/p' | head -1 | sed 's/^PUBLISHED_AT=//')
CANONICAL_URL=$(echo "$PARSED_DATA" | sed -n '/^CANONICAL_URL=/,/|||CANONICAL_URL_END|||/p' | head -1 | sed 's/^CANONICAL_URL=//')
TAG_LIST=$(echo "$PARSED_DATA" | sed -n '/^TAG_LIST=/,/|||TAG_LIST_END|||/p' | head -1 | sed 's/^TAG_LIST=//')
BODY_MARKDOWN=$(echo "$PARSED_DATA" | sed -n '/BODY_MARKDOWN_START|||/,/|||BODY_MARKDOWN_END/p' | sed '1d;$d')
DEVTO_USERNAME=$(echo "$PARSED_DATA" | sed -n '/^DEVTO_USERNAME=/,/|||DEVTO_USERNAME_END|||/p' | head -1 | sed 's/^DEVTO_USERNAME=//')
DEVTO_NAME=$(echo "$PARSED_DATA" | sed -n '/^DEVTO_NAME=/,/|||DEVTO_NAME_END|||/p' | head -1 | sed 's/^DEVTO_NAME=//')
DEVTO_AVATAR=$(echo "$PARSED_DATA" | sed -n '/^DEVTO_AVATAR=/,/|||DEVTO_AVATAR_END|||/p' | head -1 | sed 's/^DEVTO_AVATAR=//')
DEVTO_GITHUB=$(echo "$PARSED_DATA" | sed -n '/^DEVTO_GITHUB=/,/|||DEVTO_GITHUB_END|||/p' | head -1 | sed 's/^DEVTO_GITHUB=//')

if [ -z "$TITLE" ]; then
    print_error "Failed to parse article data. The article might be private or the API response format changed."
fi

print_success "Article fetched: $TITLE"

# Extract date from published_at (format: 2026-01-27T12:00:00Z)
POST_DATE=$(echo "$PUBLISHED_AT" | cut -d'T' -f1)

# Convert tags to categories (deduplicated)
declare -a CATEGORIES_ARRAY=()

add_category() {
    local cat="$1"
    for existing in "${CATEGORIES_ARRAY[@]}"; do
        [ "$existing" = "$cat" ] && return
    done
    CATEGORIES_ARRAY+=("$cat")
}

if [ -n "$TAG_LIST" ]; then
    for tag in $(echo "$TAG_LIST" | tr ',' '\n'); do
        tag=$(echo "$tag" | xargs) # trim whitespace
        case "${tag,,}" in # lowercase for comparison
            android)                            add_category "Android" ;;
            firebase)                           add_category "Firebase" ;;
            gcp|cloud|googlecloud)              add_category "Google Cloud" ;;
            flutter)                            add_category "Flutter" ;;
            ai|ml|machinelearning|artificialintelligence|adk|mcp|a2a|llm|genai)
                                                add_category "AI & ML" ;;
            web|javascript|webdev)              add_category "Web" ;;
            maps|googlemaps)                    add_category "Maps" ;;
            ads|admob)                          add_category "Ads" ;;
            workspace|gsuite)                   add_category "Workspace" ;;
        esac
    done
fi

# Build YAML list; fall back to General if nothing matched
if [ ${#CATEGORIES_ARRAY[@]} -eq 0 ]; then
    CATEGORIES_YAML="  - General"
    print_warning "No matching categories found. Using 'General' as default."
else
    CATEGORIES_YAML=""
    for cat in "${CATEGORIES_ARRAY[@]}"; do
        CATEGORIES_YAML+="  - ${cat}"$'\n'
    done
    CATEGORIES_YAML="${CATEGORIES_YAML%$'\n'}"   # strip trailing newline
    print_success "Categories: ${CATEGORIES_ARRAY[*]}"
fi

# Helper: list registered authors from .authors.yml
list_authors() {
    grep "^  [a-z_][a-z0-9_]*:[[:space:]]*$" docs/blog/.authors.yml 2>/dev/null | sed 's/:.*$//' | sed 's/^[[:space:]]*//' | sed 's/^/    - /'
}

# Resolve author: CLI argument > article author (user.username) > GitHub username > prompt
# NOTE: USERNAME is the URL path (may be an org/publication on dev.to).
#       DEVTO_USERNAME is user.username from the article JSON — the actual author.
RESOLVED_USERNAME="${DEVTO_USERNAME:-$USERNAME}"
if [ "$RESOLVED_USERNAME" != "$USERNAME" ]; then
    print_info "URL path is '$USERNAME' but article author is '$RESOLVED_USERNAME'"
fi

if [ -z "$AUTHOR_SLUG" ]; then
    if grep -q "^  ${RESOLVED_USERNAME}:[[:space:]]*$" docs/blog/.authors.yml 2>/dev/null; then
        # Actual author username exists in .authors.yml
        AUTHOR_SLUG="$RESOLVED_USERNAME"
        print_success "Author matched: $AUTHOR_SLUG"
    elif [ -n "$DEVTO_GITHUB" ] && grep -q "^  ${DEVTO_GITHUB}:[[:space:]]*$" docs/blog/.authors.yml 2>/dev/null; then
        # GitHub username exists in .authors.yml
        AUTHOR_SLUG="$DEVTO_GITHUB"
        print_success "Author matched via GitHub username: $AUTHOR_SLUG"
    else
        # Neither registered — prompt with suggested entry
        echo ""
        print_info "Author '$RESOLVED_USERNAME' is not registered in .authors.yml"
        [ -n "$DEVTO_GITHUB" ] && print_info "GitHub username '$DEVTO_GITHUB' not registered either"
        print_info "Available authors:"
        list_authors
        echo ""
        print_info "Suggested entry from dev.to profile — only 'description' needs filling:"
        echo "    ${RESOLVED_USERNAME}:"
        echo "      name: ${DEVTO_NAME:-$RESOLVED_USERNAME}"
        echo "      description: GDE for ...    ← fill in specialty"
        echo "      avatar: ${DEVTO_AVATAR:-https://github.com/${RESOLVED_USERNAME}.png}"
        [ -n "$DEVTO_GITHUB" ] && echo "      # github: ${DEVTO_GITHUB}"
        echo ""
        read -p "Author slug [gde_americas]: " AUTHOR_SLUG
        AUTHOR_SLUG="${AUTHOR_SLUG:-gde_americas}"
    fi
fi

# Validate the resolved author exists — hard error if not found
if [ -f "docs/blog/.authors.yml" ]; then
    if ! grep -q "^  ${AUTHOR_SLUG}:[[:space:]]*$" docs/blog/.authors.yml; then
        echo ""
        echo -e "${RED}✗ Author '$AUTHOR_SLUG' not found in .authors.yml${NC}"
        echo ""
        echo "  Available authors:"
        list_authors
        echo ""
        echo "  Suggested entry from dev.to profile — only 'description' needs filling:"
        echo "    ${AUTHOR_SLUG}:"
        echo "      name: ${DEVTO_NAME:-$AUTHOR_SLUG}"
        echo "      description: GDE for ...    ← fill in specialty"
        echo "      avatar: ${DEVTO_AVATAR:-https://github.com/${AUTHOR_SLUG}.png}"
        [ -n "$DEVTO_GITHUB" ] && echo "      # github: ${DEVTO_GITHUB}"
        echo ""
        exit 1
    fi
fi

# Create filename (date-slug.md)
# Remove dev.to suffix if present:
# - Hash suffix (4-5 chars alphanumeric like -4ceh)
# - Numeric ID suffix (6+ digits like -3158567)
CLEAN_SLUG="$ARTICLE_SLUG"
if [[ $ARTICLE_SLUG =~ ^(.+)-([a-z0-9]{4,5}|[0-9]{6,})$ ]]; then
    CLEAN_SLUG="${BASH_REMATCH[1]}"
fi
FILENAME="${POST_DATE}-${CLEAN_SLUG}.md"
OUTPUT_PATH="docs/blog/posts/${FILENAME}"

# Check if file already exists
if [ -f "$OUTPUT_PATH" ]; then
    print_warning "File already exists: $OUTPUT_PATH"
    read -p "Overwrite? (y/n): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        print_error "Aborted"
    fi
fi

# Create the blog post file
cat > "$OUTPUT_PATH" << EOF
---
draft: false
date: ${POST_DATE}
authors:
  - ${AUTHOR_SLUG}
categories:
${CATEGORIES_YAML}
---

# ${TITLE}

${DESCRIPTION}

<!-- more -->

${BODY_MARKDOWN}

---

*Originally published at [dev.to](${CANONICAL_URL})*
EOF

print_success "Blog post created: $OUTPUT_PATH"
echo ""
print_info "Next steps:"
echo "  1. Review the generated file:"
echo "     cat $OUTPUT_PATH"
echo ""
echo "  2. Edit if needed (especially check date format and categories)"
echo ""
echo "  3. Validate the post:"
echo "     ./scripts/validate-blog-posts.sh $OUTPUT_PATH"
echo ""
echo "  4. Preview locally:"
echo "     mkdocs serve"
echo ""
echo "  5. Commit and push:"
echo "     git add $OUTPUT_PATH"
echo "     git commit -m \"Add blog post: ${TITLE}\""
echo "     git push"
echo ""
print_success "Import complete! 🎉"
