{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) flaky-falcon;
in
{
  nixpkgs.overlays = [
    flaky-falcon.overlays.default
  ];
  services.falcon-sensor = {
    enable = true;
    cid = "D4ED41F6F18048D7A49C139A2FAC61AD-A2"; # Replace with your actual CrowdStrike Customer ID
  };

  home-manager.users.${username}.home.packages = with pkgs; [
    teams-for-linux
    slack
    openssl
    awscli2
    dig
  ];

  security.pki.certificateFiles = [ /home/warren/workshop/pericles/devenv/dev-ca/dev_ca.crt ];

  networking.hosts = {
    "127.0.0.1" = [
      "csg.xona"
      "xcm.xona"
    ];
  };
}
