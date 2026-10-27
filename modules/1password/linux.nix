{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  # Lets 1Password unlock with the system password through polkit. Needs a
  # running polkit agent and "Unlock using system authentication service"
  # turned on in 1Password's Security settings.
  programs._1password-gui.polkitPolicyOwners = [ username ];
}
