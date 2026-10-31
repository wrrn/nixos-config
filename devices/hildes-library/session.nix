# greetd autologins straight into cage running LibreOffice Writer.
# Phase 3 owns the rest: restart behaviour, `cage -d`, escape hatches, keys.
{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;

  # cage has no scale flag; the 3200x1800 panel needs 2x before Writer starts.
  # No --norestore: Writer's crash recovery is the only data protection.
  # Writer is restarted inside cage when it quits or crashes, so the session
  # (and its logind class) survives; the sleep stops a crash loop from spinning.
  # nixpkgs' LibreOffice ships no dictionaries; DICPATH points it at hunspell's.
  writer-session = pkgs.writeShellScript "writer-session" ''
    ${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --scale 2
    export DICPATH=${pkgs.hunspellDicts.en_US-large}/share/hunspell
    while true; do
      ${pkgs.libreoffice}/bin/soffice --writer --nologo
      sleep 1
    done
  '';

  session = {
    user = username;
    # -d: ask clients for server-side decorations, to drop the GTK title bar
    # (and its close button) Writer otherwise draws.
    command = "${pkgs.cage}/bin/cage -d -- ${writer-session}";
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      # Autologin on boot.
      initial_session = session;
      # Backstop if cage itself exits: greetd runs this whenever the session
      # ends, so the deck still comes back as her (as a greeter-class session).
      default_session = session;
    };
  };
}
