_:
let
  hostnames = {
    xcm = "xcm.xona";
    csg = "csg.xona";
  };
in
{
  # Reverse proxy container ports so that we don't have to remember the ports
  services.caddy = {
    enable = true;
    virtualHosts.${hostnames.xcm}.extraConfig = ''
      tls internal
      reverse_proxy https://localhost:8443 {
        transport http { tls_insecure_skip_verify }
      }
    '';

    virtualHosts.${hostnames.csg}.extraConfig = ''
      tls internal
      reverse_proxy https://localhost:7443 {
        transport http { tls_insecure_skip_verify }
      }
    '';
  };

  networking.hosts = {
    "127.0.0.1" = builtins.attrValues hostnames;

    "192.168.127.250" = [ "csg-vm.xona" ];
    "192.168.122.100" = [ "csg-vm-untrusted.xona" ];

    "192.168.127.251" = [ "xcm-vm.xona" ];
    "192.168.122.101" = [ "xcm-vm-untrusted.xona" ];

    "192.168.127.240" = [ "csg-vm-primary.xona" ];
    "192.168.127.241" = [ "csg-vm-replica.xona" ];

    "192.168.127.242" = [ "xcm-vm-primary.xona" ];
    "192.168.127.243" = [ "xcm-vm-replica.xona" ];
  };

  security.pki.certificateFiles = [
    ./dev_ca.crt
    ./caddy-root.crt
  ];
}
