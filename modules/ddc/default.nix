{ pkgs, device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  # Enable I2C support for DDC/CI monitor control (brightness, input, etc.).
  # This loads the i2c-dev kernel module and creates an `i2c` group with
  # access to the /dev/i2c-* device nodes.
  hardware.i2c.enable = true;

  users.users.${username}.extraGroups = [ "i2c" ];

  environment.systemPackages = with pkgs; [ ddcutil ];
}
