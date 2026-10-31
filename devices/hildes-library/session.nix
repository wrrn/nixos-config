# greetd autologins straight into cage running LibreOffice Writer.
# Phase 3 owns the rest: restart behaviour, `cage -d`, escape hatches, keys.
{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;

  # cage has no scale flag; the 3200x1800 panel needs 2x before Writer starts.
  # No --norestore: Writer's crash recovery is the only data protection.
  writer-session = pkgs.writeShellScript "writer-session" ''
    ${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --scale 2
    exec ${pkgs.libreoffice}/bin/soffice --writer --nologo
  '';

  session = {
    user = username;
    command = "${pkgs.cage}/bin/cage -- ${writer-session}";
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      # Autologin on boot.
      initial_session = session;
      # greetd runs this whenever the session exits, so a Writer quit or crash
      # comes straight back as her.
      default_session = session;
    };
  };
}
