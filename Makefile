MACHINES = unary_sub unary_add palindrome 0n1n 02n

all:
	@dune build @install
	@dune install --prefix .
	@echo "Building done"

clean:
	@dune clean
	@rm -rf _build lib bin doc
	@echo "Cleaning done"

test_%:all
	@chmod +x test/$*.sh
	@cd test && ./$*.sh

test:$(foreach machine, $(MACHINES), test_$(machine))

re:clean all

.PHONY:all clean test re
