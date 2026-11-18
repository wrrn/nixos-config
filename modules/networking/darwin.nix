{
  config,
  device-conf,
  ...
}:
let
  inherit (device-conf) hostname;
in
{
  networking = {
    computerName = hostname;
    localHostName = hostname;
  };
  wrrn.hosts.enable = true;

  # mDNSResponder ignores /etc/hosts when it's a symlink into /nix/store, so
  # build the file but don't link it; copy it into place as a real file instead.
  # postActivation runs after nix-darwin's /etc step.
  #
  # Rolling back to a generation from before this change aborts with
  # "Unexpected files in /etc". Run `sudo mv /etc/hosts /etc/hosts.before-nix-darwin` first.
  # Removing this module leaves the copied file behind; delete it by hand.
  environment.etc."hosts".enable = false;
  system.activationScripts.postActivation.text = ''
    printf >&2 'installing /etc/hosts...\n'
    install -m 0644 ${config.environment.etc."hosts".source} /etc/hosts.tmp
    mv -f /etc/hosts.tmp /etc/hosts
    dscacheutil -flushcache
    killall -HUP mDNSResponder || true
  '';
}
