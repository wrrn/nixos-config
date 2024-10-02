{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.where-is-my-sddm-theme.override ({
      themeConfig = (import ./sddm.theme.nix { }).style;
      variants = [ "qt5" ];
    }))
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };
}
