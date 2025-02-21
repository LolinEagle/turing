NAME		=	turing
SRC			=	src/validate.mli src/validate.ml \
				src/turing.mli src/turing.ml \
				src/main.ml
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
	clear
ifndef INPUT
	@echo "usage: make run INPUT=<input>"
	@echo "Valid input: unary_sub, unary_add, palindrome, lang_0n1n, lang_02n"
else
	@if [ "$(INPUT)" = "unary_sub" ]; then \
		./$(NAME) json/unary_sub.json "111-11="; \
	elif [ "$(INPUT)" = "unary_add" ]; then \
		./$(NAME) json/unary_add.json "111+11"; \
	elif [ "$(INPUT)" = "palindrome" ]; then \
		./$(NAME) json/palindrome.json "101."; \
	elif [ "$(INPUT)" = "lang_0n1n" ]; then \
		./$(NAME) json/lang_0n1n.json "000111"; \
	elif [ "$(INPUT)" = "lang_02n" ]; then \
		./$(NAME) json/lang_02n.json "0000"; \
	else \
		echo "Invalid input"; \
	fi
endif

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
