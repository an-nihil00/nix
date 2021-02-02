{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wm/xmonad.nix
    ];

  ###########################################################################
  ## General
  ###########################################################################

  system.stateVersion = "20.03"; 

  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true
  
  # English locale with chinese input
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
  };

  # Time
  time.timeZone = "America/New_York";
  
  ###########################################################################
  ## Networking
  ###########################################################################
  
  networking.hostName = "emm218";
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;
  programs.nm-applet.enable = true;

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  
  ###########################################################################
  ## Package Management
  ###########################################################################
  
  # Allow unfree packages (for discord and zoom)
  nixpkgs.config.allowUnfree = true;

  #installing flatpak for sandboxing zoom (bleh)
  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    discord
    emacs
    firefox
    gimp
    git
    gnome3.gnome-keyring
    gnupg
    hugo
    inkscape
    jetbrains.idea-community
    keepassxc
    maven
    pinentry
    praat
    rhythmbox
    sbcl
    unzip
    usbutils
    wget
    wine
  ];

  fonts.fonts = with pkgs; [
     liberation_ttf
     noto-fonts
     source-han-serif-simplified-chinese
     terminus_font
     terminus_font_ttf
  ];
  
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
     pinentryFlavor = "curses";
  };

  ###########################################################################
  ## Services
  ###########################################################################
  
  services.openssh = {
    enable = true;

    # Only pubkey auth
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  programs.ssh.startAgent = true;

  ###########################################################################
  ## Users
  ###########################################################################
  
  users.users.emmy = {
     isNormalUser = true;
     uid = 1001;
     home = "/home/emmy"; 
     extraGroups = [ "wheel" "networkmanager" "audio"];

     #a place to put my public keys so I can authenticate with ssh
     openssh.authorizedKeys.keys = [

     ];
  };

}

