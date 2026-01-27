#!/bin/bash

# GDE Americas Hub - Blog Post Validator
# Validates blog post frontmatter and can auto-fix common issues

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
VALID=0
WARNINGS=0
ERRORS=0
FIXED=0

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
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if running from repo root
if [ ! -f "mkdocs.yml" ]; then
    print_error "Please run this script from the repository root directory"
    exit 1
fi

# Parse arguments
AUTO_FIX=false
TARGET_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --fix|-f)
            AUTO_FIX=true
            shift
            ;;
        *)
            TARGET_FILE="$1"
            shift
            ;;
    esac
done

# Usage
if [ "$TARGET_FILE" != "" ] && [ ! -f "$TARGET_FILE" ]; then
    echo "Usage: $0 [--fix] [file]"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Validate all posts"
    echo "  $0 --fix                              # Validate and auto-fix all posts"
    echo "  $0 docs/blog/posts/my-post.md         # Validate specific post"
    echo "  $0 --fix docs/blog/posts/my-post.md   # Validate and fix specific post"
    echo ""
    exit 1
fi

print_header "GDE Americas Hub - Blog Post Validator"

if [ "$AUTO_FIX" = true ]; then
    print_warning "Auto-fix mode enabled. Files will be modified."
    echo ""
fi

# Function to validate a single post
validate_post() {
    local file=$1
    local filename=$(basename "$file")
    local has_errors=false
    local has_warnings=false
    local needs_fix=false

    TOTAL=$((TOTAL + 1))

    echo -e "${BLUE}Validating:${NC} $filename"

    # Extract frontmatter (between --- markers)
    if ! grep -q "^---$" "$file"; then
        print_error "  No frontmatter found"
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    # Extract frontmatter content
    FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d')

    # Check required fields
    # 1. Date field (CRITICAL)
    if echo "$FRONTMATTER" | grep -q "^date:"; then
        DATE_LINE=$(echo "$FRONTMATTER" | grep "^date:")
        DATE_VALUE=$(echo "$DATE_LINE" | sed 's/date: *//')

        # Check if date is quoted (STRING - BAD)
        if [[ "$DATE_VALUE" =~ ^[\"\'] ]]; then
            print_error "  Date is quoted (string) - this will BREAK the build!"
            echo "    Current: date: $DATE_VALUE"
            echo "    Should be: date: $(echo $DATE_VALUE | tr -d '\"'"'"'')"
            has_errors=true
            needs_fix=true
            ERRORS=$((ERRORS + 1))
        # Check if date looks like a date (YYYY-MM-DD)
        elif [[ ! "$DATE_VALUE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            print_error "  Date format is invalid (should be YYYY-MM-DD unquoted)"
            echo "    Current: date: $DATE_VALUE"
            has_errors=true
            needs_fix=true
            ERRORS=$((ERRORS + 1))
        else
            print_success "  Date format: ✓ (unquoted date object)"
        fi
    else
        print_error "  Missing required field: date"
        has_errors=true
        ERRORS=$((ERRORS + 1))
    fi

    # 2. Authors field
    if echo "$FRONTMATTER" | grep -q "^authors:"; then
        print_success "  Authors field: ✓"

        # Check if authors exist in .authors.yml
        if [ -f "docs/blog/.authors.yml" ]; then
            AUTHORS_IN_POST=$(echo "$FRONTMATTER" | sed -n '/^authors:/,/^[a-z]/p' | grep "^  -" | sed 's/^  - //')
            for author in $AUTHORS_IN_POST; do
                if ! grep -q "^${author}:" docs/blog/.authors.yml; then
                    print_warning "  Author '$author' not found in .authors.yml"
                    has_warnings=true
                    WARNINGS=$((WARNINGS + 1))
                fi
            done
        fi
    else
        print_error "  Missing required field: authors"
        has_errors=true
        ERRORS=$((ERRORS + 1))
    fi

    # 3. Categories field (can be auto-fixed)
    if echo "$FRONTMATTER" | grep -q "^categories:"; then
        CATEGORIES_LINE=$(echo "$FRONTMATTER" | grep "^categories:")
        CATEGORIES_VALUE=$(echo "$CATEGORIES_LINE" | sed 's/categories: *//')

        # Check if categories is a STRING instead of a LIST (CRITICAL ERROR)
        # Patterns to detect:
        # - categories: "Events"
        # - categories: 'Events'
        # - categories: Events (single word on same line, not a list)
        # - categories: ["Events"] (inline list is OK)
        if [[ -n "$CATEGORIES_VALUE" ]] && [[ ! "$CATEGORIES_VALUE" =~ ^\[.*\]$ ]]; then
            # It has a value on the same line and it's not an inline list
            # This means it's a string, which will BREAK the build
            print_error "  Categories is a STRING, not a LIST - this will BREAK the build!"
            echo "    Current: categories: $CATEGORIES_VALUE"
            echo "    Should be:"
            echo "      categories:"
            echo "        - $(echo $CATEGORIES_VALUE | tr -d '\"'"'"'')"
            echo "    Or inline: categories: [\"$(echo $CATEGORIES_VALUE | tr -d '\"'"'"'')\"]"
            has_errors=true
            needs_fix=true
            ERRORS=$((ERRORS + 1))
        else
            # Check if it's a proper list
            CATEGORIES_COUNT=$(echo "$FRONTMATTER" | sed -n '/^categories:/,/^[a-z]/p' | grep -c "^  -" || echo "0")
            if [ "$CATEGORIES_COUNT" -eq 0 ] && [[ ! "$CATEGORIES_VALUE" =~ ^\[.*\]$ ]]; then
                print_warning "  Categories field exists but is empty - will add 'General'"
                has_warnings=true
                needs_fix=true
                WARNINGS=$((WARNINGS + 1))
            else
                # Check if it's inline list format
                if [[ "$CATEGORIES_VALUE" =~ ^\[.*\]$ ]]; then
                    print_success "  Categories field: ✓ (inline list format)"
                else
                    print_success "  Categories field: ✓ ($CATEGORIES_COUNT categories)"
                fi
            fi
        fi
    else
        print_warning "  Missing categories field - will add 'General'"
        has_warnings=true
        needs_fix=true
        WARNINGS=$((WARNINGS + 1))
    fi

    # 4. Draft field (optional but recommended)
    if ! echo "$FRONTMATTER" | grep -q "^draft:"; then
        print_info "  Optional: draft field not set (defaults to false)"
    fi

    # 5. Check for <!-- more --> separator (recommended for excerpt)
    if ! grep -q "<!-- more -->" "$file"; then
        print_warning "  Missing '<!-- more -->' separator - post won't show 'Continue reading' button"
        echo "    Add '<!-- more -->' after your introduction to create an excerpt"
        has_warnings=true
        WARNINGS=$((WARNINGS + 1))
    else
        print_success "  Excerpt separator: ✓ (<!-- more --> found)"
    fi

    # Auto-fix if requested
    if [ "$AUTO_FIX" = true ] && [ "$needs_fix" = true ]; then
        print_info "  Attempting to fix..."

        # Create temp file
        TEMP_FILE=$(mktemp)
        cp "$file" "$TEMP_FILE"

        # Fix quoted date
        if echo "$FRONTMATTER" | grep -q "^date:" && [[ $(echo "$FRONTMATTER" | grep "^date:" | sed 's/date: *//') =~ ^[\"\'] ]]; then
            DATE_VALUE=$(echo "$FRONTMATTER" | grep "^date:" | sed 's/date: *//' | tr -d '\"'"'"'')
            sed -i "s/^date: .*/date: $DATE_VALUE/" "$TEMP_FILE"
            print_success "  Fixed: Removed quotes from date"
            FIXED=$((FIXED + 1))
        fi

        # Fix categories if it's a STRING (convert to LIST)
        if echo "$FRONTMATTER" | grep -q "^categories:"; then
            CATEGORIES_LINE=$(echo "$FRONTMATTER" | grep "^categories:")
            CATEGORIES_VALUE=$(echo "$CATEGORIES_LINE" | sed 's/categories: *//')

            # Check if it's a string (has value on same line and not inline list)
            if [[ -n "$CATEGORIES_VALUE" ]] && [[ ! "$CATEGORIES_VALUE" =~ ^\[.*\]$ ]]; then
                # It's a string, convert to list
                CAT_CLEAN=$(echo "$CATEGORIES_VALUE" | tr -d '\"'"'"'')

                # Replace the line with list format
                sed -i "/^categories:/c\categories:\n  - $CAT_CLEAN" "$TEMP_FILE"
                print_success "  Fixed: Converted categories from string to list"
                FIXED=$((FIXED + 1))
            fi
        fi

        # Add categories if missing or empty
        if ! echo "$FRONTMATTER" | grep -q "^categories:" || [ "$CATEGORIES_COUNT" -eq 0 ]; then
            # Find the line number after authors section
            LINE_NUM=$(grep -n "^authors:" "$TEMP_FILE" | cut -d: -f1)
            if [ -n "$LINE_NUM" ]; then
                # Count how many lines the authors section has
                AUTHOR_LINES=$(sed -n "${LINE_NUM},/^[a-z]/p" "$TEMP_FILE" | grep -c "^  -" || echo "1")
                INSERT_LINE=$((LINE_NUM + AUTHOR_LINES + 1))

                # Insert categories
                sed -i "${INSERT_LINE}icategories:\\n  - General" "$TEMP_FILE"
                print_success "  Fixed: Added 'General' category"
                FIXED=$((FIXED + 1))
            fi
        fi

        # Replace original file
        mv "$TEMP_FILE" "$file"
        print_success "  File updated"
    fi

    # Summary for this file
    if [ "$has_errors" = true ]; then
        echo -e "${RED}  Status: FAIL (build will break)${NC}"
        return 1
    elif [ "$has_warnings" = true ]; then
        if [ "$AUTO_FIX" = true ] && [ "$needs_fix" = true ]; then
            echo -e "${GREEN}  Status: FIXED${NC}"
            VALID=$((VALID + 1))
        else
            echo -e "${YELLOW}  Status: WARNING (should fix)${NC}"
            VALID=$((VALID + 1))
        fi
    else
        echo -e "${GREEN}  Status: PASS${NC}"
        VALID=$((VALID + 1))
    fi

    echo ""
}

# Find posts to validate
if [ -n "$TARGET_FILE" ]; then
    # Validate single file
    validate_post "$TARGET_FILE"
else
    # Validate all posts
    POST_FILES=$(find docs/blog/posts -name "*.md" 2>/dev/null || echo "")

    if [ -z "$POST_FILES" ]; then
        print_info "No blog posts found in docs/blog/posts/"
        exit 0
    fi

    for file in $POST_FILES; do
        validate_post "$file"
    done
fi

# Final summary
print_header "Validation Summary"

echo "Total posts checked: $TOTAL"
print_success "Valid: $VALID"

if [ $WARNINGS -gt 0 ]; then
    print_warning "Warnings: $WARNINGS"
fi

if [ $ERRORS -gt 0 ]; then
    print_error "Errors: $ERRORS (will break build!)"
fi

if [ $FIXED -gt 0 ]; then
    print_success "Fixed: $FIXED issues"
fi

echo ""

# Exit code
if [ $ERRORS -gt 0 ]; then
    print_error "Validation FAILED. Please fix the errors above."
    echo ""
    print_info "Tip: Run with --fix to auto-fix common issues:"
    echo "  ./scripts/validate-blog-posts.sh --fix"
    echo ""
    exit 1
else
    print_success "All posts are valid! 🎉"
    exit 0
fi
