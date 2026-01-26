{ config, pkgs, ... }:

{
  system.stateVersion = 6;

  system.primaryUser = "hiragayuria";

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "visual-studio-code"
      "nikitabobko/tap/aerospace"
      "chatgpt"
      "claude"
      "cursor"
      "obsidian"
    ];
  };

  nix.enable = false;
}
