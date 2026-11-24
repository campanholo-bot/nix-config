{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "selenized";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "jan-warchol";
    repo = "selenized";
    rev = "9a753d5c575c48e29eeb2be745d9571b4cec42b3";
    hash = "sha256-gS+LdNHGjai4EJXmJXORbWSY2vTxdL9w89HMR+sNldY=";
  };

  sourceRoot = "source/editors/vim";

  meta = {
    description = "Selenized colour schemes for Vim and Neovim";
    homepage = "https://github.com/jan-warchol/selenized";
    license = lib.licenses.mit;
  };
}
