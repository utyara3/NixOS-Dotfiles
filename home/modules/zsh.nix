{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # Возвращаем рабочий синтаксис Home Manager для автодополнений
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    # Системные переменные окружения для пользователя
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "ru_RU.UTF-8";
      LC_ALL = "ru_RU.UTF-8";
    };

    # Настройки истории команд
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

    # Сюда вы сможете добавлять свои алиасы (шаблон)
    shellAliases = {
      ls = "eza --icons --group-directories-first --git";
      ll = "eza --long --icons --group-directories-first --git";
      la = "eza --all --icons --group-directories-first --git";
      tree = "eza --tree --icons --group-directories-first --git";
      ssrpg = "cd /home/utyara3/.local/share/Steam/steamapps/common/Stone\ Story\ RPG/Martian\ Rex,\ Inc_/Stone\ Story/76561198016524242/Stonescript/utyara3";
      vact = "source .venv/bin/activate";
      hist = "history -i | grep $(date +%F)";
      clc = "fn -ln -1 | wl-copy";
      notes = "nvim ~/Documents/helper/";
      rebuild = "sudo nixos-rebuild switch --flake .";
    };

    # Настройка Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "extract"
        "history"
      ];
    };

    # Сторонние плагины и темы
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

    # Используем правильную склейку строк для initContent через стандартный mkMerge
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Instant Prompt для p10k
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # Код, который выполнится следом (бывший initExtra)
        
        # Бинд клавиш
        bindkey '^H' backward-kill-word

        # Автодополнение для uvx (если пакет uv установлен)
        if command -v uvx &> /dev/null; then
          eval "$(uvx --generate-shell-completion zsh)"
        fi

        # Загрузка кастомных настроек p10k (если файл существует)
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];
  };
}

