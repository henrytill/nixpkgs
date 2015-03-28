{ stdenv
, fetchgit
, autoconf
, automake
, perl
, perlPackages
, texi2html
, texinfo
, texLive
}:

stdenv.mkDerivation {
  name = "stow-git";

  src = fetchgit {
    url = git://git.sv.gnu.org/stow.git;
    rev = "99b669968db1197463dd86394eaf628e8fe9a7c9";
    sha256 = "1zmglxpq5yjyv5rvga9v6vpmlacjfq1hbp8xqmypc98c3hb59m9i";
  };

  buildInputs =
    [ autoconf
      automake
      perl
      perlPackages.TestMore
      perlPackages.TestOutput
      texi2html
      texinfo
      texLive
    ];

  preConfigure = ''
    aclocal
    autoconf
    automake --add-missing
  '';

  # dirty hack
  postConfigure = ''
    touch Changelog
  '';

  meta = with stdenv.lib; {
    description = "A tool for managing the installation of multiple software packages in the same run-time directory tree";
    longDescription = ''
      GNU Stow is a symlink farm manager which takes distinct packages
      of software and/or data located in separate directories on the
      filesystem, and makes them appear to be installed in the same
      place. For example, /usr/local/bin could contain symlinks to
      files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin
      etc., and likewise recursively for any other subdirectories such
      as .../share, .../man, and so on.
    '';
    homepage = http://www.gnu.org/software/stow/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ henrytill ];
    platforms = platforms.all;
  };
}
