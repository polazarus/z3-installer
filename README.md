A Linux Makefile for Z3 OCaml binding
=====================================
Mickaël Delahaye, 2011

Microsoft Z3 is a powerful SMT solver. The authors of this tool let a Linux
version available to researchers, and it comes with its own Ocaml binding.
However, building and installing it is just too boring to do more than once.
Here is a Makefile that automates the task.

How to
------

Put the Makefile in z3/caml and run in this directory the following command:

	make # build the Ocaml library (native and byte)
	sudo make install # install the Ocaml library
	sudo make install-z3 # install Z3's DLL in /usr/local/lib

If you have any problem with GMP, you can replace the last line by:

	sudo make install-z3-gmp # install Z3's DLL with GMP statically linked

Note: this Makefile uses ocamlfind if it finds it, so it may install the Ocaml
library either in `ocamlc -where` or `ocamlfind printconf destdir`.

Requirements
------------

- Ocaml (shocking!)
- Camlidl

Acknowledgements
----------------
All the Z3 team for the solver and Jakob Lichtenberg for the Ocaml interface.

License
-------
Seriously...
