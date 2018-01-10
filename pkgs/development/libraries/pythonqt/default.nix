{ stdenv, fetchurl, qt5, unzip, python3 }:

stdenv.mkDerivation rec {
  name = "pythonqt-${version}";
  version = "3.2";

  src = fetchurl {
    url = "mirror://sourceforge/pythonqt/pythonqt/PythonQt-${version}/PythonQt${version}.zip";
    sha256 = "13hzprk58m3yj39sj0xn6acg8796lll1256mpd81kw0z3yykyl8c";
  };

  buildInputs = with qt5; [
    qmake qtbase qtsvg qtxmlpatterns qtmultimedia qttools
    unzip python3
  ];

  NIX_CFLAGS_COMPILE = "-I ${python3}/include/${python3.libPrefix}";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://pythonqt.sourceforge.net/index.html;
    description = "A dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ lezed1 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
