{ stdenv, fetchurl, libev, ocaml, findlib, ocaml_lwt, ocaml_react, zed, camlp4 }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  version = "1.9";
  name = "lambda-term-${version}";

  src = fetchurl {
    url = https://github.com/diml/lambda-term/archive/1.9.tar.gz;
    sha256 = "01pmacp6b92n6dy23zwb1mh38vnv1z2v9z23hg0fb65arx0xj6yj";
  };

  buildInputs = [ libev ocaml findlib ocaml_react ];

  propagatedBuildInputs = [ camlp4 zed ocaml_lwt ];

  createFindlibDestdir = true;

  meta = { description = "Terminal manipulation library for OCaml";
    longDescription = ''
    Lambda-term is a cross-platform library for
    manipulating the terminal. It provides an abstraction for keys,
    mouse events, colors, as well as a set of widgets to write
    curses-like applications.

    The main objective of lambda-term is to provide a higher level
    functional interface to terminal manipulation than, for example,
    ncurses, by providing a native OCaml interface instead of bindings to
    a C library.

    Lambda-term integrates with zed to provide text edition facilities in
    console applications.
    '';

    homepage = https://github.com/diml/lambda-term;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
