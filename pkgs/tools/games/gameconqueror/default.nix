{ lib
, autoconf
, automake
, fetchFromGitHub
, glib
, gobject-introspection
, gtk3
, intltool
, libtool
, python3
, python310Packages
, readline
, stdenv
, wrapGAppsHook
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
    wrapGAppsHook
    ];

  buildInputs = [
    readline
    gtk3
    gobject-introspection
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
  ];

  propagatedBuildInputs = with python310Packages; [
    pygobject3
    wrapGAppsHook
  ];

  strictDeps = false; # broken with gobject-introspection setup hook https://github.com/NixOS/nixpkgs/issues/56943
  dontWrapGApps = true; # prevent double wrapping

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = ["--enable-gui"];

  meta = with lib; {
    homepage = "https://github.com/scanmem/scanmem/tree/master/gui";
    description = "Graphical game cheating tool under Linux, a frontend for scanmem.";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
