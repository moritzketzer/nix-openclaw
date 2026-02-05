{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "openclaw-app";
  version = "2026.2.3";

  src = fetchzip {
    url = "https://github.com/openclaw/openclaw/releases/download/v2026.2.3/OpenClaw-2026.2.3.zip";
    hash = "sha256-yFHYNwNGrffpkNaOL3eXc+THwszuayTjWIbXe2BTq0s=";
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = "${../scripts/openclaw-app-install.sh}";

  meta = with lib; {
    description = "OpenClaw macOS app bundle";
    homepage = "https://github.com/openclaw/openclaw";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
