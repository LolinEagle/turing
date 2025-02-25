#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/02n.json"
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

echo "02n valid cases _________________________________________________________"
test "00" "y"
test "0000" "y"
test "00000000" "y"
echo "02n invalid cases _______________________________________________________"
test "0" "n"
test "000" "n"
test "00000" "n"
test "000000" "n"
test "0000000" "n"
test "000000000" "n"

echo "$PASSED/$TOTAL tests passed"

# Exit with status 1 if any test failed
# [ $PASSED -eq $TOTAL ] || exit 1
