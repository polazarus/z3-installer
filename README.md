Z3 Installer
============
Mickaël Delahaye, 2012

[Microsoft Z3][1] is a powerful SMT solver. The authors of this tool let a Linux
version available to researchers, and it comes with its own Ocaml binding.
However, building and installing it is just too boring to do more than once.
Here is some files that automates the task.

UPDATE v0.3! Z3 is available with source at [Codeplex][2]. However, for now, the Ocaml binding is not available with Z3. For now, Z3 Installer uses the not so old version 4.1, which comes in binary form with the binding.

To the point
------------

First, get the installer either by downloading it from [Github][3]
or by cloning it :

	git clone git://github.com/polazarus/z3-installer.git

Then use it:

	cd z3-installer
	make # download Z3 AND build the Ocaml library (native and byte)
	sudo make install # install Z3 binary, DLL and the Ocaml library

Requirements
------------

- GCC, GNU Make
- Ocaml
- [Camlidl][4]
- Findlib (optionally)

More
----

If you have already downloaded Z3, please put the tarball in the `tarballs`
directory before running `make`. Beware of choosing a wrong build of Z3 for your
system. In doubt, let the installer choose for you.

### Targets

*   `update`, search a new version if available

*   `install`, `uninstall`
*   `bin-install`, `bin-uninstall` (just the Z3 binary)
*   `lib-install`, `lib-uninstall` (just the library and its headers)
*   `ocaml-install`, `ocaml-uninstall` (just the OCaml binding, the installation
    requires lib-install),

*   `clean` (remove build artifacts)
*   `distclean` (remove build artifacts and libraries)

### Makefile options

*   `WITH_GMP`

    If you have any problem with GMP, you can replace the last line by:

        sudo make install WITH_GMP=true # use Z3 DLL with GMP statically linked

    Seems to be not available in the 64 bit build.
    Warning! did not need it, did not test it...

*   `BIN`, library installation directory by default `/usr/local/bin`
*   `LIB`, library installation directory by default `/usr/local/lib`
*   `INCLUDE`, library installation directory by default `/usr/local/bin`

        sudo make install BIN=/opt/bin LIB=/opt/lib INCLUDE=/opt/include

### Ocaml library

This installer uses Findlib if it finds it, so it may install the Ocaml library
either in `ocamlc -where` or `ocamlfind printconf destdir`. With Findlib, you
can choose to force the destination directory using `OCAMLFIND_INSTALL_FLAGS`:

    sudo make install OCAMLFIND_INSTALL_FLAGS='-destdir `ocamlc -where`'
    # Install the Ocaml library in `ocamlc -where`

You can also deactivate the use of Findlib altogether:

    sudo make install OCAMLFIND=

To generate the Ocaml documentation, in `./doc`:

    make ocaml-doc

And yes, it is actually helpful! ;)

Contents
--------
*   `README.md`, this very file
*   `README`, a symlink to this very file
*   `Makefile`, the main Makefile
*   `Makefile.ocaml`, the Makefile for the Ocaml library
*   `download.sh`, a shell script (tested with bash and dash) that selects,
    downloads, extracts the suitable tarball from the Z3 project's website
*   `download-links.txt`, a list of links to the last binary version of Z3 for Linux and OS X

Acknowledgements
----------------
All the Z3 team for the solver and Jakob Lichtenberg for the Ocaml interface.

License
-------
Copyright (c) 2012, Mickaël Delahaye <http://micdel.fr>

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.

[1]: http://research.microsoft.com/en-us/um/redmond/projects/z3/
[2]: http://z3.codeplex.com/
[3]: https://github.com/polazarus/ocaml-z3-makefile/tarball/z3/tags
[4]: http://caml.inria.fr/pub/old_caml_site/camlidl/
