NAME		=	turing
SRC			=	src/turing.mli src/turing.ml src/main.ml
OCAMLC		=	ocamlfind ocamlc
OCAMLOPT	=	ocamlfind ocamlopt
OPAM		=	opam
OCAMLFLAGS	=	-I src
LIBS		=	yojson
PKGS		=	$(shell echo $(LIBS) | sed 's/ /, /g')

all:check-dependencies byte opt

clean:
	@echo "Cleaning up..."
	rm -f src/*.cmi src/*.cmo src/*.cmx src/*.o $(NAME)

re:clean
	@make

run:re
	./$(NAME) json/unary_sub.json "111-11="

check-dependencies:
	@echo "Checking dependencies..."
	$(OPAM) install $(LIBS) -y

byte:src/turing.cmi
	@echo "Building with ocamlc (bytecode)..."
	$(OCAMLC) -package $(PKGS) -linkpkg $(OCAMLFLAGS) $(SRC) -o $(NAME)

src/turing.cmi:src/turing.mli
	@echo "Compiling turing.mli to turing.cmi..."
	$(OCAMLC) -package $(PKGS) -linkpkg $(OCAMLFLAGS) -c src/turing.mli

opt:src/turing.cmi
	@echo "Building with ocamlopt (native code)..."
	$(OCAMLOPT) -package $(PKGS) -linkpkg $(OCAMLFLAGS) $(SRC) -o $(NAME)

.PHONY:all clean re run native byte opt check-dependencies
