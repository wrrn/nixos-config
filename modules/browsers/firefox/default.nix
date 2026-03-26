{
  device-conf,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
  inherit (pkgs.nur.repos.rycee) firefox-addons;
  browser = import ../browser-policies.nix { inherit firefox-addons pkgs dotfiles; };
  platform = device-conf.platform.parsed.kernel.name;

  platformConfigs = {
    darwin = ./darwin.nix;
    linux = ./linux.nix;
  };

  platformConfig = import platformConfigs.${platform} {
    inherit username pkgs;
  };
in
{
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  imports = [
    platformConfig.module
  ];

  home-manager.users.${username} = {
    programs.firefox = {
      enable = true;
      inherit (browser) policies nativeMessagingHosts;

      profiles.dev-edition-default = {
        id = 0;
        isDefault = true;
        containersForce = true;
        containers = browser.containers;

        userChrome = ''
          @import "./theme/userChrome.css"
        '';

        extensions.packages = browser.extensions;
      };
    };

    home.file.firefox-theme = {
      source = dotfiles.firefox-theme;
      target = "${platformConfig.profilesPath}/dev-edition-default/chrome/theme";
      recursive = true;
    };

    home.file.dot-tridactyl = browser.tridactylDotfile;
  };
}
