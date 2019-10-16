{ pkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/94500c93dc239761bd144128a1684abcd08df6b7.tar.gz") {}
}:

with pkgs;

stdenv.mkDerivation rec {
  name = "latex-environment";

  buildInputs = [
    #git
    #evince
    gnumake
    #pandoc
    #python35Packages.pygments
    #pdf2htmlEX
    (texlive.combine {
      inherit (texlive) scheme-medium collection-xetex;
      inherit (texlive) moderncv tipa fontawesome;
      inherit (texlive) xpatch;
      pkgFilter = pkg: lib.any (x: x) [
        (pkg.tlType == "run")
        (pkg.tlType == "bin")
        #(pkg.pname == "fontawesome")
      ];
    })
  ];

  src = ./.;

  buildPhase = "make";

  meta = with lib; {
    description = "chessai's resume";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };

  shellHook = ''
    function watch() {
      make watch
    }
  '';
}
