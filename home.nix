{ config, pkgs, inputs, ... }:
let
createSymlink = path: config.lib.file.mkOutOfStoreSymlink path; 
in
{
  home = {
    username = "linkmusario";
    homeDirectory = "/home/linkmusario";
    stateVersion = "26.05";

    # Symlinking dotfiles
    file = {
      ".config/hypr".source = createSymlink "${config.home.homeDirectory}/olympix/dotfiles/hypr";
      ".config/foot".source = createSymlink "${config.home.homeDirectory}/olympix/dotfiles/foot";
      ".config/noctalia".source = createSymlink "${config.home.homeDirectory}/olympix/dotfiles/noctalia";
      ".config/fastfetch".source = createSymlink "${config.home.homeDirectory}/olympix/dotfiles/fastfetch";
      ".config/doom".source = createSymlink "${config.home.homeDirectory}/olympix/dotfiles/doom";
    };
  };

  # Shell (fish)
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      if status --is-interactive
        fastfetch
      end
    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/olympix#olympus";
      nfa = "sudo nix flake update --flake ~/olympix && sudo nixos-rebuild switch --flake ~/olympix#olympus"; };
  };

  home.packages = with pkgs; [
    gcc
    # Cursor
    vimix-cursors
    # Gaming
    heroic 
    # Download manager
    gopeed
    # 7zip extracter
    p7zip-rar
  ];

  # CLIs
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.fastfetch.enable = true;
 
  programs.git = {
    enable = true;
    settings.user = {
      name = "linkmusario";
      email = "issackeldo@gmail.com";
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # Terminal (foot)
  programs.foot.enable = true;

  # Apps via flake inputs
  imports = [
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.beta
  ];
  
  programs.noctalia = {
    enable = true;
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  # Emacs config
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
