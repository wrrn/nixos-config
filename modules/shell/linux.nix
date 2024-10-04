{
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? services.openssh.enable) ({
    # SSH is already set up for darwin.
    services.openssh.enable = true;
  });
}
