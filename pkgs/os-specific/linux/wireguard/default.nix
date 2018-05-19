{ stdenv, fetchzip, kernel }:

# module requires Linux >= 3.10 https://www.wireguard.io/install/#kernel-requirements
assert stdenv.lib.versionAtLeast kernel.version "3.10";

stdenv.mkDerivation rec {
  name = "wireguard-${version}";
  version = "0.0.20180514";

  src = fetchzip {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "15z0s1i8qyq1fpw8j6rky53ffrpp3f49zn1022jwdslk4g0ncaaj";
  };

  preConfigure = ''
    cd src
    sed -i '/depmod/,+1d' Makefile
  '';

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";

  NIX_CFLAGS = ["-Wno-error=cpp"];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = "make module";

  meta = with stdenv.lib; {
    homepage     = https://www.wireguard.com/;
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    description  = " Tools for the WireGuard secure network tunnel";
    maintainers  = with maintainers; [ ericsagnes mic92 zx2c4 ];
    license      = licenses.gpl2;
    platforms    = platforms.linux;
  };
}
