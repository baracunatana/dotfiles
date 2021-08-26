{ config, pkgs, ... }:
  let 
    unstable = import (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable-small)
    { config = config.nixpkgs.config; }; 
  in
  {
    imports =
      [ 
        ./hardware-configuration.nix
      ];
    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    # Enable CUPS to print documents.
    # services.printing.enable = true;
    # Habilitar bluetooth
    # GNome 40 no requiere esto, pero Plasma 5 sí...
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
       enable = true;
    #   enableSSHSupport = true;
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.juan = {
       isNormalUser = true;
       extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
    # Permite la instalacion de paquetes non free
    nixpkgs.config.allowUnfree = true;
    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    # };
    
    # Configure keymap in X11
    services.xserver.layout = "latam";
    # services.xserver.xkbOptions = "eurosign:e";
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    #services.xserver.displayManager.sddm.enable = true;
    #services.xserver.desktopManager.plasma5.enable = true;
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    networking.hostName = "shion"; # Define your hostname.
    networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;
    
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.wlp2s0.useDHCP = true;
    
    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;
    
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    time.timeZone = "America/Bogota";
    nix = {
        binaryCaches = [ "https://nix-community.cachix.org/" ];
        binaryCachePublicKeys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };
    fonts.fonts = with pkgs; [ 
      eb-garamond
      inconsolata-lgc
    ];

    services.emacs.package = pkgs.emacsGcc;
    nixpkgs.overlays = [
      (import (builtins.fetchGit {
         url = "https://github.com/nix-community/emacs-overlay.git";
         ref = "master";
         # rev = "bfc8f6edcb7bcf3cf24e4a7199b3f6fed96aaecf";
      }))
    ];  

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      alacritty 
      firefox
      qutebrowser
      brave
      spotify
      pinta
      evince
      calibre
      archi
      jabref
      zotero
      libreoffice
      unstable.tectonic
      biber
      pdftk
      pandoc
      emacsGcc
      aspell
      aspellDicts.en
      aspellDicts.es
      isync
      unstable.mu
      mgba
      retroarch
      git
      unstable.zoom-us
      teams
      signal-desktop
      keepassx2
      gnupg
      unzip
      wget
      autoconf
      #openssl
      pcloud
      pinentry
      stow
    ];

    nixpkgs.config.retroarch = {
        #enableDolphin = true;
        enableMGBA = true;
        #enableMAME = true;
        enableSnes9x = true;  
        enableSameBoy = true;
        enableNestopia = true;
      };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
