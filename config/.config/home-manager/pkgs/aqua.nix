{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "aqua";
  src = pkgs.fetchurl {
    url = "https://github.com/aquaproj/aqua/releases/download/v2.56.5/aqua_darwin_arm64.tar.gz";
    sha256 = "fb25b9a72f42be06970bb7335803305b8299e454f61edc9125856a835c85239f";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -r aqua $out/bin
  '';

  meta = {
    description = "Declarative CLI Version manager written in Go. Support Lazy Install, Registry, and continuous update with Renovate. CLI version is switched seamlessly";
    homepage = "https://github.com/aquaproj/aqua";
    license = pkgs.lib.licenses.mit;
  };
}
