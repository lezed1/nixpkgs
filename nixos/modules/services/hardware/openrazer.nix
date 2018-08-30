{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.openrazer;
  openrazer = cfg.package;
in {
  options = {
    hardware.openrazer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add OpenRazer to the global environment (kernel module,
          udev rules, Python library and daemon) and add the 'plugdev' group.
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.openrazer;
        defaultText = "pkgs.openrazer";
        description = ''
          Which OpenRazer package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ openrazer ];
    boot.extraModulePackages = [ openrazer ];
    udev.packages = [ openrazer ];
    systemd.packages = [ openrazer ];
    services.dbus.packages = [ openrazer ];
    users.extraGroups.plugdev = {};
  };
}
