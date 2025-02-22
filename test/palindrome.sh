#!/bin/bash

TURING="../_build/default/src/ft_turing.exe"
MACHINE="../machines/palindrome.json"
TOTAL=0
PASSED=0

test() {
    TOTAL=$((TOTAL + 1))
    local input=$1
    local expected=$2

    if $TURING $MACHINE $input 2>&1 | tail -n 1 | grep -q $expected; then
        echo "$input ✅ Passed"
        PASSED=$((PASSED + 1))
    else
        echo "$input ❌ Failed"
    fi
}

echo "== Palindrome valid cases"
test "10011" "y"
test "1001" "y"
test "11011" "y"
test "0" "y"
test "00" "y"

echo "== Palindrome invalid cases"
test "100" "n"
test "1010" "n"
test "110" "n"
test "01" "n"

echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
[ $PASSED -eq $TOTAL ] || exit 1
