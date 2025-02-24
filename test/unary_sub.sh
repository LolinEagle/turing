#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/unary_sub.json"
TOTAL=0
PASSED=0

test(){
	TOTAL=$((TOTAL + 1))
	local input=$1
	local expected=$(echo "$2" | sed 's/\./\\./g')
	local output=$($TURING $MACHINE $input 2>&1)

	output=$(echo "$output" | tail -n 1 | cut -c2-)
	if echo "$output" | grep -q ^$expected; then
		echo "✅ Passed ($input)"
		PASSED=$((PASSED + 1))
	else
		echo "❌ Failed ($input)"
	fi
}

echo "Unary sub _______________________________________________________________"
test "1-1=" ""
test "11-1=" "1"
test "1111-111=" "1"
echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
# [ $PASSED -eq $TOTAL ] || exit 1
