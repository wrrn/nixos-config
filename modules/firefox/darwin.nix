{
  pkgs,
  ...
}:
let
  inherit (pkgs.hostPlatform) isDarwin;
in
if isDarwin then
  {
    homebrew = {
      enable = true;
      casks = [
        "firefox@developer-edition"
      ];
    };

    programs.firefox.package = null;
  }
else
  { }
