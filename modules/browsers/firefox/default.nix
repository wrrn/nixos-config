{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
  inherit (pkgs.nur.repos.rycee) firefox-addons;
  browser = import ../policies.nix { inherit firefox-addons pkgs dotfiles; };

  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  imports = [ module ];

  home-manager.users.${username} =
    { config, lib, ... }:
    let
      # Bookmarks are exported here on every exit, so they're readable,
      # importable anywhere, and versioned in their own jj repo.
      stacks = "${config.home.homeDirectory}/burrow/stacks";
    in
    {
      programs.firefox = {
        enable = true;
        inherit (browser) policies nativeMessagingHosts;

        profiles.default = {
          id = 0;
          isDefault = true;
          containersForce = true;
          inherit (browser) containers;
          extensions.packages = browser.extensions;

          # Machine-specific (absolute path), so these live here rather than in
          # user-overrides.js.
          settings = {
            "browser.bookmarks.autoExportHTML" = true;
            "browser.bookmarks.file" = "${stacks}/bookmarks.html";
          };

          # Betterfox is the base user.js; personal overrides must come after it.
          extraConfig = lib.concatStringsSep "\n" [
            (builtins.readFile "${inputs.betterfox}/user.js")
            (builtins.readFile "${dotfiles.firefox}/user-overrides.js")
          ];

          userChrome = builtins.readFile "${dotfiles.firefox}/userChrome.css";
        };
      };

      home.file.dot-tridactyl = browser.tridactylDotfile;

      # Firefox won't create the export directory itself.
      home.activation.bookmarkStacks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${lib.escapeShellArg stacks}
      '';
    };
}
