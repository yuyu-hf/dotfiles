{ config, pkgs, lib, isMacMini ? false, username, ... }:

{
  system.stateVersion = 6;

  system.primaryUser = username;

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
      "ghostty"
      "wezterm"
      "figma"
      "canva"
      "nani"
    ];
  };

  nix.enable = false;
}
