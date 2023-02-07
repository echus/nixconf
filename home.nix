{ config, lib, pkgs, ...}:

# Allows us to set nixpkgs.config.allowUnfree = true further down
with pkgs;

let
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
    text = ''
      --              AstroNvim Configuration Table
      -- All configuration changes should go inside of the table below

      -- You can think of a Lua "table" as a dictionary like data structure the
      -- normal format is "key = value". These also handle array like data structures
      -- where a value with no key simply has an implicit numeric key
      local config = {

        -- Configure AstroNvim updates
        updater = {
          remote = "origin", -- remote to use
          channel = "stable", -- "stable" or "nightly"
          version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
          branch = "main", -- branch name (NIGHTLY ONLY)
          commit = nil, -- commit hash (NIGHTLY ONLY)
          pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
          skip_prompts = false, -- skip prompts about breaking changes
          show_changelog = true, -- show the changelog after performing an update
          auto_reload = false, -- automatically reload and sync packer after a successful update
          auto_quit = false, -- automatically quit the current session after a successful update
          -- remotes = { -- easily add new remotes to track
          --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
          --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
          --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
          -- },
        },

        -- Set colorscheme to use
        colorscheme = "gruvbox",

        -- Add highlight groups in any theme
        highlights = {
          -- init = { -- this table overrides highlights in all themes
          --   Normal = { bg = "#000000" },
          -- }
          -- duskfox = { -- a table of overrides/changes to the duskfox theme
          --   Normal = { bg = "#000000" },
          -- },
        },

        -- set vim options here (vim.<first_key>.<second_key> = value)
        options = {
          opt = {
            -- set to true or false etc.
            relativenumber = true, -- sets vim.opt.relativenumber
            number = true, -- sets vim.opt.number
            spell = false, -- sets vim.opt.spell
            signcolumn = "auto", -- sets vim.opt.signcolumn to auto
            wrap = false, -- sets vim.opt.wrap
          },
          g = {
            mapleader = " ", -- sets vim.g.mapleader
            autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
            cmp_enabled = true, -- enable completion at start
            autopairs_enabled = true, -- enable autopairs at start
            diagnostics_enabled = true, -- enable diagnostics at start
            status_diagnostics_enabled = true, -- enable diagnostics in statusline
            icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
            ui_notifications_enabled = true, -- disable notifications when toggling UI elements
            heirline_bufferline = false, -- enable new heirline based bufferline (requires :PackerSync after changing)
          },
        },
        -- If you need more control, you can use the function()...end notation
        -- options = function(local_vim)
        --   local_vim.opt.relativenumber = true
        --   local_vim.g.mapleader = " "
        --   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
        --   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
        --
        --   return local_vim
        -- end,

        -- Set dashboard header
        header = {
          " █████  ███████ ████████ ██████   ██████",
          "██   ██ ██         ██    ██   ██ ██    ██",
          "███████ ███████    ██    ██████  ██    ██",
          "██   ██      ██    ██    ██   ██ ██    ██",
          "██   ██ ███████    ██    ██   ██  ██████",
          " ",
          "    ███    ██ ██    ██ ██ ███    ███",
          "    ████   ██ ██    ██ ██ ████  ████",
          "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
          "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
          "    ██   ████   ████   ██ ██      ██",
        },

        -- Default theme configuration
        default_theme = {
          -- Modify the color palette for the default theme
          colors = {
            fg = "#abb2bf",
            bg = "#1e222a",
          },
          highlights = function(hl) -- or a function that returns a new table of colors to set
            local C = require "default_theme.colors"

            hl.Normal = { fg = C.fg, bg = C.bg }

            -- New approach instead of diagnostic_style
            hl.DiagnosticError.italic = true
            hl.DiagnosticHint.italic = true
            hl.DiagnosticInfo.italic = true
            hl.DiagnosticWarn.italic = true

            return hl
          end,
          -- enable or disable highlighting for extra plugins
          plugins = {
            aerial = true,
            beacon = false,
            bufferline = true,
            cmp = true,
            dashboard = true,
            highlighturl = true,
            hop = false,
            indent_blankline = true,
            lightspeed = false,
            ["neo-tree"] = true,
            notify = true,
            ["nvim-tree"] = false,
            ["nvim-web-devicons"] = true,
            rainbow = true,
            symbols_outline = false,
            telescope = true,
            treesitter = true,
            vimwiki = false,
            ["which-key"] = true,
          },
        },

        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = {
          virtual_text = true,
          underline = true,
        },

        -- Extend LSP configuration
        lsp = {
          -- enable servers that you already have installed without mason
          servers = {
            -- "pyright"
          },
          formatting = {
            -- control auto formatting on save
            format_on_save = {
              enabled = true, -- enable or disable format on save globally
              allow_filetypes = { -- enable format on save for specified filetypes only
                -- "go",
              },
              ignore_filetypes = { -- disable format on save for specified filetypes
                -- "python",
              },
            },
            disabled = { -- disable formatting capabilities for the listed language servers
              -- "sumneko_lua",
            },
            timeout_ms = 1000, -- default format timeout
            -- filter = function(client) -- fully override the default formatting function
            --   return true
            -- end
          },
          -- easily add or disable built in mappings added during LSP attaching
          mappings = {
            n = {
              -- ["<leader>lf"] = false -- disable formatting keymap
            },
          },
          -- add to the global LSP on_attach function
          -- on_attach = function(client, bufnr)
          -- end,

          -- override the mason server-registration function
          -- server_registration = function(server, opts)
          --   require("lspconfig")[server].setup(opts)
          -- end,

          -- Add overrides for LSP server settings, the keys are the name of the server
          ["server-settings"] = {
            -- example for addings schemas to yamlls
            -- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
            --   settings = {
            --     yaml = {
            --       schemas = {
            --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
            --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
            --       },
            --     },
            --   },
            -- },
          },
        },

        -- Mapping data with "desc" stored directly by vim.keymap.set().
        --
        -- Please use this mappings table to set keyboard mapping since this is the
        -- lower level configuration and more robust one. (which-key will
        -- automatically pick-up stored data by this setting.)
        mappings = {
          -- first key is the mode
          n = {
            -- second key is the lefthand side of the map
            -- mappings seen under group name "Buffer"
            ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
            ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
            ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
            ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
            -- quick save
            -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
          },
          t = {
            -- setting a mapping to false will disable it
            -- ["<esc>"] = false,
          },
        },

        -- Configure plugins
        plugins = {
          init = {
            {
              "ellisonleao/gruvbox.nvim",
              as = "gruvbox",
              config = function()
                require("gruvbox").setup {}
              end,
            },
            -- You can disable default plugins as follows:
            -- ["goolord/alpha-nvim"] = { disable = true },

            -- You can also add new plugins here as well:
            -- Add plugins, the packer syntax without the "use"
            -- { "andweeb/presence.nvim" },
            -- {
            --   "ray-x/lsp_signature.nvim",
            --   event = "BufRead",
            --   config = function()
            --     require("lsp_signature").setup()
            --   end,
            -- },

            -- We also support a key value style plugin definition similar to NvChad:
            -- ["ray-x/lsp_signature.nvim"] = {
            --   event = "BufRead",
            --   config = function()
            --     require("lsp_signature").setup()
            --   end,
            -- },
          },
          -- All other entries override the require("<key>").setup({...}) call for default plugins
          ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
            -- config variable is the default configuration table for the setup function call
            -- local null_ls = require "null-ls"

            -- Check supported formatters and linters
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
            config.sources = {
              -- Set a formatter
              -- null_ls.builtins.formatting.stylua,
              -- null_ls.builtins.formatting.prettier,
            }
            return config -- return final config table
          end,
          treesitter = { -- overrides `require("treesitter").setup(...)`
            ensure_installed = { "lua", "python", "astro", "json", "terraform", "nix" },
          },
          -- use mason-lspconfig to configure LSP installations
          ["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
            ensure_installed = { "sumneko_lua", "pyright", "astro", "dockerls", "ember", "bashls", "terraformls", "yamlls", "html", "tsserver", "jsonls", "cssls" },
          },
          -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
          ["mason-null-ls"] = { -- overrides `require("mason-null-ls").setup(...)`
            -- ensure_installed = { "prettier", "stylua" },
          },
          ["mason-nvim-dap"] = { -- overrides `require("mason-nvim-dap").setup(...)`
            -- ensure_installed = { "python" },
          },
        },

        -- LuaSnip Options
        luasnip = {
          -- Extend filetypes
          filetype_extend = {
            -- javascript = { "javascriptreact" },
          },
          -- Configure luasnip loaders (vscode, lua, and/or snipmate)
          vscode = {
            -- Add paths for including more VS Code style snippets in luasnip
            paths = {},
          },
        },

        -- CMP Source Priorities
        -- modify here the priorities of default cmp sources
        -- higher value == higher priority
        -- The value can also be set to a boolean for disabling default sources:
        -- false == disabled
        -- true == 1000
        cmp = {
          source_priority = {
            nvim_lsp = 1000,
            luasnip = 750,
            buffer = 500,
            path = 250,
          },
        },

        -- Customize Heirline options
        heirline = {
          -- -- Customize different separators between sections
          -- separators = {
          --   tab = { "", "" },
          -- },
          -- -- Customize colors for each element each element has a `_fg` and a `_bg`
          -- colors = function(colors)
          --   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
          --   return colors
          -- end,
          -- -- Customize attributes of highlighting in Heirline components
          -- attributes = {
          --   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
          --   git_branch = { bold = true }, -- bold the git branch statusline component
          -- },
          -- -- Customize if icons should be highlighted
          -- icon_highlights = {
          --   breadcrumbs = false, -- LSP symbols in the breadcrumbs
          --   file_icon = {
          --     winbar = false, -- Filetype icon in the winbar inactive windows
          --     statusline = true, -- Filetype icon in the statusline
          --   },
          -- },
        },

        -- Modify which-key registration (Use this with mappings table in the above.)
        ["which-key"] = {
          -- Add bindings which show up as group name
          register = {
            -- first key is the mode, n == normal mode
            n = {
              -- second key is the prefix, <leader> prefixes
              ["<leader>"] = {
                -- third key is the key to bring up next level and its displayed
                -- group name in which-key top level menu
                ["b"] = { name = "Buffer" },
              },
            },
          },
        },

        -- This function is run last and is a good place to configuring
        -- augroups/autocommands and custom filetypes also this just pure lua so
        -- anything that doesn't fit in the normal config locations above can go here
        polish = function()
          -- Set up custom filetypes
          -- vim.filetype.add {
          --   extension = {
          --     foo = "fooscript",
          --   },
          --   filename = {
          --     ["Foofile"] = "fooscript",
          --   },
          --   pattern = {
          --     ["~/%.config/foo/.*"] = "fooscript",
          --   },
          -- }
        end,
      }

      return config
    '';
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
    # Run astronvim setup??
    astronvim

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

    extraConfig = ''
      set $mod Mod4

      # Use pactl to adjust volume in PulseAudio
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +3%
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -3%
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle

      # Brightness adjustment
      bindsym Mod1+minus exec --no-startup-id light -U 3
      bindsym Mod1+equal exec --no-startup-id light -A 3

      # Screenshots
      bindsym $mod+Shift+Print exec --no-startup-id grimshot save area ~/screenshots/$(date +%s).png
      bindsym $mod+Print exec --no-startup-id grimshot save active ~/screenshots/$(date +%s).png
      bindsym Print exec --no-startup-id grimshot save screen ~/screenshots/$(date +%s).png

      # Auto tiling
      exec_always --no-startup-id autotiling

      # Start iwgtk applet
      exec_always iwgtk -i
    '';
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

    # extraConfig = ''
    #   " auto-install vim-plug
    #   if empty(glob('~/.config/nvim/autoload/plug.vim'))
    #     silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    #     autocmd VimEnter * PlugInstall
    #   endif

    #   " vim-plug plugins
    #   call plug#begin('~/.config/nvim/plugged')
    #   Plug 'jeffkreeftmeijer/neovim-sensible'
    #   Plug 'lervag/vimtex'
    #   Plug 'hashivim/vim-terraform'
    #   Plug 'mustache/vim-mustache-handlebars'
    #   Plug 'arcticicestudio/nord-vim'
    #   Plug 'tpope/vim-fugitive'
    #   Plug 'tmhedberg/SimpylFold'
    #   Plug 'Vimjas/vim-python-pep8-indent'
    #   Plug 'ycm-core/YouCompleteMe'
    #   Plug 'vim-syntastic/syntastic'
    #   Plug 'nvie/vim-flake8'
    #   Plug 'scrooloose/nerdtree'
    #   Plug 'ctrlpvim/ctrlp.vim'
    #   Plug 'joukevandermaas/vim-ember-hbs'
    #   Plug 'LnL7/vim-nix'
    #   Plug 'wuelnerdotexe/vim-astro'
    #   call plug#end()
    # '';
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

      initExtra = ''
        # Rebind autocomplete/search key
        bindkey "''${key[Up]}" up-line-or-search
        bindkey "''${key[Down]}" down-line-or-search

        # Start sway
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec sway -d &> ~/.sway.log
        fi

        # Initialise micromamba
        eval "$(micromamba shell hook --shell=zsh)"
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
    ".tigrc".text = ''
      # gruvbox theme for tig
      # https://github.com/ninjabreakbot/tig-gruvbox/blob/main/tigrc

      # tig settings
      set main-view-date = custom
      set main-view-date-format = "%Y-%m-%d"
      set main-view = date:relative author:full commit-title:graph=true,refs=true
      set diff-view = line-number:display=false text:commit-title-overflow=true
      set diff-options = --pretty=short
      set vertical-split = false
      set git-colors = no
      set truncation-delimiter  = ~   # Character drawn for truncations, or "utf-8"
