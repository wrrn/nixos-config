{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  imports = [
    ./virtualisation.nix
    ./complianceware.nix
    ./ai.nix
  ];

  home-manager.users.${username}.home.packages = with pkgs; [
    teams-for-linux
    slack
    openssl
    awscli2
    dig # Used for spinning up vms in the cloud
    remmina # Use this as an RDP client for accessing UI over the network.
    typescript-language-server
  ];

  security.pki.certificateFiles = [ /home/warren/workshop/pericles/devenv/dev-ca/dev_ca.crt ];

  networking.hosts = {
    "127.0.0.1" = [
      "csg.xona"
      "xcm.xona"
    ];
  };
}
