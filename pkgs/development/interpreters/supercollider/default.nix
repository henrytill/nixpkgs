{ stdenv, fetchurl, cmake, pkgconfig
, fftw, libjack2, libsndfile, libXt, readline
, qtbase, qttools, qtwebkit, qtmacextras
, Quartz, QuartzCore, ImageCaptureCore
, Cocoa, CoreServices, Foundation
, emacsSupport ? true, emacs
, vimSupport ? true,
}:

let

  optional = stdenv.lib.optional;

  ccVersion = (builtins.parseDrvName stdenv.cc.name).version;

in stdenv.mkDerivation rec {
  name = "supercollider-${version}";
  version = "3.9.2";
  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "0m3kjlfg3bs9fdlq5kkfg6rqjhcwsb7sxdrcmyx7101xajk86xbc";
  };

  hardeningDisable = [ "stackprotector" ];

  patchPhase = ''
    substituteInPlace editors/sc-ide/CMakeLists.txt \
      --replace "include(InstallRequiredSystemLibraries)" ""
  '';

  cmakeFlags =
    [ "-DSC_WII=OFF"
      "-DSC_EL=${if emacsSupport then "ON" else "OFF"}"
      "-DSC_VIM=${if vimSupport then "ON" else "OFF"}"
    ] ++ optional stdenv.isDarwin
    [ "-DCMAKE_C_COMPILER_ID=AppleClang"
      "-DCMAKE_C_COMPILER_VERSION=${ccVersion}"
      "-DCMAKE_C_STANDARD_COMPUTED_DEFAULT=11"
      "-DCMAKE_CXX_COMPILER_ID=AppleClang"
      "-DCMAKE_CXX_COMPILER_VERSION=${ccVersion}"
      "-DCMAKE_CXX_STANDARD_COMPUTED_DEFAULT=98"
      "-DCMAKE_PREFIX_PATH=${qtmacextras.dev}/lib/cmake"
    ];

  nativeBuildInputs =
    [ cmake pkgconfig qttools ]
    ++ optional emacsSupport emacs;

  buildInputs =
    [ fftw libjack2 libsndfile libXt qtbase qtwebkit readline ]
    ++ optional stdenv.isDarwin [ qtmacextras ];

  propagatedBuildInputs =
    []
    ++ optional stdenv.isDarwin [ Quartz QuartzCore ImageCaptureCore Cocoa CoreServices Foundation ];

  meta = with stdenv.lib; {
    description = "Programming language for real time audio synthesis";
    homepage = http://supercollider.sourceforge.net/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
