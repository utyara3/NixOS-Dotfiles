# home/modules/nixvim.nix
{
  inputs,
  ...
}:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.source = inputs.nixpkgs;

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
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      clipboard = "unnamedplus";
      signcolumn = "yes"; # Всегда держать колонку слева открытой (чтобы код не прыгал при появлении ошибок)
      scrolloff = 8; # Оставлять 8 строк снизу/сверху при скролле
    };

    keymaps = [
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Prev buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>c";
        action = "<cmd>bdelete<cr>";
        options.desc = "Close buffer";
      }

      # Файловый менеджер
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle position=left<cr>";
        options.desc = "Toggle Explorer";
      }

      # Поиск (добавили недостающие для экрана Alpha)
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
        options.desc = "Jump to bookmarks";
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

      # 1. Автозакрытие скобок, кавычек и тегов
      nvim-autopairs.enable = true;

      # 2. Подсветка изменений Git на полях (зеленые/красные полосы)
      gitsigns.enable = true;

      # 3. Красивый стартовый экран (Alpha)
      alpha = {
        enable = true;
        theme = "dashboard"; # Готовая тема с кнопками быстрой навигации
      };

      # 4. Прокачанный файловый менеджер Neo-tree
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          popup_border_style = "rounded";
          git_status_async = true;

          filesystem = {
            follow_current_file = {
              enabled = true;
            };
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
      };

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
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
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

      lsp-format.enable = true;

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
          nil_ls.enable = true;
          pyright.enable = true;
          ruff.enable = true;
        };
      };
    };
  };
}
