{
  description = "SCarisey's homelab module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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

    packages = forEachSupportedSystem (pkgs: {coreruleset = pkgs.callPackage ./packages/coreruleset {};});

    overlays.default = final: pref: {coreruleset = final.callPackage ./packages/coreruleset {};};

    formatter = forEachSupportedSystem (pkgs: pkgs.alejandra);
  };
}
