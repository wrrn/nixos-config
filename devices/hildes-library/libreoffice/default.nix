# Seeds emma's LibreOffice profile with the writer-deck settings.
#
# LibreOffice rewrites registrymodifications.xcu constantly, so it can't be a
# store symlink. tmpfiles `C` copies each file only when it doesn't exist:
# a fresh install gets the settings, and her later changes are left alone.
# To re-seed, delete the file and run `systemd-tmpfiles --create`.
{ device-conf, ... }:
let
  inherit (device-conf) username;
  profile = "/home/${username}/.config/libreoffice/4/user";
in
{
  systemd.tmpfiles.rules = [
    "d /home/${username}/.config 0755 ${username} users -"
    "d /home/${username}/.config/libreoffice 0755 ${username} users -"
    "d /home/${username}/.config/libreoffice/4 0755 ${username} users -"
    "d ${profile} 0755 ${username} users -"
    "d ${profile}/config 0755 ${username} users -"
    "C ${profile}/registrymodifications.xcu 0644 ${username} users - ${./registrymodifications.xcu}"
    "C ${profile}/config/javasettings_Linux_X86_64.xml 0644 ${username} users - ${./javasettings_Linux_X86_64.xml}"
  ];
}
