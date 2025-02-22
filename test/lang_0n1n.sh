#!/bin/bash

TURING="../_build/default/src/ft_turing.exe"
MACHINE="../machines/lang_0n1n.json"
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

echo "== 0n1n valid cases"
test "01" "y"
test "0011" "y"
test "000111" "y"
test "0000000011111111" "y"

echo "== 0n1n invalid cases"
test "0" "n"
test "1" "n"
test "001" "n"
test "011" "n"
test "0001" "n"
test "0111" "n"
test "00000111" "n"
test "00000000011111111" "n"

echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
[ $PASSED -eq $TOTAL ] || exit 1
