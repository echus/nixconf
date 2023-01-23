{
  config,
  pkgs,
  ...
}: {
  home.username = "varvara";
  home.homeDirectory = "/home/varvara";

  home.packages = with pkgs; [
    oh-my-zsh
    silver-searcher
    fzf
    tmux
    foot
    i3status-rust
    bemenu
    xwayland
    gammastep
    chromium
    iwgtk
    blueman
    pamixer
    pavucontrol
    neofetch
    git
    tig
    python3
    cmake
    gcc
    gnumake
    nodejs
    autotiling
    gammastep
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

      bars = [
        {
          position = "top";
          fonts = {
            names = [ "Fira Code" ];
            size = 10.0;
          };
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        }
      ];

      fonts = {
        names = [ "Fira Code" ];
        size = 10.0;
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
      # output = {
      #   eDP-1 = {
      #     # Set HIDP scale (pixel integer scaling)
      #     scale = "2";
      #   };
      # };
    };
  };

  programs.i3status-rust = {
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
          name = "solarized-dark";
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

  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "xterm-256color";
        font = "Fira Code:size=8";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        foreground = "a0abae";
        background = "202c3d";
        regular0   = "202c3d";
        regular1   = "fe6f70";
        regular2   = "4eb075";
        regular3   = "ba9a0a";
        regular4   = "60a1e6";
        regular5   = "d285ad";
        regular6   = "3dae9f";
        regular7   = "949cbf";
        bright0    = "00B4D8";
        bright1    = "ec7f4f";
        bright2    = "5baf4f";
        bright3    = "be981f";
        bright4    = "8599ef";
        bright5    = "cc82d7";
        bright6    = "2aacbf";
        bright7    = "a0abae";
      };
    };
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      " auto-install vim-plug
      if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall
      endif

      " vim-plug plugins
      call plug#begin('~/.config/nvim/plugged')
      Plug 'jeffkreeftmeijer/neovim-sensible'
      Plug 'lervag/vimtex'
      Plug 'hashivim/vim-terraform'
      Plug 'mustache/vim-mustache-handlebars'
      Plug 'arcticicestudio/nord-vim'
      Plug 'tpope/vim-fugitive'
      Plug 'tmhedberg/SimpylFold'
      Plug 'Vimjas/vim-python-pep8-indent'
      Plug 'ycm-core/YouCompleteMe'
      Plug 'vim-syntastic/syntastic'
      Plug 'nvie/vim-flake8'
      Plug 'scrooloose/nerdtree'
      Plug 'ctrlpvim/ctrlp.vim'
      Plug 'joukevandermaas/vim-ember-hbs'
      Plug 'LnL7/vim-nix'
      call plug#end()
    '';
  };

  programs.git = {
    enable = true;

    userName = "echus";
    userEmail = "varvara@echus.co";
  };

  programs.zsh = {
    enable = true;

    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      # vim = "nvim";
    };

    initExtra = ''
      # Rebind autocomplete/search key
      bindkey "''${key[Up]}" up-line-or-search
      bindkey "''${key[Down]}" down-line-or-search

      # Start sway
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec sway
      fi
    '';

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
      ];

      theme = "blinks";
    };
  };

  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
  };

  programs.tmux = {
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

    extraConfig = ''
      # Move status bar to top
      set-option -g status-position top

      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      set -g status-keys vi
      set -g history-limit 10000

      setw -g mode-keys vi
      setw -g mouse on
      setw -g monitor-activity on

      bind-key v split-window -h
      bind-key s split-window -v

      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key H resize-pane -L 5
      bind-key L resize-pane -R 5

      bind-key M-j resize-pane -D
      bind-key M-k resize-pane -U
      bind-key M-h resize-pane -L
      bind-key M-l resize-pane -R

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R

      # Use Alt-vim keys without prefix key to switch panes
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D 
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # No delay for escape key press
      set -sg escape-time 0

      # Shortcut to reload tmux config
      bind r source-file ~/.tmux.conf

      # Open new sessions at current path
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Enable continuum/resurrect auto session restore
      set -g @continuum-restore 'off'

      # Disable copy on mouse release
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Vim style copying
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel -i -p && xsel -o -p | xsel -i -b"
      bind-key p run "xsel -o | tmux load-buffer - ; tmux paste-buffer"

      # Swap window
      bind-key S-Left swap-window -t -1
      bind-key S-Right swap-window -t +1
    '';
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
