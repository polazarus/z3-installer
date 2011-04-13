# Download, compile and install Z3 for Ocaml
# Mickaël Delahaye, 2011

BIN = /usr/local/bin
LIB = /usr/local/lib
INCLUDE = /usr/local/include

Z3_BIN = z3/bin
Z3_LIB = z3/lib
Z3_INCLUDE = z3/include

all: ocaml

z3/ocaml/Makefile: z3/
	@echo '-include ../../Makefile.ocaml' > $@

z3/ :
	sh download.sh

ocaml: z3/ocaml/Makefile
	$(MAKE) -C z3/ocaml

ocaml-install: lib-install
	$(MAKE) -C z3/ocaml install

ocaml-uninstall:
	$(MAKE) -C z3/ocaml uninstall

lib-install:
ifdef WITH_GMP
	cp $(Z3_LIB)/libz3-gmp.so $(LIB)/libz3.so
	chmod a+rx,go-w $(LIB)/libz3.so
	ldconfig -n $(LIB)
else
	install -t $(LIB) $(Z3_LIB)/libz3.so
	ldconfig -n $(LIB)
endif
	install -t $(INCLUDE) $(Z3_INCLUDE)/*.h

lib-uninstall:
	$(RM) $(LIB)/libz3.so
	$(RM) $(INCLUDE)/z3_*.h  $(INCLUDE)/z3.h

bin-install:
	install -t $(BIN) $(Z3_BIN)/z3

bin-uninstall:
	$(RM) $(BIN)/z3

ocaml-doc:
	$(MAKE) -C z3/ocaml doc
	@ln -s z3/ocaml/doc doc

install: lib-install  ocaml-install bin-install
uninstall: lib-uninstall ocaml-uninstall bin-uninstall

clean:
	$(MAKE) -C z3/ocaml clean
distclean: clean
	$(RM) -r z3/ z3*gz .links doc
