{ config, lib, pkgs, ... }:

let
  myCustomDwl = pkgs.callPackage ./pkgs/dwl-custom.nix { };
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configs/current
      (import "${home-manager}/nixos")
    ];

  # Nix settings
  nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # put the right .stignore files
  home-manager.users.cgf = { pkgs, ... }: {
    home.stateVersion = "25.05";
    home.file = {
      "/home/cgf/.stignore".text = ''
        .*
        usb/
      '';
      "/home/cgf/.config/.stignore".text = ''
            emacs/.local/
            #*#
            *~
            .#*
            *.org.pdf
            *.org.html
            *.org.tex
            *.org.txt
            *.elc
            pulse/
            procps/
            gh/
            syncthing/
            qutebrowser/.cache/
            nixos/hardware-configs/current
            nixos/nixos-switch.log
      '';
    };
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
  security.sudo.extraConfig = ''
    # Allow 'your_username' to run btrfs subvolume snapshot without password
    ${config.users.users.cgf.name} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/btrfs subvolume snapshot *
  '';

  # Pick Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
     };
  };

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

  # syncthing
  services.syncthing = {
    enable = true;
    user = "cgf";
    group = "users";

    dataDir = "/home/cgf/.local/share/syncthing";
    configDir = "/home/cgf/.config/syncthing";

    openDefaultPorts = true; # Opens 8384 (GUI), 22000 (sync), 21027 (discovery)
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "x61" = { 
          id = "KSLO2YS-6K2HU2H-S2QDCAR-LZX7WYO-YNIFHCN-LXGKMM5-BOA4DKK-MB7DMQG";
        };
        "xps13" = {
          id = "J5FBDRC-OWX7DYP-36FPXCJ-R4FR44S-EZJMUJG-KPVMQAB-U5SDRQ2-Y4DEBAU";
        };
      };

      folders = {
        "home" = { 
          path = "/home/cgf/"; 
          devices = [ "x61" "xps13" ];
          ignorePatterns = [
            ".*"
            "usb/"
          ];
        };
        "config" = {
          path = "/home/cgf/.config/";
          devices = [ "x61" "xps13" ];
        };
      };

      options = {
        startBrowser = false; # Prevent Syncthing from opening browser on startup
      };
    };
  };

  # Sound
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
    ## audio
    pulseaudio
    pamixer
    ## emacs
    ripgrep
    fd
    sqlite
    graphviz
    texliveMedium
    ## lsp
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
    ## compositor applications
    qutebrowser
    bemenu
    foot
    wbg
    wl-clipboard
    emacs-pgtk
    grim
    slurp
    ## terminal-based
    iw
    acpi
    myCustomDwl
    wget
    neovim
    pass
    gnupg
    pinentry
    pstree
    tree
    stc-cli
    jq
    mpv
    screenfetch
    spotify-player
    lm_sensors

    # Zsh
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    starship

  ];
  system.stateVersion = "25.05"; # Did you read the comment?
}

