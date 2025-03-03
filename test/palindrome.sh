#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/palindrome.json"
SUCCESS="y"
FAILURE="n"
TOTAL=0
PASSED=0

test() {
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

test_success() {
	test "$1" "$SUCCESS"
}

test_failure() {
	test "$1" "$FAILURE"
}

echo "Palindrome valid inputs _________________________________________________"
test_success "1001"
test_success "11011"
test_success "0"
test_success "00"

echo "Palindrome invalid inputs _______________________________________________"
test_failure "100"
test_failure "1010"
test_failure "110"
test_failure "01"

echo "$PASSED/$TOTAL tests passed"
