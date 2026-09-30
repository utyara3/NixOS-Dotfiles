# home/modules/nixvim.nix
{ inputs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.source = inputs.nixpkgs;

    nixpkgs.config.allowUnfree = true;

    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2; # Улучшает работу клавиши Backspace при удалении отступов
      expandtab = true;
      termguicolors = true;
      clipboard = "unnamedplus";
      signcolumn = "yes";
      scrolloff = 8;
    };

    extraFiles = {
      "lua/utyara/terminal.lua".source = ./nixvim/lua/utyara/terminal.lua;
      "lua/utyara/make.lua".source = ./nixvim/lua/utyara/make.lua;
      "lua/utyara/diagnostics.lua".source = ./nixvim/lua/utyara/diagnostics.lua;
    };

    extraConfigLuaPost = ''
      require("utyara.diagnostics").setup()

      require("which-key").add({
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>f", group = "Find" },
        { "<leader>m", group = "Make" },
        { "<leader>t", group = "Terminal" },
        { "<leader>u", group = "UI" },
      })
    '';

    keymaps = [
      # ─────────────────────────────────────────────
      # WINDOWS
      # Ctrl+h/j/k/l = перемещение между окнами
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options.desc = "Focus left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options.desc = "Focus lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options.desc = "Focus upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        options.desc = "Focus right window";
      }

      # То же самое из terminal-mode.
      # Ctrl+\ Ctrl+n — выйти из terminal-mode,
      # после чего переключить окно.
      {
        mode = "t";
        key = "<C-h>";
        action = "<C-\\><C-n><cmd>wincmd h<cr>";
        options.desc = "Focus left window";
      }
      {
        mode = "t";
        key = "<C-j>";
        action = "<C-\\><C-n><cmd>wincmd j<cr>";
        options.desc = "Focus lower window";
      }
      {
        mode = "t";
        key = "<C-k>";
        action = "<C-\\><C-n><cmd>wincmd k<cr>";
        options.desc = "Focus upper window";
      }
      {
        mode = "t";
        key = "<C-l>";
        action = "<C-\\><C-n><cmd>wincmd l<cr>";
        options.desc = "Focus right window";
      }

      # ─────────────────────────────────────────────
      # BUFFERS
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Delete buffer";
      }

      # ─────────────────────────────────────────────
      # EXPLORER
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle position=left<cr>";
        options.desc = "Toggle Explorer";
      }

      # ─────────────────────────────────────────────
      # SEARCH
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope oldfiles<cr>";
        options.desc = "Recently opened files";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>Telescope marks<cr>";
        options.desc = "Jump to marks";
      }

      # ─────────────────────────────────────────────
      # UI
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>um";
        action = "<cmd>RenderMarkdown toggle<cr>";
        options.desc = "Toggle Markdown rendering";
      }

      # ─────────────────────────────────────────────
      # CODE
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>cf";
        action.__raw = ''
          function()
            require("conform").format({
              async = true,
              lsp_format = "fallback",
            })
          end
        '';
        options.desc = "Format buffer";
      }

      # ─────────────────────────────────────────────
      # DIAGNOSTICS
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>dd";
        action.__raw = ''
          function()
            require("utyara.diagnostics").current_buffer()
          end
        '';
        options.desc = "Current file diagnostics";
      }

      {
        mode = "n";
        key = "<leader>dw";
        action.__raw = ''
          function()
            require("utyara.diagnostics").workspace()
          end
        '';
        options.desc = "Workspace diagnostics";
      }

      {
        mode = "n";
        key = "<leader>dn";
        action.__raw = ''
          function()
            require("utyara.diagnostics").next()
          end
        '';
        options.desc = "Next diagnostic";
      }

      {
        mode = "n";
        key = "<leader>dp";
        action.__raw = ''
          function()
            require("utyara.diagnostics").previous()
          end
        '';
        options.desc = "Previous diagnostic";
      }

      {
        mode = "n";
        key = "<leader>de";
        action.__raw = ''
          function()
            require("utyara.diagnostics").details()
          end
        '';
        options.desc = "Explain diagnostic";
      }

      # ─────────────────────────────────────────────
      # TERMINAL
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>tt";
        action.__raw = ''
          function()
            require("utyara.terminal").toggle()
          end
        '';
        options.desc = "Toggle terminal";
      }

      # Можно закрыть/открыть терминал прямо из terminal-mode.
      {
        mode = "t";
        key = "<leader>tt";
        action = "<C-\\><C-n><cmd>lua require('utyara.terminal').toggle()<cr>";
        options.desc = "Toggle terminal";
      }

      # ─────────────────────────────────────────────
      # MAKE
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<leader>md";
        action.__raw = ''
          function()
            require("utyara.make").default()
          end
        '';
        options.desc = "Run default Make target";
      }

      {
        mode = "n";
        key = "<leader>mt";
        action.__raw = ''
          function()
            require("utyara.make").pick()
          end
        '';
        options.desc = "Choose Make target";
      }

      # ─────────────────────────────────────────────
      # SAVE
      # ─────────────────────────────────────────────

      {
        mode = [
          "n"
          "i"
          "v"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr>";
        options.desc = "Save file";
      }

      # ─────────────────────────────────────────────
      # VISUAL
      # ─────────────────────────────────────────────

      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move line down";
      }

      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move line up";
      }

      # ─────────────────────────────────────────────
      # SEARCH
      # ─────────────────────────────────────────────

      {
        mode = "n";
        key = "<esc>";
        action = "<cmd>noh<cr>";
        options.desc = "Clear search highlight";
      }
    ];
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      web-devicons.enable = true;
      telescope.enable = true;
      which-key.enable = true;
      nvim-autopairs.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;

      alpha = {
        enable = true;
        theme = "dashboard";
      };

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          popup_border_style = "rounded";
          git_status_async = true;
          filesystem = {
            follow_current_file.enabled = true;
            filtered_items = {
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
        };
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          indent.enable = true;
          # Добавим парсеры для C++ и сопутствующих
          ensure_installed = [
            "cpp"
            "c"
            "cmake"
          ];
        };
      };

      render-markdown = {
        enable = true;
        settings.anti_conceal.enabled = true;
      };

      supermaven = {
        enable = true;
        settings = {
          keymaps = {
            accept_suggestion = "<Tab>";
            clear_suggestion = "<C-]>";
            accept_word = "<C-j>";
          };
          ignore_filetypes = {
            log = true;
          };
        };
      };

      # Включаем плагины-источники для CMP (без них автодополнение пустое)
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<S-Tab>" = "cmp.mapping.select_next_item()";
            "<C-Tab>" = "cmp.mapping.select_prev_item()";
            # Добавим принудительный вызов окна подсказок, если оно закрылось
            "<C-Space>" = "cmp.mapping.complete()";
          };
        };
      };

      rustaceanvim = {
        enable = true;
        settings.server.default_settings.rust-analyzer = {
          cargo.allFeatures = true;
          check.command = "clippy";
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };

          formatters_by_ft = {
            python = [
              "ruff_fix"
              "ruff_format"
            ];

            nix = [
              "nixfmt"
            ];

            go = [
              "gofumpt"
            ];

            c = [
              "clang-format"
            ];

            cpp = [
              "clang-format"
            ];
          };
        };
      };

      lsp = {
        enable = true;
        keymaps.lspBuf = {
          "K" = "hover";
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "<leader>ca" = "code_action";
          "<leader>rn" = "rename";
        };

        servers = {
          # --- ВКЛЮЧАЕМ C++ СЕРВЕР ---
          clangd.enable = true;

          nixd = {
            enable = true;
            settings = {
              formatting.command = [ "nixfmt" ];
              nixpkgs.expr = "import <nixpkgs> { }";
              options = {
                nixos.expr = "(builtins.getFlake \"/home/utyara3/nixos-config\").nixosConfigurations.nixos.options";
                home-manager.expr = "(builtins.getFlake \"/home/utyara3/nixos-config\").homeConfigurations.utyara3.options";
              };
            };
          };
          pyright = {
            enable = true;
            settings.python.analysis.ignore = [ "*" ];
          };

          ruff.enable = true;

          # golang
          gopls = {
            enable = true;
            settings = {
              gopls = {
                gofumpt = true;
                staticcheck = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
