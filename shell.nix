{ pkgs ? import <nixpkgs> { } }: with pkgs; mkShell {
  buildInputs = [ gnumake zip ];
}
