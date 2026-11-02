{
  config,
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  ghosttyApp = "${pkgs.unstable.ghostty-bin}/Applications/Ghostty.app";
  shell = lib.getExe config.users.users.${username}.shell;

  # The macOS counterpart of the desktop entries in ./linux.nix: a bundle
  # whose executable opens a new Ghostty instance running cmd.
  #
  # `open -n` is needed because a running Ghostty ignores --args. Apps
  # launched by `open` inherit launchd's bare PATH, so cmd runs in a login
  # shell to pick up `nix profile` binaries such as herdr.
  #
  # LSUIElement keeps the launcher out of the Dock; it exits as soon as
  # Ghostty starts.
  mkTuiApp =
    id:
    {
      name,
      icon,
      cmd ? id,
    }:
    let
      launcher = pkgs.writeShellScript "${id}-launcher" ''
        exec /usr/bin/open -na ${ghosttyApp} --args -e ${shell} -l -c ${lib.escapeShellArg cmd}
      '';
      infoPlist = pkgs.writeText "Info.plist" (
        lib.generators.toPlist { escape = true; } {
          CFBundleExecutable = id;
          CFBundleIconFile = id;
          CFBundleIdentifier = "org.wrrn.tui-apps.${id}";
          CFBundleName = name;
          CFBundleDisplayName = name;
          CFBundlePackageType = "APPL";
          LSUIElement = true;
        }
      );
    in
    pkgs.runCommand "${id}-app"
      {
        nativeBuildInputs = [
          pkgs.librsvg
          pkgs.libicns
        ];
      }
      ''
        app=$out/Applications/${lib.escapeShellArg name}.app/Contents
        mkdir -p $app/MacOS $app/Resources
        cp ${infoPlist} $app/Info.plist
        cp ${launcher} $app/MacOS/${id}

        for size in 16 32 128 256 512 1024; do
          rsvg-convert -w $size -h $size ${icon} -o icon_$size.png
        done
        png2icns $app/Resources/${id}.icns icon_*.png
      '';
in
{
  home-manager.users.${username}.home.packages = lib.mapAttrsToList mkTuiApp {
    herdr = {
      name = "herdr";
      icon = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/herdrdev/herdr/v0.9.5/assets/logo.svg";
        hash = "sha256-9KhADVFfz1ARKpUqW0j1+m5rArTcsLSDypK+OffX96E=";
      };
    };
  };
}
