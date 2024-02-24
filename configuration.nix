# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.initrd.kernelModules = ["nvidia"];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;
    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    forceFullCompositionPipeline = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "tr";
    xkb.variant = "";
  };

  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
  rocm-opencl-icd
  rocm-opencl-runtime
  vaapiVdpau
  libvdpau-va-gl
  ];
#  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
  hardware.opengl.setLdLibraryPath = true;

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.hyprland = {
  enable = true; 
};


services.dbus.enable = true;
xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal 
    pkgs.xdg-desktop-portal-gtk
  ];
};



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.oelmas = {
    isNormalUser = true;
    description = "Öner Elmas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #services.dotnet.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	lunarvim
	kitty
	vimPlugins.LazyVim
	guake
	hyprland
	swww # for wallpapers
	xdg-desktop-portal-gtk
  	xdg-desktop-portal-hyprland
	meson
  	wayland-protocols
  	wayland-utils
	wl-clipboard
  	wlroots
  foliate
	# web browsers
  	brave
  	firefox
  	tor
  	ungoogled-chromium

	# common utilities
  busybox 
  scdoc
  mpv
  gcc

  #pdf reader editor
  masterpdfeditor  
  pdfstudio2022

  # notification daemon
  dunst
  libnotify

  # version control
  git 
  
  # music
  spotify
  notion-app-enhanced
  appflowy
  # terminal emulator
  tmux
  foot
  zellij
  # networking
  networkmanagerapplet # GUI for networkmanager
  
  # editors
  neovim 
  emacs
  vscode
  mc
  mucommander
  # app launchers
  rofi-wayland
  wofi
  
  dotnet-sdk_8
  dotnet-runtime_8
  dotnet-aspnetcore_8
  #jetbrains.rider
  #jetbrains.clion
  #jetbrains.rust-rover
  #jetbrains.pycharm-professional
  #jetbrains.webstorm
  #jetbrains.jdk
  #jetbrains.idea-ultimate
  #jetbrains.datagrip
  #jetbrains-toolbox
  dotnetPackages.Nuget
  mono
  msbuild
  rustc
  rustus
  rustup
  rustfmt
  rust-analyzer

  libva-utils
  fuseiso
  udiskie
  nvidia-vaapi-driver
  swaynotificationcenter
  wlr-randr
  ydotool
  wl-clipboard
  hyprland-protocols
  hyprpaper
  hyprpicker
  swayidle
  swaylock
  firefox-wayland
  xdg-utils
  xdg-desktop-portal
  qt5.qtwayland
  qt6.qmake
  qt6.qtwayland
  adwaita-qt
  adwaita-qt6
  qt6.full
  qtcreator

  ];

nixpkgs.overlays = [
  (self: super: {
    waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  })
];

fonts.packages = with pkgs; [
  nerdfonts
  meslo-lgs-nf
];

environment.sessionVariables = {

LIBVA_DRIVER_NAME = "nvidia";
XDG_SESSION_TYPE = "wayland";
GBM_BACKEND = "nvidia";
__GLX_VENDOR_LIBRARY_NAME = "nvidia";
WLR_NO_HARDWARE_CURSORS = "1";
NIXOS_OZONE_WL = "1";
MOZ_ENABLE_WAYLAND = "1";
SDL_VIDEO_DRIVER = "wayland";
_JAVA_AWT_WM_NONREPARENTING = "1";
CLUTTER_BACKEND = "wayland";
WLR_RENDERER = "vulkan";
XDG_CURRENT_DESKTOP = "Hyprland";
XDG_SESSION_DESKTOP = "Hyprland";
GTK_USE_PORTAL = "1";
NIXOS_XDG_OPEN_USE_PORTAL = "1";

};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions# .
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

}

