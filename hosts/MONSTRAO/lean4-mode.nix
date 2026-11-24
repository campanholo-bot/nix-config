{
  lib,
  melpaBuild,
  fetchFromGitHub,
  dash,
  lsp-mode,
  magit-section,
}:

melpaBuild {
  pname = "lean4-mode";
  version = "1.1.2-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean4-mode";
    rev = "32daa3e56120e6bfc88fcdfa297c4af04b3c08b0";
    hash = "sha256-Zn2f98bm9tykyg/T0TfP+KbiI+OVCT636anJ2+zkCuA=";
  };

  packageRequires = [
    dash
    lsp-mode
    magit-section
  ];

  # The Lean input method reads its abbreviations from data/.
  files = ''(:defaults "data")'';

  meta = {
    description = "Emacs major mode for Lean 4";
    homepage = "https://github.com/leanprover-community/lean4-mode";
    license = lib.licenses.asl20;
  };
}
