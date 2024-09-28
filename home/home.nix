{
  username,
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
