_: {
  services.tailscale.enable = true;
}

# let
#   kernel = device-conf.platform.parsed.kernel.name;
#   module =
#     {
#       darwin = ./darwin.nix;
#       linux = ./linux.nix;
#     }
#     .${kernel} or { };
# in
# {
#   imports = [ module ];
# }
