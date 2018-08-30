{ stdenv
, fetchFromGitHub
, python3Packages
, gobjectIntrospection
, gnome3
}:

let
  common = import ./common.nix { inherit stdenv fetchFromGitHub; };
  openrazer-daemon = python3Packages.buildPythonPackage (common // rec {
    pname = "openrazer-${common.version}-pydaemon";

    src = "${common.src}/daemon";

    propagatedBuildInputs = with python3Packages; [
      dbus-python
      pygobject3
      gobjectIntrospection
      gnome3.gtk
      setproctitle
      pyudev
      daemonize
    ];
  });
in

python3Packages.buildPythonPackage (common // rec {
  pname = "openrazer-${common.version}-pylib";

  src = "${common.src}/pylib";

  propagatedBuildInputs = with python3Packages; [
    numpy
    openrazer-daemon
  ];
})
