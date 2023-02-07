{ config, lib, pkgs, ... }:

# Allows us to set nixpkgs.config.allowUnfree = true further down
with pkgs;

let
  # Path to nixconf repository
  nixconfPath = builtins.getEnv "HOME" + "/nixconf";

  # Fetch AstroNvim source
  astronvimSource = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "4f4269d174d85df8b278a6e09d05daeef840df4a";
    sha256 = "0cknamcvw7il7fbndaj9dc6g66fj32aby87iqx8akr6nl83sp4ky";
  };

  # AstroNvim init.lua user config
  astronvimUserConfig = pkgs.writeTextFile {
    name = "init.lua";
    text = builtins.readFile "${nixconfPath}/configs/astronvim.lua";
  };

  # Copy user config into astronvim setup
  astronvim = pkgs.runCommand "astronvim" {} ''
    cp -r ${astronvimSource} $out
    ls -al $out
    chmod +w $out/lua
    mkdir -p $out/lua/user
    cp ${astronvimUserConfig} $out/lua/user/init.lua
  '';

  # gruvbox base16 color theme
  # https://github.com/rkubosz/base16-sway/blob/master/themes/base16-gruvbox-dark-pale.config
  base00 = "#262626";
  base01 = "#3a3a3a";
  base02 = "#4e4e4e";
  base03 = "#8a8a8a";
  base04 = "#949494";
  base05 = "#dab997";
  base06 = "#d5c4a1";
  base07 = "#ebdbb2";
  base08 = "#d75f5f";
  base09 = "#ff8700";
  base0A = "#ffaf00";
  base0B = "#afaf00";
  base0C = "#85ad85";
  base0D = "#83adad";
  base0E = "#d485ad";
  base0F = "#d65d0e";

