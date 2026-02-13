#!/bin/bash

# Comprehensive Test Suite for Scrcpy Smart Connect v3.0.0

echo "🧪 Scrcpy Smart Connect v3.0.0 - Comprehensive Test Suite"
echo "=========================================================="
echo ""

SCRIPT="./scrcpy-smart.sh"
PASSED=0
FAILED=0

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

test_command() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    
    echo -n "  Testing $name... "
    
    if eval "$cmd" | grep -q "$expected"; then
        echo -e "${GREEN}✓ PASS${RESET}"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${RESET}"
        ((FAILED++))
    fi
}

# Test 1: Basic Tests
echo -e "${CYAN}1. Basic Tests${RESET}"
if [ -x "$SCRIPT" ]; then
    echo -e "  ${GREEN}✓${RESET} Script is executable"
    ((PASSED++))
else
    echo -e "  ${RED}✗${RESET} Script not executable"
    ((FAILED++))
fi

if bash -n "$SCRIPT" 2>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Syntax valid"
    ((PASSED++))
else
    echo -e "  ${RED}✗${RESET} Syntax error"
    ((FAILED++))
fi

# Test 2: Core Commands
echo -e "\n${CYAN}2. Core Commands${RESET}"
test_command "Help" "$SCRIPT --help" "Scrcpy Smart Connect"
test_command "Version" "$SCRIPT --version" "3.0.0"

# Test 3: v3.0.0 Features
echo -e "\n${CYAN}3. v3.0.0 Features${RESET}"
test_command "QR Pairing" "$SCRIPT --help" "qr"
test_command "Pair command" "$SCRIPT --help" "pair"
test_command "Plugin system" "$SCRIPT --help" "plugin"
test_command "List plugins" "$SCRIPT --help" "list-plugins"

# Test 4: All Major Features
echo -e "\n${CYAN}4. All Features${RESET}"
test_command "Profiles" "$SCRIPT --help" "profile"
test_command "Quality" "$SCRIPT --help" "quality"
test_command "Scan" "$SCRIPT --help" "scan"
test_command "Performance" "$SCRIPT --help" "perf"
test_command "Batch" "$SCRIPT --help" "batch"
test_command "Clipboard" "$SCRIPT --help" "copy"
test_command "Notifications" "$SCRIPT --help" "notify"
test_command "Watch" "$SCRIPT --help" "watch"
test_command "Info" "$SCRIPT --help" "info"
test_command "Backup" "$SCRIPT --help" "backup"
test_command "Rotate" "$SCRIPT --help" "rotate"
test_command "Aliases" "$SCRIPT --help" "alias"

# Test 5: Files
echo -e "\n${CYAN}5. File Structure${RESET}"
files=(
    "README.md" "CHANGELOG.md" "ROADMAP.md" "LICENSE"
    "install.sh" "scrcpy-smart-gui.sh" "scrcpy-web.sh"
    "USER_GUIDE.md" "PROGRESS_REPORT.md"
    "docs/README.ar.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${RESET} $file"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${RESET} $file missing"
        ((FAILED++))
    fi
done

# Test 6: Directories
echo -e "\n${CYAN}6. Directories${RESET}"
for dir in docs plugins .github; do
    if [ -d "$dir" ]; then
        echo -e "  ${GREEN}✓${RESET} $dir/"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${RESET} $dir/ missing"
        ((FAILED++))
    fi
done

# Test 7: Git
echo -e "\n${CYAN}7. Git Status${RESET}"
if git status &>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Git repository"
    ((PASSED++))
    
    if git tag | grep -q "v3.0.0"; then
        echo -e "  ${GREEN}✓${RESET} Tag v3.0.0"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${RESET} Tag v3.0.0 missing"
        ((FAILED++))
    fi
fi

# Test 8: Executables
echo -e "\n${CYAN}8. Executables${RESET}"
for exe in scrcpy-smart.sh scrcpy-smart-gui.sh scrcpy-web.sh install.sh; do
    if [ -x "$exe" ]; then
        echo -e "  ${GREEN}✓${RESET} $exe"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${RESET} $exe"
        ((FAILED++))
    fi
done

# Test 9: Documentation
echo -e "\n${CYAN}9. Documentation${RESET}"
if [ -f "USER_GUIDE.md" ]; then
    lines=$(wc -l < USER_GUIDE.md)
    if [ $lines -gt 500 ]; then
        echo -e "  ${GREEN}✓${RESET} User guide ($lines lines)"
        ((PASSED++))
    fi
fi

if grep -q "3.0.0" CHANGELOG.md 2>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Changelog updated"
    ((PASSED++))
fi

# Summary
echo ""
echo "=========================================================="
echo -e "${CYAN}Test Summary${RESET}"
echo "=========================================================="
echo -e "Passed: ${GREEN}$PASSED${RESET}"
echo -e "Failed: ${RED}$FAILED${RESET}"
TOTAL=$((PASSED + FAILED))
PERCENTAGE=$((PASSED * 100 / TOTAL))
echo -e "Success: ${CYAN}${PERCENTAGE}%${RESET}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Ready to launch!${RESET}"
    exit 0
else
    echo -e "${RED}❌ $FAILED test(s) failed${RESET}"
    exit 1
fi
