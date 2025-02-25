#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/palindrome.json"
TOTAL=0
PASSED=0

test(){
	TOTAL=$((TOTAL + 1))
	local input=$1
	local expected=$2

	if $TURING $MACHINE $input 2>&1 | tail -n 1 | grep -q $expected; then
		echo "✅ Passed ($input)"
		PASSED=$((PASSED + 1))
	else
		echo "❌ Failed ($input)"
	fi
}

echo "Palindrome valid cases __________________________________________________"
test "10001" "y"
test "1001" "y"
test "11011" "y"
test "0" "y"
test "00" "y"
echo "Palindrome invalid cases ________________________________________________"
test "100" "n"
test "1010" "n"
test "110" "n"
test "01" "n"
test "10011" "n"
echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
# [ $PASSED -eq $TOTAL ] || exit 1
