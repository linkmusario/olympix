{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    #"clearcpuid=514"
    #"clearcpuid=umip"
  ];

  networking.hostName = "olympus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking.
  networking.networkmanager.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # OpenGL thingamabobs
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD drivers.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."linkmusario" = {
    isNormalUser = true;
    description = "Linkmusario";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allows unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    varia
  ];

  # Emacs overlay
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];

  # Enables ly display manager.
  services.displayManager.ly = {
    enable = true;
  };

  # Enables hyprland.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enables fish shell to get rid of error (config for fish is in home.nix).
  programs.fish.enable = true;

  # Steam config
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };
   

  # Enables various fonts.
  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
    symbola
  ];

  # Enables flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection.
  nix.gc = {
    automatic = true;
    dates = "daily"; 
    options = "--delete-older-than 7d";
  };

  # Create symlinks for store files (decreases overall space consumed on disk).
  nix.settings.auto-optimise-store = true;
  
  # Only keep last 5 generations of NixOS in bootloader.
  boot.loader.systemd-boot.configurationLimit = 5;


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
