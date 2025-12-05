{inputs, ...}: {
  nixpkgs.overlays = [ inputs.flaky-falcon.overlays.default ];
  services.falcon-sensor = {
    enable = true;
    cid = "D4ED41F6F18048D7A49C139A2FAC61AD-A2";  # Replace with your actual CrowdStrike Customer ID
  };
}
