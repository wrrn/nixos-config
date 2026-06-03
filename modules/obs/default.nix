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

  # Enable the usbmuxd so that iphones work.
  services.usbmuxd.enable = true;
  programs.droidcam.enable = true;
}
