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
    package = inputs.hyprland.default.override {
      #   debug = true;
      #   legacyRenderer = true;
    };
    extraConfig = ''
      source = ~/.config/hypr/conf/hyprland.conf
      debug:disable_logs=false
      debug:enable_stdout_logs=true
    '';
    plugins = [ inputs.hyprscroller.default ];
  };
  # Hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  gtk.enable = true;

  home.file.hypr = {
    source = "${inputs.dotfiles.hypr}/.config/hypr/";
    target = ".config/hypr/conf";
    recursive = true;
  };

  home.packages = with pkgs; [
    wofi
    dunst
  ];

}
