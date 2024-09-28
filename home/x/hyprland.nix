{
  inputs,
  pkgs,
  unstable,
  ...
}:
{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland
    package = unstable.hyprland;
    extraConfig = ''
      source = ~/.config/hypr/conf/hyprland.conf
    '';
    plugins = [ unstable.hyprlandPlugins.hyprscroller ];
  };
  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.file.hypr = {
    source = "${inputs.dotfiles.hypr}/.config/hypr/";
    target = ".config/hypr/conf";
    recursive = true;
  };

  home.packages = with pkgs; [
    wofi
    dunst
    xdg-desktop-portal-hyprland
  ];

}
