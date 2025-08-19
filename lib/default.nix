{ inputs, outputs, ... }:

let
  helpers = import ./create-darwin.nix { inherit inputs outputs; };
in
{
  inherit (helpers)
    createDarwin
    ;
}
