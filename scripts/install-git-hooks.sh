#!/bin/bash

# GDE Americas Hub - Git Hooks Installer
# Installs git hooks to enforce code quality and best practices

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  GDE Americas Hub - Git Hooks Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if we're in the repository root
if [ ! -f "mkdocs.yml" ]; then
    echo -e "${RED}✗ Error: Please run this script from the repository root directory${NC}"
    exit 1
fi

# Check if .git directory exists
if [ ! -d ".git" ]; then
    echo -e "${RED}✗ Error: Not a git repository${NC}"
    exit 1
fi

# Check if hooks directory exists
if [ ! -d "scripts/git-hooks" ]; then
    echo -e "${RED}✗ Error: scripts/git-hooks directory not found${NC}"
    exit 1
fi

echo -e "${YELLOW}Installing git hooks...${NC}"
echo ""

# Install pre-commit hook
if [ -f "scripts/git-hooks/pre-commit" ]; then
    cp scripts/git-hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo -e "${GREEN}✓ Installed pre-commit hook${NC}"
    echo "  - Validates blog posts before commit"
    echo "  - Checks date format, categories, authors, and <!-- more --> separator"
    echo ""
else
    echo -e "${RED}✗ pre-commit hook not found${NC}"
    exit 1
fi

# Summary
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Git hooks installed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}What happens now:${NC}"
echo ""
echo "  • Every commit with blog posts will be validated automatically"
echo "  • Invalid posts will block the commit with clear error messages"
echo "  • You can auto-fix issues with: ./scripts/validate-blog-posts.sh --fix"
echo "  • To bypass validation: git commit --no-verify (use sparingly!)"
echo ""
echo -e "${BLUE}What gets validated:${NC}"
echo ""
echo "  ✓ Date format (unquoted YYYY-MM-DD)"
echo "  ✓ Categories format (list, not string)"
echo "  ✓ Required fields (date, authors, categories)"
echo "  ✓ Author exists in .authors.yml"
echo "  ✓ Excerpt separator (<!-- more -->)"
echo ""
echo -e "${GREEN}Happy blogging! 🎉${NC}"
echo ""
