{
  description = "SCarisey's homelab module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f (
          import nixpkgs {inherit system;}
        ));
  in {
    nixosModules = {
      homelab = import ./homelab;
    };

    formatter = forEachSupportedSystem (pkgs: pkgs.alejandra);
  };
}
