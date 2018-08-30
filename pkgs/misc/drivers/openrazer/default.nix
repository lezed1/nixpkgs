{ stdenv
, fetchFromGitHub
, python3Packages
, makeWrapper
, linuxHeaders
, linuxPackages
, libelf
, gobjectIntrospection
}:

let
  common = import ./common.nix { inherit stdenv fetchFromGitHub; };
  kernel = linuxPackages.kernel;
in

stdenv.mkDerivation (common // rec {
  name = "openrazer-${common.version}-driver";

  buildInputs = [ linuxHeaders libelf python3Packages.python makeWrapper gobjectIntrospection ];
  propagatedBuildInputs = [ python3Packages.openrazer ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  MODULEDIR = "/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid";
  PREFIX = "";

  patches = [ ./razer_mount.patch ];

  configurePhase = ":";

  buildPhase = "make driver";

  installPhase = ''
    export DESTDIR=$out
    mkdir -p $out/${MODULEDIR}

    make driver_install_packaging
    make ubuntu_udev_install
    make -C daemon install-resources install-systemd manpages
  '';

  preFixup = ''
    mv $out/share/man $out

    substituteInPlace $out/lib/systemd/user/openrazer-daemon.service \
                      --replace /bin/openrazer-daemon "$out/bin/openrazer-daemon --config $out/share/openrazer/razer.conf.example"

    substituteInPlace $out/lib/udev/rules.d/99-razer.rules \
                      --replace razer_mount "$out/lib/udev/razer_mount" \
                      --replace add "add|change"

    wrapProgram "$out/bin/openrazer-daemon" \
                --prefix PYTHONPATH : "${with python3Packages; makePythonPath [ openrazer pygobject3 ]}" \
                --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  hardeningDisable = [ "pic" "format" ];
})
