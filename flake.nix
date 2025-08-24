{
  description = "SCarisey's homelab module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # crowdsec.url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
    crowdsec.url = "github:scarisey/nix-flake-crowdsec"; #temporary fork
  };

  outputs = {
    self,
    nixpkgs,
    crowdsec,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f (
          import nixpkgs {inherit system;}
        ));
  in {
    nixosModules = {
      crowdsec = crowdsec.nixosModules.crowdsec;
      crowdsec-firewall-bouncer = crowdsec.nixosModules.crowdsec-firewall-bouncer;
      homelab = import ./homelab;
    };

    overlays.default = crowdsec.overlays.default;

    formatter = forEachSupportedSystem (pkgs: pkgs.alejandra);
  };
}
