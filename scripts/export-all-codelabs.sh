#!/bin/bash

# GDE Americas Hub - Export Codelabs
# This script exports codelabs from source/ to their respective categories
# Supports incremental builds (only changed files) and full builds
# Used during CI/CD build process

set -e

# Parse arguments
FORCE_ALL=false
if [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
    FORCE_ALL=true
fi

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

print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if claat is installed
if ! command -v claat &> /dev/null; then
    print_info "claat is not installed. Installing..."

    # Try to install claat
    if command -v go &> /dev/null; then
        print_info "Installing claat via Go..."
        go install github.com/googlecodelabs/tools/claat@latest

        # Update PATH to include Go bin directory
        export PATH=$PATH:$(go env GOPATH)/bin

        # Verify installation
        if ! command -v claat &> /dev/null; then
            print_error "Failed to install claat. Please install manually from: https://github.com/googlecodelabs/tools/releases"
        fi
        print_success "claat installed successfully"
    else
        print_error "Go is not installed. Please install Go or download claat binary from: https://github.com/googlecodelabs/tools/releases"
    fi
fi

# Check if running from repo root
if [ ! -f "mkdocs.yml" ]; then
    print_error "Please run this script from the repository root directory"
fi

print_header "GDE Americas Hub - Exporting Codelabs"

# Source directory
SOURCE_DIR="docs/codelabs/source"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory not found: $SOURCE_DIR"
fi

# Determine which files to export
if [ "$FORCE_ALL" = true ]; then
    print_info "Force mode: Exporting ALL codelabs"
    # Find all markdown files in source directory (excluding README and HOW_TO files)
    CODELAB_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.md" ! -name "README.md" ! -name "HOW_TO*.md")
else
    # Incremental build: only export changed files
    print_info "Incremental mode: Detecting changed codelabs..."

    # Get base commit for comparison
    # In Netlify: CACHED_COMMIT_REF vs COMMIT_REF
    # Locally: HEAD vs previous commit
    if [ -n "$CACHED_COMMIT_REF" ] && [ -n "$COMMIT_REF" ]; then
        # Netlify environment
        BASE_REF="$CACHED_COMMIT_REF"
        HEAD_REF="$COMMIT_REF"
        print_info "Comparing: $BASE_REF...$HEAD_REF"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        # Local git environment
        if git rev-parse HEAD~1 > /dev/null 2>&1; then
            BASE_REF="HEAD~1"
            HEAD_REF="HEAD"
            print_info "Comparing: HEAD~1...HEAD (local)"
        else
            # First commit or no previous commits
            print_info "No previous commit found, exporting all codelabs"
            FORCE_ALL=true
            CODELAB_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.md" ! -name "README.md" ! -name "HOW_TO*.md")
        fi
    else
        # Not a git repo, export all
        print_info "Not a git repository, exporting all codelabs"
        FORCE_ALL=true
        CODELAB_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.md" ! -name "README.md" ! -name "HOW_TO*.md")
    fi

    if [ "$FORCE_ALL" != true ]; then
        # Get changed markdown files in source directory
        CHANGED_FILES=$(git diff --name-only "$BASE_REF" "$HEAD_REF" -- "$SOURCE_DIR/*.md" 2>/dev/null || echo "")

        if [ -z "$CHANGED_FILES" ]; then
            print_info "No codelab source files changed. Skipping export."
            print_info "Use --all flag to force export all codelabs"
            exit 0
        fi

        # Convert to full paths
        CODELAB_FILES=""
        for file in $CHANGED_FILES; do
            if [[ ! "$file" =~ README\.md$ ]] && [[ ! "$file" =~ HOW_TO.*\.md$ ]]; then
                CODELAB_FILES="$CODELAB_FILES $file"
            fi
        done

        if [ -z "$CODELAB_FILES" ]; then
            print_info "No codelab source files to export (only README/HOW_TO changed)"
            exit 0
        fi
    fi
fi

if [ -z "$CODELAB_FILES" ]; then
    print_info "No codelab files found to export"
    exit 0
fi

# Count total codelabs
TOTAL_CODELABS=$(echo "$CODELAB_FILES" | wc -l)
if [ "$FORCE_ALL" = true ]; then
    print_info "Exporting $TOTAL_CODELABS codelab(s) (full build)"
else
    print_info "Exporting $TOTAL_CODELABS changed codelab(s) (incremental build)"
fi
echo ""

# Counter for success/failure
SUCCESS_COUNT=0
FAILURE_COUNT=0

# Map of categories to directories
declare -A CATEGORY_MAP
CATEGORY_MAP["android"]="android"
CATEGORY_MAP["firebase"]="firebase"
CATEGORY_MAP["cloud"]="cloud"
CATEGORY_MAP["flutter"]="flutter"
CATEGORY_MAP["ai-ml"]="ai-ml"
CATEGORY_MAP["ai"]="ai-ml"
CATEGORY_MAP["ml"]="ai-ml"
CATEGORY_MAP["web"]="web"
CATEGORY_MAP["maps"]="maps"
CATEGORY_MAP["ads"]="ads"
CATEGORY_MAP["workspace"]="workspace"
CATEGORY_MAP["general"]="general"
CATEGORY_MAP["meta"]="general"
CATEGORY_MAP["tutorial"]="general"
CATEGORY_MAP["contributing"]="general"

# Function to determine category from codelab metadata
get_category_from_metadata() {
    local file=$1

    # Read categories line from metadata
    local categories=$(grep "^categories:" "$file" | head -1 | sed 's/categories: *//')

    if [ -z "$categories" ]; then
        echo "general"
        return
    fi

    # Split categories by comma and check each one
    IFS=',' read -ra CATS <<< "$categories"
    for cat in "${CATS[@]}"; do
        # Trim whitespace
        cat=$(echo "$cat" | xargs)
        # Convert to lowercase
        cat=$(echo "$cat" | tr '[:upper:]' '[:lower:]')

        # Check if category exists in our map
        if [ -n "${CATEGORY_MAP[$cat]}" ]; then
            echo "${CATEGORY_MAP[$cat]}"
            return
        fi
    done

    # Default to general if no match found
    echo "general"
}

# Export each codelab
for FILE in $CODELAB_FILES; do
    # Normalize path (remove leading ./)
    FILE=$(echo "$FILE" | sed 's|^\./||')

    # Get basename
    BASENAME=$(basename "$FILE")
    print_info "Processing: $BASENAME"

    # Get absolute path to file
    if [[ "$FILE" = /* ]]; then
        # Already absolute
        FILE_PATH="$FILE"
    else
        # Make it absolute from repo root
        FILE_PATH="$(pwd)/$FILE"
    fi

    # Check if file exists
    if [ ! -f "$FILE_PATH" ]; then
        print_error "  File not found: $FILE_PATH"
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
        continue
    fi

    # Determine category
    CATEGORY=$(get_category_from_metadata "$FILE_PATH")
    print_info "  Category: $CATEGORY"

    # Create temp directory for export
    TEMP_DIR=$(mktemp -d)

    # Change to source directory where the file is
    FILE_DIR=$(dirname "$FILE_PATH")
    cd "$FILE_DIR"

    # Export the codelab
    if claat export "$BASENAME" > /dev/null 2>&1; then
        # Find the generated directory
        GENERATED_DIR=$(find . -maxdepth 1 -type d -newer "$TEMP_DIR" ! -path . | head -1)

        if [ -z "$GENERATED_DIR" ]; then
            print_error "  Could not find generated directory for $BASENAME"
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
            cd - > /dev/null
            rm -rf "$TEMP_DIR"
            continue
        fi

        CODELAB_ID=$(basename "$GENERATED_DIR")

        # Return to repo root
        cd - > /dev/null

        # Create category directory if it doesn't exist
        CATEGORY_DIR="docs/codelabs/$CATEGORY"
        mkdir -p "$CATEGORY_DIR"

        # Move generated codelab to category
        TARGET_PATH="$CATEGORY_DIR/$CODELAB_ID"

        if [ -d "$TARGET_PATH" ]; then
            rm -rf "$TARGET_PATH"
        fi

        mv "$SOURCE_DIR/$CODELAB_ID" "$TARGET_PATH"
        print_success "  Exported to: $TARGET_PATH/"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        print_error "  Failed to export $BASENAME"
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
        cd - > /dev/null
    fi

    # Clean up
    rm -rf "$TEMP_DIR"
    echo ""
done

# Summary
print_header "Export Summary"
if [ "$FORCE_ALL" = true ]; then
    print_info "Mode: Full build (all codelabs)"
else
    print_info "Mode: Incremental build (changed codelabs only)"
fi
print_success "$SUCCESS_COUNT codelab(s) exported successfully"
if [ $FAILURE_COUNT -gt 0 ]; then
    print_error "$FAILURE_COUNT codelab(s) failed to export"
    exit 1
fi

print_info "All codelabs exported successfully! 🎉"
if [ "$FORCE_ALL" != true ]; then
    echo ""
    print_info "Tip: Use --all flag to force export all codelabs"
fi
echo ""
