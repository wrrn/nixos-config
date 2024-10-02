{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    curl
    httpie
    ripgrep
    gnumake
    zoxide
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

}
