_: {
  profilesPath = ".zen";
  module = {
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          .zen-wrapped
          zen-beta
          zen
        ''; # or just "zen" if you use unwrapped package
        mode = "0755";
      };
    };
  };
}
