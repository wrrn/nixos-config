{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  programs.hyprland = {
    enable = true; # enable Hyprland
    package = unstable.hyprland;
  };

  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];

  # Hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
