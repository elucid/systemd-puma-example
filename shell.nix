with (import (builtins.fetchTarball {
  name = "nixos-20.03-2020-05-27"; # Descriptive name
  url =
    "https://github.com/nixos/nixpkgs-channels/archive/48723f48ab92381f0afd50143f38e45cf3080405.tar.gz";
  sha256 = "0h3b3l867j3ybdgimfn76lw7w6yjhszd5x02pq5827l659ihcf53";
}) { });
let
  pkgs = import (builtins.fetchTarball {
    name = "nixos-20.03-2020-05-27"; # Descriptive name
    url =
      "https://github.com/nixos/nixpkgs-channels/archive/48723f48ab92381f0afd50143f38e45cf3080405.tar.gz";
    sha256 = "0h3b3l867j3ybdgimfn76lw7w6yjhszd5x02pq5827l659ihcf53";
  }) { };

  localPath = ./. + "/local.nix";
  local = import localPath { pkgs = pkgs; };

  # define packagesto install with special handling for OSX
  basePackages = [
    ruby
  ];

  inputs = basePackages
    ++ lib.optional stdenv.isLinux inotify-tools
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);

  final = if builtins.pathExists localPath then
    inputs ++ local.customPackages
  else
    inputs;

  # define shell startup command with special handling for OSX
  baseHooks = ''
    export PS1='\n\[\033[1;32m\][nix-shell:\w]($(git rev-parse --abbrev-ref HEAD))\$\[\033[0m\] '

    unset SOURCE_DATE_EPOCH

    export LANG=en_US.UTF-8
  '';

  hooks = if builtins.pathExists localPath then
    baseHooks + local.customHooks
  else
    baseHooks;

in mkShell {
  buildInputs = final;
  shellHook = hooks;
}
