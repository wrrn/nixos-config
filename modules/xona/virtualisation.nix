{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;

  periclesNetXml = pkgs.writeText "pericles-network.xml" ''
    <network>
      <name>pericles</name>
      <forward mode='nat'>
        <nat>
          <port start='1024' end='65535'/>
        </nat>
      </forward>
      <bridge name='perbr0' stp='on' delay='0'/>
      <mac address='52:54:00:71:3b:10'/>
      <ip address='192.168.127.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.127.105' end='192.168.127.200'/>
        </dhcp>
      </ip>
    </network>
  '';

  pxenetNetXml = pkgs.writeText "pxenet-network.xml" ''
    <network>
      <name>pxenet</name>
      <bridge name='pxebr0' stp='on' delay='0'/>
      <mac address='52:54:00:71:3b:11'/>
      <ip address='192.168.2.1' netmask='255.255.255.0'>
      </ip>
    </network>
  '';
in
{
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    sshpass
  ];

  users.users.${username}.extraGroups = [ "libvirtd" ];

  virtualisation.libvirtd = {
    enable = true;
    nss.enableGuest = true;
    allowedBridges = [
      "virbr0"
      "perbr0"
      "pxebr0"
    ];
  };

  systemd.services.libvirt-custom-networks = {
    description = "Define custom libvirt networks and storage pool";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.libvirt
      pkgs.libxml2
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for net_xml in ${periclesNetXml} ${pxenetNetXml}; do
        name=$(xmllint --xpath 'string(/network/name)' "$net_xml")
        if ! virsh net-info "$name" &>/dev/null; then
          virsh net-define "$net_xml"
        fi
        virsh net-autostart "$name"
        virsh net-start "$name" 2>/dev/null || true
      done

      if ! virsh pool-info default &>/dev/null; then
        virsh pool-define-as default dir --target /var/lib/libvirt/images
        virsh pool-build default
      fi
      virsh pool-autostart default
      virsh pool-start default 2>/dev/null || true
    '';
  };

  networking.firewall.interfaces =
    let
      rules = {
        allowedTCPPorts = [
          21
          80
          443
          9191
        ];
        allowedUDPPorts = [ 69 ];
      };
    in
    {
      "virbr0" = rules;
      "perbr0" = rules;
      "pxebr0" = rules;
    };
}
