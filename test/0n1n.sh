#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/0n1n.json"
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

echo "0n1n valid inputs _______________________________________________________"
test_success "01"
test_success "0011"
test_success "000111"
test_success "0000000011111111"

echo "0n1n invalid inputs _____________________________________________________"
test_failure "0"
test_failure "1"
test_failure "001"
test_failure "011"
test_failure "0001"
test_failure "0111"
test_failure "00000111"
test_failure "00000000011111111"

echo "$PASSED/$TOTAL tests passed"
