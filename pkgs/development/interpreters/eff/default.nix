{ stdenv
, fetchFromGitHub
, findlib
, menhir
, ocaml
, which
}:

let

  inherit (stdenv.lib) getVersion versionAtLeast;

in

assert versionAtLeast (getVersion ocaml) "3.12";

stdenv.mkDerivation {

  name = "eff-dev";

  src = fetchFromGitHub {
    owner = "matijapretnar";
    repo = "eff";
    rev = "c34670390b28b3639282d3340876f91f8d9cc09f";
    sha256 = "1qmhh7k8rmnvcs57gbh72zqrsgyclcfpm82cblfszwapjb7d8ir9";
  };

  buildInputs =
    [ findlib
      menhir
      ocaml
      which
    ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = "http://www.eff-lang.org";
    description = "A functional programming language based on algebraic effects and their handlers";
    longDescription = ''
      Eff is a functional language with handlers of not only exceptions,
      but also of other computational effects such as state or I/O. With
      handlers, you can simply implement transactions, redirections,
      backtracking, multi-threading, and much more...
    '';
    license = licenses.bsd2;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ jirkamarsik henrytill ];
  };
}
