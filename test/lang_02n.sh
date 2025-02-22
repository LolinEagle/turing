#!/bin/bash

TURING="../_build/default/src/ft_turing.exe"
MACHINE="../machines/lang_02n.json"
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

echo "== 02n valid cases"
test "00" "y"
test "0000" "y"
test "00000" "y"
test "0000000" "y"
test "000000000" "y"

echo "== 02n invalid cases"
test "0" "n"
test "000" "n"
test "00000" "n"
test "0000000" "n"

echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
[ $PASSED -eq $TOTAL ] || exit 1

