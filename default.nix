{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { }
, nix-openscad ? import sources.nix-openscad { inherit pkgs; }
}:
nix-openscad {
  src = ./.;
  name = "cabinet-handle-jig";

  scadFiles = [
    "door.scad"
    "drawer.scad"

    "examples/palomino-11in-drawer.scad"
    "examples/palomino-7in-drawer.scad"
    "examples/palomino-doors.scad"
  ];
}
