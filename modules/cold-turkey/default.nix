{
  device-conf,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  filename = "01-cold-turkey";
  sudoerTemplate = builtins.readFile ./sudoers.tmpl;
  templateVars = {
    __USERNAME__ = username;
    __FILENAME__ = filename;
  };

  sudoerContent = (
    lib.strings.replaceStrings (builtins.attrNames templateVars) (builtins.attrValues templateVars)
      sudoerTemplate
  );
in
{
  homebrew = {
    enable = true;
    casks = [
      "cold-turkey-blocker"
    ];
  };

  environment.etc.cold-turkey-sudoers = {
    target = "sudoers.d/${filename}";
    text = sudoerContent;
  };
}
