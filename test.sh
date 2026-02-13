#!/bin/bash

# Test script for Scrcpy Smart Connect v2.1.0
# This script tests all major features

echo "🧪 Testing Scrcpy Smart Connect v2.1.0"
echo "======================================"
echo ""

SCRIPT="./scrcpy-smart.sh"
PASSED=0
FAILED=0

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

test_command() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    
    echo -n "Testing $name... "
    
    if eval "$cmd" | grep -q "$expected"; then
        echo -e "${GREEN}✓ PASS${RESET}"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${RESET}"
        ((FAILED++))
    fi
}

# Test 1: Script exists and is executable
echo "1. Basic Tests"
echo "-------------"
if [ -x "$SCRIPT" ]; then
    echo -e "${GREEN}✓${RESET} Script is executable"
    ((PASSED++))
else
    echo -e "${RED}✗${RESET} Script is not executable"
    ((FAILED++))
fi

# Test 2: Syntax check
if bash -n "$SCRIPT" 2>/dev/null; then
    echo -e "${GREEN}✓${RESET} Syntax is valid"
    ((PASSED++))
else
    echo -e "${RED}✗${RESET} Syntax error"
    ((FAILED++))
fi

echo ""

# Test 3: Help command
echo "2. Command Tests"
echo "---------------"
test_command "Help" "$SCRIPT --help" "Scrcpy Smart Connect"
test_command "Version" "$SCRIPT --version" "2.2.0"

echo ""

# Test 4: New features in v2.1.0
echo "3. v2.1.0 Features"
echo "-----------------"
test_command "Rename option" "$SCRIPT --help" "rename"
test_command "Screenshot option" "$SCRIPT --help" "screenshot"
test_command "Port option" "$SCRIPT --help" "port"
test_command "IP option" "$SCRIPT --help" "ip"
test_command "No audio option" "$SCRIPT --help" "no-audio"
test_command "Clear logs option" "$SCRIPT --help" "clear-logs"

echo ""

# Test 5: File structure
echo "4. File Structure"
echo "----------------"
files=(
    "README.md"
    "CHANGELOG.md"
    "ROADMAP.md"
    "LICENSE"
    "install.sh"
    "scrcpy-smart-gui.sh"
    "docs/README.ar.md"
    "RELEASE_NOTES_v2.1.0.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${RESET} $file exists"
        ((PASSED++))
    else
        echo -e "${RED}✗${RESET} $file missing"
        ((FAILED++))
    fi
done

echo ""

# Test 6: Git status
echo "5. Git Status"
echo "------------"
if git status &>/dev/null; then
    echo -e "${GREEN}✓${RESET} Git repository"
    ((PASSED++))
    
    if git diff --quiet; then
        echo -e "${GREEN}✓${RESET} No uncommitted changes"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${RESET} Uncommitted changes"
    fi
    
    if git tag | grep -q "v2.1.0"; then
        echo -e "${GREEN}✓${RESET} Tag v2.1.0 exists"
        ((PASSED++))
    else
        echo -e "${RED}✗${RESET} Tag v2.1.0 missing"
        ((FAILED++))
    fi
else
    echo -e "${RED}✗${RESET} Not a git repository"
    ((FAILED++))
fi

echo ""

# Summary
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "Passed: ${GREEN}$PASSED${RESET}"
echo -e "Failed: ${RED}$FAILED${RESET}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Ready to launch!${RESET}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please fix before launching.${RESET}"
    exit 1
fi
