{ inputs, ... }:
{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  programs.hyprland.enable = true;

  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.file.hypr = {
    source = "${inputs.dotfiles.hyper}/.config/hypr";
    target = ".config/hypr";
    recursive = true;
  };
}
