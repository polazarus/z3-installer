Z3 Installer
============
Mickaël Delahaye, 2011

Microsoft Z3 is a powerful SMT solver. The authors of this tool let a Linux
version available to researchers, and it comes with its own Ocaml binding.
However, building and installing it is just too boring to do more than once.
Here is somes files that automates the task.

To the point
------

First, get the installer either by downloading it from [Github][1]
or by cloning it :
	git clone --depth 0 git://github.com/polazarus/z3-installer.git

Then use it:

	cd z3-installer
	make # download Z3 and build the Ocaml library (native and byte)
	sudo make install # install Z3 binary, DLL and the Ocaml library

Requirements
------------

- Ocaml (shocking!)
- Camlidl

More
----

If you have already downloaded Z3 beforehand, please extract the tar in the
directory you put this tool before calling `make`.

### Targets

* `install`, `uninstall`
* `bin-install`, `bin-uninstall` (just the Z3 binary)
* `lib-install`, `lib-uninstall` (just the library and its headers)
* `ocaml-install`, `ocaml-uninstall` (just the OCaml binding, the installation requires lib-install),

* `clean` (remove build artifacts)
* `distclean` (clean + remove libraries and downloaded files)

### Makefile options

*   `WITH_GMP`

    If you have any problem with GMP, you can replace the last line by:

        sudo make install WITH_GMP=true # use Z3 DLL with GMP statically linked

    Not available in the 64 bit build

* `BIN`, library installation directory by default `/usr/local/bin`
* `LIB`, library installation directory by default `/usr/local/lib`
* `INCLUDE`, library installation directory by default `/usr/local/bin`

        sudo make install BIN=/opt/bin LIB=/opt/lib INCLUDE=/opt/include

### Ocaml library

This installer uses ocamlfind if it finds it, so it may install the Ocaml
library either in `ocamlc -where` or `ocamlfind printconf destdir`.
With ocamlfind, you can choose to force the destination directory using
`OCAMLFIND_INSTALL_FLAGS`:

    sudo make install OCAMLFIND_INSTALL_FLAGS='-destdir `ocamlc -where`'
    # Install the Ocaml library in `ocamlc -where`

You can also deactivate ocamlfind altogether:

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

Acknowledgements
----------------
All the Z3 team for the solver and Jakob Lichtenberg for the Ocaml interface.

License
-------
Copyright (c) 2011, Mickaël Delahaye

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


[1]: https://github.com/polazarus/ocaml-z3-makefile/tarball/master
