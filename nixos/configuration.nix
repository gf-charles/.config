# THIS IS A TEST WOOOOOOOO000
{ config, lib, pkgs, ... }:

let
  myCustomDwl = pkgs.callPackage ./pkgs/dwl-custom.nix { };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configs/current
    ];

  # Nix settings
  nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Keyboard layout settings
  console.keyMap = ./console-keys/us.map;

  # More display manager stuff
  services.seatd.enable = true;
  security.pam.services.dwl.enable = true;
  security.rtkit.enable = true; # required for xdgportal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
	# Explicitly tell it to use 'wlr' for screen sharing
        "org.freedesktop.portal.ScreenCast" = "wlr";
        "org.freedesktop.portal.Screenshot" = "wlr"; # Also good to include this

        # For all other interfaces, use 'gtk' as the preferred backend
        # This will cover file choosers, camera, etc.
        "org.freedesktop.portal.FileChooser" = "gtk";
        "org.freedesktop.portal.Camera" = "gtk";
        "org.freedesktop.portal.Desktop" = "gtk"; # Good general fallback
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk 
    ];
  };

  # Systemd import user environment variables
  systemd.user.extraConfig = ''
    DefaultEnvironment=XDG_CURRENT_DESKTOP=${config.environment.sessionVariables.XDG_CURRENT_DESKTOP}
  '';

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    nerd-fonts.fira-code
  ];

  # Timezone and locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Users
  users.mutableUsers = true;
  users.users.cgf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "seat" ];
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  
  # Sudo support
  security.sudo.enable = true;

  # Pick Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Git
  programs.git.enable = true;
  programs.git.config = {
    user.name = "Charles Faisandier";
    user.email = "faisandiercharles@outlook.com";
    push.autoSetupRemote = true;
  };

  # Environment
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = "1"; # Keep this if you want Qutebrowser to run in native Wayland mode
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SHELL = "/run/current-system/sw/bin/zsh";
    PATH = [
      "$HOME/.config/emacs/bin"
      "/home/cgf/.config/scripts:/run/current/system/sw/bin"
      "$PATH"
    ];
    EDITOR = "nvim";
  };

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd \"dwlstart\"";
	user = "cgf";
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # System
    kbd
    mesa

    # Driver info
    mesa-demos
    pciutils

    # Applications
    ## compositor applications
    iw
    acpi
    myCustomDwl
    qutebrowser
    bemenu
    foot
    wbg
    wl-clipboard
    emacs-pgtk
    grim
    slurp
    ## terminal-based
    wget
    neovim
    pass
    gnupg
    pinentry
    ### audio
    pulseaudio
    pamixer
    ### emacs
    ripgrep
    fd
    sqlite
    graphviz
    texliveMedium
    ### lsp
    pyright
    clang
    clang-tools
    nil
    bash-language-server
    ## devtools
    gdb
    gnumake
    gh
    git
    cmake
    libtool

    # Zsh
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    starship

  ];

  # Sound
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}

