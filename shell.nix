let
  pkgs = import <nixpkgs> {};
in
  pkgs.stdenv.mkDerivation rec {
    name = "advent-of-code-2017";
    env = pkgs.buildEnv {
      name = name;
      paths = buildInputs;
    };
    buildInputs = with pkgs; [
      bash-completion
      beam.packages.erlangR20.elixir
      gitAndTools.gitFull
    ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (
      with pkgs.darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]
    );
    shellHook = ''
      # elixir shell history
      export ERL_AFLAGS="-kernel shell_history enabled"

      # helpful aliases
      alias iexm='iex -S mix'

      # configure git prompt
      export GIT_PS1_SHOWUPSTREAM=true
      export GIT_PS1_SHOWDIRTYSTATE=true
      export GIT_PS1_SHOWUNTRACKEDFILES=true
      source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash
      source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh
      export PS1="\[\033[1;32m\][nix-shell] \[\033[0;33m\]\w\[\033[0m\]\$(__git_ps1 \" (%s)\") "
    '';
  }
