{
  lib,
  rustPlatform,
  src,
}:
rustPlatform.buildRustPackage {
  pname = "impeccable";
  version = (lib.importTOML "${src}/Cargo.toml").workspace.package.version;
  inherit src;
  cargoLock.lockFile = "${src}/Cargo.lock";
  cargoBuildFlags = [
    "--package"
    "impeccable"
  ];
  # The tests drive Chrome.
  doCheck = false;
}
