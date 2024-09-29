{
  pkgs,
  inputs,
  unstable,
  ...
}:
{

  programs.hyprland = {
    enable = true; # enable Hyprland
    package = inputs.hyprland.default.override {
      # debug = true;
      # legacyRenderer = true;
    };
  };

  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.waylandpp
    pkgs.kdePackages.qtwayland
    hyprland.xdg-desktop-portal-hyprland
  ];

  qt.enable = true;

  # services.seatd.enable = true;
  # Hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
