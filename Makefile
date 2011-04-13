# Z3 Installer
# Mickaël Delahaye, 2011

BIN = /usr/local/bin
LIB = /usr/local/lib
INCLUDE = /usr/local/include

Z3_BIN = z3/bin
Z3_LIB = z3/lib
Z3_INCLUDE = z3/include

TARBALL=$(shell ls -t tarballs | grep 'gz$$' | head -1)

all: ocaml

z3/ocaml/Makefile: z3/
	@echo '-include ../../Makefile.ocaml' > $@

update:
	@echo [ZI] Update Z3 tarball
	@sh download.sh > .active

.active: tarballs/
	@if [ -f "$(TARBALL)" ]; then echo $(TARBALL) > .active; else $(MAKE) update; fi

z3/ : .active
	@$(RM) -r z3
	@echo [ZI] Unpack `cat .active`
	@tar xzf tarballs/`cat .active` z3
	@find z3 | xargs touch # fix mod time

ocaml: z3/ocaml/Makefile
	@echo [ZI] Build Z3 for Ocaml
	@$(MAKE) -C z3/ocaml

ocaml-install: lib-install
	@echo [ZI] Install Z3 for Ocaml
	@$(MAKE) -C z3/ocaml install

ocaml-uninstall:
	@echo [ZI] Uninstall Z3 for Ocaml
	@$(MAKE) -C z3/ocaml uninstall

lib-install:
	@echo [ZI] Install Z3 library
ifdef WITH_GMP
	@cp $(Z3_LIB)/libz3-gmp.so $(LIB)/libz3.so
	@chmod a+rx,go-w $(LIB)/libz3.so
else
	@install -t $(LIB) $(Z3_LIB)/libz3.so
endif
	@ldconfig -n $(LIB)
	@install -t $(INCLUDE) $(Z3_INCLUDE)/*.h

lib-uninstall:
	@echo [ZI] Uninstall Z3 library
	@$(RM) $(LIB)/libz3.so
	@$(RM) $(INCLUDE)/z3_*.h  $(INCLUDE)/z3.h

bin-install:
	@echo [ZI] Install Z3 binary
	@install -t $(BIN) $(Z3_BIN)/z3

bin-uninstall:
	@echo [ZI] Uninstall Z3 binary
	$(RM) $(BIN)/z3

ocaml-doc:
	@echo [ZI] Build the documentation of Z3 for Ocaml
	@$(MAKE) -C z3/ocaml doc
	@ln -s z3/ocaml/doc doc

install: lib-install ocaml-install bin-install
uninstall: lib-uninstall ocaml-uninstall bin-uninstall

clean:
	$(MAKE) -C z3/ocaml clean
distclean:
	$(MAKE) -C z3/ocaml distclean
	$(RM) doc
