{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Define the packages you need
  buildInputs = [
    pkgs.iverilog
    pkgs.gtkwave
  ];

  # Optional: Set up environment variables if needed
  # shellHook = ''
  #   echo "Entering a Nix shell with iverilog and gtkwave"
  # '';
}
