#!/bin/bash

TURING="../_build/default/src/main.exe"
MACHINE="../machines/02n.json"
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

echo "02n valid inputs ________________________________________________________"
test_success "00"
test_success "0000"
test_success "00000000"

echo "02n invalid inputs ______________________________________________________"
test_failure "0"
test_failure "000"
test_failure "00000"
test_failure "000000"
test_failure "0000000"
test_failure "000000000"

echo "$PASSED/$TOTAL tests passed"
