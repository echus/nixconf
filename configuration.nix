{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      # To use home-manager as a module: <home-manager/nixos>
    ];

  # Hardware config
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # Boot loader - systemd-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
    };
  };

  # Install latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 12th gen bug fix - see nixos.wiki/Intel_Graphics
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  networking = {
    hostName = "btw";
    wireless.iwd.enable = true;
  };

  time.timeZone = "Australia/Canberra";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty
  };

  # Configure console keymap in X11
  services.xserver = {
    layout = "us";
    xkbOptions = "caps:swapescape";
  };

  # Enable zsh and set as default for all users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # Enable neovim as editor system-wide
  environment.variables.EDITOR = "nvim";

  # Enable polkit for sway
  security.polkit.enable = true;

  # Enable XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  # Enable brightness control via light
  programs.light.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound
  sound.enable = true;

  # Enable udisks to manage mounting/unmounting drives
  services.udisks2.enable = true;

  # Enable pipewire (required by xdg-desktop-portal-wlr - errors out without it)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;

    # Extra packages required for video acceleration
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # User account definition
  users.users.varvara = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
    initialPassword = "pw123";
  };

  # System profile packages
  environment.systemPackages = with pkgs; [
    neovim
    wget
    zsh
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
