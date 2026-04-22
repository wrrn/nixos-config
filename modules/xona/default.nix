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

  security.pki.certificateFiles = [ ./dev_ca.crt ];

  networking.hosts = {
    "127.0.0.1" = [
      "csg.xona"
      "xcm.xona"
    ];

    "192.168.127.250" = [ "csg-vm.xona" ];
    "192.168.122.100" = [ "csg-vm-untrusted.xona" ];

    "192.168.127.251" = [ "xcm-vm.xona" ];
    "192.168.122.101" = [ "xcm-vm-untrusted.xona" ];

    "192.168.127.240" = [ "csg-vm-primary.xona" ];
    "192.168.127.241" = [ "csg-vm-replica.xona" ];

    "192.168.127.242" = [ "xcm-vm-primary.xona" ];
    "192.168.127.243" = [ "xcm-vm-replica.xona" ];
  };

  nix.settings = {
    netrc-file = "/etc/nix/netrc";
    extra-sandbox-paths = [ "/etc/nix/netrc" ];
  };
}
