{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    package = pkgs.unstable.obs-studio;
    plugins = with pkgs.unstable.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vaapi # optional AMD hardware acceleration
      obs-composite-blur
      wrrnpkgs.obs-studio-plugins.droidcam-obs
      wrrnpkgs.obs-studio-plugins.obs-backgroundremoval
      wrrnpkgs.obs-studio-plugins.obs-live-backgroundremoval-lite
    ];
  };

  home-manager.users.${username} = {
    home.packages = [
      pkgs.ffmpeg # For converting screen recordings to screenshots
      pkgs.mpv # For reviewing screen-recordings
    ];
  };

  # xdg-desktop-portal is required for screen capture on Wayland
  # niri specifically recommends xdg-desktop-portal-gnome for screencasting
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # Provides ScreenCast portal for Niri
      xdg-desktop-portal-gtk # Provides other portals (file chooser, etc.)
    ];
    config.common.default = [
      "gnome"
      "gtk"
    ];
  };

  # Enable the usbmuxd so that iphones work.
  services.usbmuxd.enable = true;
  programs.droidcam.enable = true;
}
