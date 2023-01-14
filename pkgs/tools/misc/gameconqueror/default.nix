{ lib
, stdenv
, autoconf
, automake
, intltool
, libtool
, fetchFromGitHub
, readline
, gobject-introspection
, python3Packages
, gtk3
, glib
}:

stdenv.mkDerivation rec {
  version = "0.17";
  pname = "gameconqueror";

  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "17p8sh0rj8yqz36ria5bp48c8523zzw3y9g8sbm2jwq7sc27i7s9";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    gobject-introspection
    ];

  buildInputs = [
    readline
    gtk3
    glib
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  strictDeps = false; # gobject-introspection does not run with strictDeps (https://github.com/NixOS/nixpkgs/issues/56943)

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = ["--enable-gui"];

  meta = with lib; {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Graphical game cheating tool under Linux, a frontend for scanmem.";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
