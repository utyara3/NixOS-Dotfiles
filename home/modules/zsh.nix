# home/modules/zsh.nix
{
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "ru_RU.UTF-8";
      LC_ALL = "ru_RU.UTF-8";
    };

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      append = true;
    };

    setOptions = [
      "INC_APPEND_HISTORY"
      "EXTENDED_HISTORY"
      "HIST_REDUCE_BLANKS"
    ];

    shellAliases = {
      ssrpg = "cd '/home/utyara3/.local/share/Steam/steamapps/common/Stone Story RPG/Martian Rex, Inc_/Stone Story/76561198016524242/Stonescript/utyara3'";
      vact = "source .venv/bin/activate";
      hist = "history -i | grep $(date +%F)";
      clc = "fn -ln -1 | wl-copy";
      notes = "nvim ~/Documents/helper/";
      n = "nvim";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "extract"
        "history"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
    ];

    initExtraFirst = ''
      # Instant Prompt для p10k
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # Бинд клавиш
      bindkey '^H' backward-kill-word

      # Direnv
      eval "$(direnv hook zsh)"

      # Автодополнение для uvx (если пакет uv установлен)
      if command -v uvx &> /dev/null; then
        eval "$(uvx --generate-shell-completion zsh)"
      fi

      # Загрузка кастомных настроек p10k (если файл существует)
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # Прокачка CLI
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "Visual Studio Dark+";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
