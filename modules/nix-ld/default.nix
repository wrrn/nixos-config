{ ... }:
{
  # Allow running unpatched, dynamically-linked prebuilt binaries that hardcode
  # the FHS ELF interpreter /lib64/ld-linux-x86-64.so.2 — e.g. npm-distributed
  # native tools like biome and esbuild. nix-ld installs a shim at that path
  # which redirects to a real nixpkgs glibc loader via $NIX_LD /
  # $NIX_LD_LIBRARY_PATH. Inert for Nix-built binaries, whose interpreter points
  # into the store, so it only affects foreign binaries that are otherwise
  # unrunnable here. Library set left at the module default (sufficient for
  # biome); extend programs.nix-ld.libraries if a tool needs more.
  programs.nix-ld.enable = true;
}
