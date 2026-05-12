_:
{
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # hidutil mappings live in HID driver memory and are wiped on reboot/logout,
  # and nix-darwin's system.keyboard only applies them at activation. Re-apply
  # at every login via a user LaunchAgent so the remap survives reboots.
  #
  # macOS's native remap (System Settings → Keyboard → Modifier Keys) isn't
  # used because it's stored per-keyboard under
  # com.apple.keyboard.modifiermapping.<vendor>-<product>-0, which is awkward
  # to express declaratively and wouldn't cover newly connected keyboards.
  launchd.user.agents.remapCapsLockToControl = {
    serviceConfig = {
      Label = "org.local.remap-caps";
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}''
      ];
      RunAtLoad = true;
    };
  };
}
