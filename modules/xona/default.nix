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
    ./communication.nix
    ./ai.nix
    ./devnetworking.nix
  ];

  home-manager.users.${username}.home.packages = with pkgs; [
    openssl # Used for generating certs
    awscli2
    dig # Used for spinning up vms in the cloud
    remmina # Use this as an RDP client for accessing UI over the network.
    typescript-language-server
    sshpass # For spinning up local vms
    libossp_uuid # For spinning up local vms
    xmlstarlet # For spinning up local vms
    net-tools # For spinning up local vms
    libxml2 # For spinning up local vms
  ];

  nix.settings = {
    netrc-file = "/etc/nix/netrc";
    extra-sandbox-paths = [ "/etc/nix/netrc" ];
  };
}
