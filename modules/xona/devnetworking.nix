{ lib, ... }:
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

  reverseProxy =
    {
      aliases ? [ ],
      upstream,
      extraConfig ? "",
    }:
    {
      inherit aliases upstream extraConfig;
    };

  # i need to reason about this. I want to be able to indicate the upstream and the
  # frontend. Right now I'm specifying the ip, could I just do that for now. Essentially for each ip and a host entry in caddy AND and entry in /etc/hosts. /etc/hosts points the request at caddy, caddy then looks then forwards it to the host. I think we want a separate port variable. I can't have separate port because the keys would differ. It might be worth stripping out the port from the key. I don't like that because it's non-obvious. What is another obvious way? Can I use objects as keys. Or should a hostname point at multiple ports. Then I pollute the whole thing, but it would allow me to create a separate thing.
  hosts = {
    "xcm.xona" = reverseProxy {
      upstream = "https://localhost:8443";
      extraConfig = "transport http { tls_insecure_skip_verify }";
    };

    "csg.xona" = reverseProxy {
      upstream = "https://localhost:7443";
      extraConfig = "transport http { tls_insecure_skip_verify }";
    };

    "csg.vm.xona" = reverseProxy { upstream = "https://192.168.127.250"; };

    "untrusted.csg.vm.xona" = reverseProxy {
      # TODO aliases don't currently get added to /etc/hosts
      aliases = [ "csg-vm-untrusted.xona" ];
      upstream = "https://192.168.122.100";
    };

    "xcm.vm.xona" = reverseProxy { upstream = "https://192.168.127.251"; };
    "untrusted.xcm.vm.xona" = reverseProxy { upstream = "https://192.168.122.101"; };
    "replica.csg.vm.xona" = reverseProxy { upstream = "https://192.168.127.240"; };
    "replica.xcm.vm.xona" = reverseProxy { upstream = "https://192.168.127.241"; };
  };

  caddyEntry = hostname: reverseProxy: {
    extraConfig = ''
      tls internal
      reverse_proxy ${reverseProxy.upstream} {
        header_up Host {host}
        ${reverseProxy.extraConfig}
      }
    '';
  };

  reverseProxys = lib.mapAttrs' (
    hostname: reverseProxy: lib.nameValuePair hostname (caddyEntry hostname reverseProxy)
  ) hosts;
in
{
  # Reverse proxy container ports so that we don't have to remember the ports
  services.caddy = {
    enable = true;
    virtualHosts = reverseProxys;
  };

  networking.hosts = {
    "127.0.0.1" = builtins.attrNames hosts;
  };

  security.pki.certificateFiles = [
    ./dev_ca.crt
    ./caddy-root.crt
  ];
}
