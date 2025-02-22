MACHINES = unary_sub unary_add palindrome lang_0n1n lang_02n

all:
	dune build @install
	dune install --prefix .

clean:
	dune clean
	rm -rf _build lib bin doc

test_%: all
	@chmod +x test/$*.sh
	@cd test && ./$*.sh

test: $(foreach machine, $(MACHINES), test_$(machine))

re: clean all

.PHONY: all clean test re