# A Makefile to build and install Z3 as an Ocaml library under Linux
# Mickaël Delahaye, 2011

LIB = /usr/local/lib
OCAMLWHERE = $(shell ocamlc -where)

OCAMLC = ocamlc
OCAMLOPT = ocamlopt

CC = gcc
CFLAGS = -I$(OCAMLWHERE) $(Z3_INCLUDE:%=-I%) -fPIC

Z3_BIN = ../bin
Z3_INCLUDE = ../include
Z3_LIB = ../lib

# META #########################################################################

NAME = z3
VERSION = $(shell $(Z3_BIN)/z3 -version | cut -d' ' -f3)
DESCRIPTION = Z3 SMT Solver

################################################################################

.PHONY: all distclean clean byte native \
install install-z3 install-z3-gmp doc \
META

################################################################################

all: byte native

native: $(NAME).cmxa

byte: $(NAME).cma

################################################################################

META:
	@echo 'version = "$(VERSION)"' > $@
	@echo 'description = "$(DESCRIPTION)"' >> $@
	@echo 'archive(byte) = "$(NAME).cma"' >> $@
	@echo 'archive(native) = "$(NAME).cmxa"' >> $@

# One object file for all source files & partial linking with camlidl
z3_stubs.o: z3_stubs.c z3_theory_stubs.c
	$(CC) $(CFLAGS) -L$(OCAMLWHERE) -lcamlidl -nostdlib -r $^ -fPIC -o $@


# Generic Ocaml building
.SUFFIXES: .mli .cmi .ml .cmo .cmx

.mli.cmi:
	$(OCAMLC) -c $<
.ml.cmo:
	$(OCAMLC) -c $<
.ml.cmx:
	$(OCAMLOPT) -c $<

# Dependencies
z3.cmx z3.cmo : z3.cmi

# Native OCaml library
$(NAME).cmxa: libz3stubs.a z3.cmx
	$(OCAMLOPT) -verbose -a -o $@ -cclib -lz3stubs -cclib -lz3 z3.cmx
# Static library for native compilation (still dependent to libz3.so)
libz3stubs.a: z3_stubs.o
	ar rcs libz3stubs.a $<; ranlib libz3stubs.a

# Dynamic library for byte compilation
dllz3stubs.so: z3_stubs.o
	$(CC) -shared $(Z3_INCLUDE:%=-I%) $(Z3_LIB:%=-L%) -lz3  $< \
-o dllz3stubs.so

# Byte OCaml library
$(NAME).cma: dllz3stubs.so z3.cmo
	$(OCAMLC) -a -o $@ -dllib -lz3stubs z3.cmo

################################################################################

install: z3.cma z3.cmxa z3.cmi libz3stubs.a dllz3stubs.so META
ifeq ($(shell which ocamlfind),)
	install -d $(OCAMLWHERE)/z3
	install -t $(OCAMLWHERE)/z3 z3.cma z3.cmxa z3.cmi z3.a libz3stubs.a META
	install -t $(OCAMLWHERE)/stublibs dllz3stubs.so
else
	ocamlfind install z3 META z3.cma z3.cmx z3.cmi z3.a libz3stubs.a \
-dll dllz3stubs.so
endif

uninstall:
ifeq ($(shell which ocamlfind),)
	$(RM) -r $(OCAMLWHERE)/z3 $(OCAMLWHERE)/stublibs/dllz3stubs.so
else
	ocamlfind remove z3
endif

install-z3:
	install -t $(LIB) $(Z3_LIB)/libz3.so
	ldconfig -n $(LIB)

install-z3-gmp:
	cp $(Z3_LIB)/libz3-gmp.so $(LIB)/libz3.so
	chmod a+rx,go-w $(LIB)/libz3.so
	ldconfig -n $(LIB)

################################################################################

doc:
	@mkdir -p doc
	ocamldoc z3.mli -html -d doc

################################################################################
distclean clean:
	$(RM) *.cmo *.cmi *.cmx *.cma *.cmxa *.o *.a *.so
