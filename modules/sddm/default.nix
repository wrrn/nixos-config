{ pkgs, ... }:
# let
#   customTheme = pkgs.where-is-my-sddm-theme.override {
#     themeConfig = import ./sddm.theme.nix { };
#     variants = [ "qt5" ];
#   };
# in
# {
#   environment.systemPackages = [ customTheme ];

#   services.displayManager.sddm = {
#     enable = true;
#     wayland.enable = true;
#     theme = "${customTheme}/share/sddm/where_is_my_ssdm_theme_qt5";
#     extraPackages = [ customTheme ];
#   };
# }
{
  services.displayManager.ly = {
    enable = true;
  };
}
