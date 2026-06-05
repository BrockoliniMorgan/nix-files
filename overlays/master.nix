{
  nixpkgs-master,
  system,
  allowUnfree,
  allowUnfreePredicate,
  ...
}:
final: prev: {
  master = import nixpkgs-master {
    inherit system;
    config = {
      inherit allowUnfree allowUnfreePredicate;
    };
  };
}