in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "varvara";
  home.homeDirectory = "/home/varvara";

  home.packages = with pkgs; [
    # Command line utilities
    foot
    oh-my-zsh
    silver-searcher
    fzf
    tmux
    neofetch
    git
    tig
    gh
    unzip
    nix-prefetch-git

    # File viewers
    feh
    zathura

    # Programming
    python3
    cmake
    gcc
    gnumake
    nodejs
    yarn
    micromamba
    meld

    # WM
    i3status-rust
    autotiling
    bemenu
    xwayland
    gammastep # Service
    sway-contrib.grimshot # Screenshots

    # Hardware control utilities
    iwgtk
    blueman # Service
    pulseaudio
    pamixer
    pavucontrol
    light # Brightness adjustment

    # Fonts
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    nerdfonts

    # User apps
    chromium
    signal-desktop
    zoom-us
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "sway";
    XDG_CURRENT_DESKTOP = "sway";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    BMENU_BACKEND = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    # nix-ld setup
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      stdenv.cc.cc
    ];
    NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";

    # opendata.fit development variables
    OPENDATAFIT_USERS_SRC          = builtins.getEnv "HOME" + "/development/opendatafit/opendatafit-users";
    OPENDATAFIT_CONTAINER_BASE_SRC = builtins.getEnv "HOME" + "/development/opendatafit/opendatafit-container-base";
    OPENDATAFIT_SCHEDULER_SRC      = builtins.getEnv "HOME" + "/development/opendatafit/opendatafit-scheduler";
    OPENDATAFIT_NOTIFY_SRC         = builtins.getEnv "HOME" + "/development/opendatafit/opendatafit-notify";
    OPENDATAFIT_STORE_SRC          = builtins.getEnv "HOME" + "/development/opendatafit/opendatafit-store";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  wayland.windowManager.sway = {
    enable = true;

    xwayland = true;
    systemdIntegration = true;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    config = {
      terminal = "foot";
      menu = "bemenu-run";
      modifier = "Mod4";

      input = {
        "type:touchpad" = {
          tap = "enabled";
          dwt = "enabled";
          scroll_method = "two_finger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
        };

        "type:pointer" = {
          natural_scroll = "enabled";
        };

        "type:keyboard" = {
          repeat_delay = "300";
          repeat_rate = "30";
          xkb_options = "caps:swapescape";
        };
      };

      colors = {
        focused = {
          border      = base05;
          background  = base0D;
          text        = base00;
          indicator   = base0D;
          childBorder = base0D;
        };

        focusedInactive = {
          border      = base01;
          background  = base01;
          text        = base05;
          indicator   = base03;
          childBorder = base01;
        };

        unfocused = {
          border      = base01;
          background  = base00;
          text        = base05;
          indicator   = base01;
          childBorder = base01;
        };

        urgent = {
          border      = base08;
          background  = base08;
          text        = base00;
          indicator   = base08;
          childBorder = base08;
        };

        placeholder = {
          border      = base00;
          background  = base00;
          text        = base05;
          indicator   = base00;
          childBorder = base00;
        };

        background = base07;
      };

      bars = [
        {
          position = "top";

          fonts = {
            names = [ "Fira Code" ];
            size = 10.0;
          };

          colors = {
            focusedWorkspace = {
              border     = base05;
              background = base0D;
              text       = base00;
            };

            activeWorkspace = {
              border     = base05;
              background = base03;
              text       = base00;
            };

            inactiveWorkspace = {
              border     = base03;
              background = base01;
              text       = base05;
            };

            urgentWorkspace = {
              border     = base08;
              background = base08;
              text       = base00;
            };

            bindingMode = {
              border     = base00;
              background = base0A;
              text       = base00;
            };
          };

          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        }
      ];

      fonts = {
        names = [ "Fira Code" ];
        size = 10.0;
      };

      focus = {
        followMouse = "always";
      };

      gaps = {
        inner = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = 0;
        titlebar = false;
      };

      startup = [
        # https://github.com/NixOS/nixpkgs/issues/119445
        {command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      ];

      output = {
        "*".bg = "~/wallpapers/current.jpg fill";
        "*".scale = "1.5";
      };

      # Display device configuration
      output = {
        # Internal monitor
        eDP-1 = {
        };

        # Work monitor
        DP-1 = {
          # transform = "90";
        };
      };
    };

    extraConfig = builtins.readFile "${nixconfPath}/configs/sway";
  };

  programs = {
    i3status-rust = {
      enable = true;


      bars.top = {
        blocks = [
          {
            block = "net";
            format = "{signal_strength} {ssid}";
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "used";
            format = "{icon} {used}/{total}";
          }
          {
            block = "cpu";
            format = "{utilization}";
          }
          {
            block = "memory";
            format_mem = "{mem_used_percents} {mem_used}/{mem_total}";
            format_swap = "{swap_used_percents}";
            display_type = "memory";
            icons = true;
            clickable = false;
            warning_mem = 80;
            critical_mem = 95;
          }
          {
            block = "sound";
            format = "{volume}";
            # on_click = "pamixer -t";
          }
          {
            block = "backlight";
            cycle = [100 50 25 5 25 50];
          }
          {
            block = "battery";
            format = "{percentage} {time}";
            full_format = "{percentage}";
            full_threshold = 96;
          }
          {
            block = "time";
            format = "%A, %b %_d | %H:%M";
          }
        ];

        settings = {
          icons = "awesome";
          theme =  {
            name = "gruvbox-dark";
            # overrides = {
            #   idle_bg             = "#123456";
            #   idle_fg             = "#abcdef";
            #   alternating_tint_bg = "#ffffff";
            #   alternating_tint_fg = "#ffffff";
            #   critical_bg         = "#ffffff";
            #   critical_fg         = "#ffffff";
            #   good_bg             = "#ffffff";
            #   good_fg             = "#ffffff";
            #   idle_bg             = "#ffffff";
            #   idle_fg             = "#ffffff";
            #   info_bg             = "#ffffff";
            #   info_fg             = "#ffffff";
            #   separator_bg        = "#ffffff";
            #   separator_fg        = "#ffffff";
            #   separator           = "#ffffff";
            #   warning_bg          = "#ffffff";
            #   warning_fg          = "#ffffff";
            # };
          };
        };
      };
    };

    foot = {
      enable = true;

      settings = {
        main = {
          term = "xterm-256color";
          font = "Fira Code:size=12";
          dpi-aware = "no";
        };

        mouse = {
          hide-when-typing = "yes";
        };

        colors = {
          # Gruvbox
          background = "282828";
          foreground = "ebdbb2";
          regular0   = "282828";
          regular1   = "cc241d";
          regular2   = "98971a";
          regular3   = "d79921";
          regular4   = "458588";
          regular5   = "b16286";
          regular6   = "689d6a";
          regular7   = "a89984";
          bright0    = "928374";
          bright1    = "fb4934";
          bright2    = "b8bb26";
          bright3    = "fabd2f";
          bright4    = "83a598";
          bright5    = "d3869b";
          bright6    = "8ec07c";
          bright7    = "ebdbb2";
        };
      };
    };

    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };

    git = {
      enable = true;

      userName = "echus";
      userEmail = "varvara@echus.co";
    };

    zsh = {
      enable = true;

      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;

      shellAliases = {
        # vim = "nvim";
      };

      initExtra = builtins.readFile "${nixconfPath}/configs/zsh.zshrc";

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      oh-my-zsh = {
        enable = true;

        plugins = [
          "git"
          "node"
          "npm"
          "extract"
          "z"
          "terraform"
          "ssh-agent"
        ];

        theme = "blinks";
      };
    };

    fzf = {
      enable = true;

      enableZshIntegration = true;
    };

    tmux = {
      enable = true;

      clock24 = true;
      baseIndex = 1;
      keyMode = "vi";

      plugins = [
        pkgs.tmuxPlugins.gruvbox
        pkgs.tmuxPlugins.resurrect
        pkgs.tmuxPlugins.continuum
        pkgs.tmuxPlugins.copycat
        pkgs.tmuxPlugins.sensible
      ];

      extraConfig = builtins.readFile "${nixconfPath}/configs/tmux.conf";
    };
  };


  services = {
    # TODO: Make iwgtk service and remove from sway config

    gammastep = {
      enable = true;
      latitude = -35.282001;
      longitude = 149.128998;
      temperature = {
        day = 6500;
        night = 3500;
      };
    };

    blueman-applet = {
      enable = true;
    };
  };


  home.file = {
    # tig
    ".tigrc".text = builtins.readFile "${nixconfPath}/configs/tigrc";

    # AstroNvim
    ".config/nvim".target = ".config/nvim";
    ".config/nvim".source = astronvim;
  };

  home.activation = {
    # This currently hangs
    # initialiseAstroNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #   ${pkgs.neovim}/bin/nvim -V100 --headless -c 'autocmd User PackerComplete quitall'
    # '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
