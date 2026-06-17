_:
let
  hostnames = {
    xcm = "xcm.xona";
    csg = "csg.xona";
    xcmVm = "vm.xcm.xona";
    csgVm = "vm.csg.xona";
  };

  backendHostnames = {
    xcmVm = "xcm-vm.xona";
    csgVm = "csg-vm.xona";
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

    virtualHosts.${hostnames.xcmVm}.extraConfig = ''
      tls internal
      reverse_proxy https://${backendHostnames.xcmVm} {
        transport http {
          tls_server_name ${backendHostnames.xcmVm}
        }
      }
    '';

    virtualHosts.${hostnames.csgVm}.extraConfig = ''
      tls internal
      reverse_proxy https://${backendHostnames.csgVm} {
        transport http {
          tls_server_name ${backendHostnames.csgVm}
        }
      }
    '';
  };

  networking.hosts = {
    "127.0.0.1" = builtins.attrValues hostnames;

    "192.168.127.250" = [ backendHostnames.csgVm ];
    "192.168.122.100" = [
      "csg-vm-untrusted.xona"
      "untrusted.vm.csg.xona"
    ];

    "192.168.127.251" = [ backendHostnames.xcmVm ];
    "192.168.122.101" = [
      "xcm-vm-untrusted.xona"
      "untrusted.vm.xcm.xona"
    ];

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
