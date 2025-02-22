all:
	dune build @install
	dune install --prefix .

clean:
	dune clean
	rm -rf _build lib bin doc

re: clean all

.PHONY: all clean test re