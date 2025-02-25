MACHINES = unary_sub unary_add palindrome 0n1n 02n

all:
	@dune build @install
	@dune install --prefix .
	@echo "Building done"

clean:
	@dune clean
	@rm -rf _build lib doc
	@echo "Cleaning done"

fclean:clean
	@rm -rf bin

re:clean all

test_%:all
	@chmod +x test/$*.sh
	@cd test && ./$*.sh

test:$(foreach machine, $(MACHINES), test_$(machine))

.PHONY:all clean fclean re test
