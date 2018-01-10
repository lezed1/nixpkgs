{ stdenv, fetchFromGitHub, qt5 }:

stdenv.mkDerivation rec {
  name = "lightscreen-${version}";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "ckaiser";
    repo = "Lightscreen";
    rev = "v${version}";
    sha256 = "148al9swbwa5m4lvbppl5n32pbhf7ix6d6jkz29wpf5lx8a8q9mq";
    fetchSubmodules = true;
  };

  patches = [ ./0001-Fix-conflicting-symbols-in-linux-build.patch ];

  buildInputs = with qt5; [ qmake qtmultimedia qtx11extras qttools ];

  installPhase = "mkdir -p $out/bin && cp lightscreen $out/bin";

  meta = with stdenv.lib; {
    homepage = http://lightscreen.com.ar/;
    description = "A simple tool to automate the tedious process of saving and cataloging screenshots";
    platforms = platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ lezed1 ];
  };
}
