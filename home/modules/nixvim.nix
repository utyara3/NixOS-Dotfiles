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
      softtabstop = 2; # Улучшает работу клавиши Backspace при удалении отступов
      expandtab = true;

      # smartindent УДАЛЕН. Он ломал отступы в фигурных скобках.

      termguicolors = true;
      clipboard = "unnamedplus";
      signcolumn = "yes";
      scrolloff = 8;
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

      # Поиск
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
      {
        mode = "n";
        key = "<leader>um";
        action = "<cmd>RenderMarkdown toggle<cr>";
        options.desc = "Toggle Markdown Rendering";
      }

      # Диагностика
      {
        mode = "n";
        key = "<leader>ld";
        action.__raw = "function() vim.diagnostic.open_float() end";
        options.desc = "Hover diagnostics";
      }

      # 🔥 НОВЫЕ СВЕРХПОЛЕЗНЫЕ БИНДЫ ДЛЯ СКОРОСТИ:
      # Быстрое сохранение файла через Ctrl+S во всех режимах
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

      # Перемещение выделенных строк вверх/вниз (Alt+j / Alt+k) — как в VS Code
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

      # При очистке поиска (ESC) убирать подсветку найденных слов
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
        # 🔥 Умные отступы на базе синтаксического дерева кода
        settings.indent.enable = true;
      };

      render-markdown = {
        enable = true;
        settings.anti_conceal.enabled = true;
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

      # 🔥 lsp-format заменен на более современный и гибкий conform-nvim
      # Он идеально свяжет Ruff и автоматическое форматирование при сохранении
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
          formatters_by_ft = {
            python = [
              "ruff_format"
              "ruff_fix"
            ];
            nix = [ "nixpkgs-fmt" ];
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
          nil_ls.enable = true;

          # Настройка Pyright, чтобы он не конфликтовал с Ruff
          pyright = {
            enable = true;
            settings.python.analysis.ignore = [ "*" ]; # Отключаем базовый линтинг Pyright, отдавая его Ruff
          };

          ruff.enable = true;
        };
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
    };
  };
}