# General colors
      color default                       246         235
      color cursor                        223         236
      color status                        default     default
      color title-focus                   default     default
      color title-blur                    default     default
      color delimiter                     245         default
      color header                        66          default         bold
      color section                       172         default
      color line-number                   241         default
      color id                            124         default
      color date                          172         default
      color author                        109         default
      color mode                          166         default
      color overflow                      241         default
      color directory                     106         default         bold
      color file                          223         default
      color file-size                     default     default
      color grep.file                     166         default

      # Main view colors
      color main.cursor                   223            236
      color graph-commit                  166         default
      color main-head                     166         default         bold
      color main-remote                   172         default
      color main-tracked                  132         default
      color main-tag                      223         default
      color main-local-tag                106         default
      color main-ref                      72          default

      # Status view colors
      color status.header                 172         236             bold
      color status.section                214         default
      color stat-staged                   106         default
      color stat-unstaged                 124         default
      color stat-untracked                166         default
      color stat-none                     default     default

      # Help view colors
      color help.header                   241         default         bold
      color help.section                  166         default
      color help.cursor                   72          236
      color help-group                    166         default
      color help-action                   166         default

      # Diff view colors
      color "commit "                     default     default
      color "Refs: "                      default     default
      color "Author: "                    default     default
      color "AuthorDate: "                default     default
      color "Commit: "                    106         default color "CommitDate: "                66          default color "Merge: "                     default     default color "---"                         167         default color "+++ "                        142         default
      color "--- "                        167         default
      color diff-index                    default     default
      color diff-stat                     223         default
      color diff-add                      142         default
      color diff-add-highlight            106         default
      color diff-del                      167         default
      color diff-del-highlight            223         default
      color diff-header                   132         default
      color diff-chunk                    109         default
      color "diff-tree "                  214         default
      color "TaggerDate: "                default     default

      # Log view colors
      color "Date: "                      72          default

      # Signature colors
      color "gpg: "                       72          default
      color "Primary key fingerprint: "   72          default

      # grep view
      color grep.file                     208         default         bold
      color grep.line-number              241         default         bold
      color grep.delimiter                241         default         bold
      color delimiter                     142         default         bold

      # lines in digraph
      color palette-0     166        default          bold
      color palette-1     66         default          bold
      color palette-2     172        default          bold
      color palette-3     132        default          bold
      color palette-4     72         default          bold
      color palette-5     106        default          bold
      color palette-6     124        default          bold
      color palette-7     250        default          bold
      # repeat
      color palette-8     166        default
      color palette-9     66         default
      color palette-10    172        default
      color palette-11    132        default
      color palette-12    72         default
      color palette-13    106        default
    '';

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
