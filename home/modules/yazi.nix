{ ... }:

{
  programs.yazi = {
    enable = true;
    
    settings = {
      opener = {
        pdf = [ { run = "zathura \"$@\""; block = true; desc = "Zathura"; } ];
        image = [ { run = "imv \"$@\""; detach = true; desc = "IMV"; } ];
        video = [ { run = "mpv \"$@\""; detach = true; desc = "MPV"; } ];
        text = [ { run = "nvim \"$@\""; block = true; desc = "Neovim"; } ];
      };
      open = {
        prepend_rules = [
          { mime = "application/pdf"; use = "pdf"; }
          { mime = "image/*"; use = "image"; }
          { mime = "video/*"; use = "video"; }
          { mime = "text/*"; use = "text"; }
        ];
      };
    };

    keymap = {
      manager = {
        prepend_keymap = [
          {
            on = [ "<Enter>" ];
            run = "plugin extract";
            desc = "Extract here";
          }
          {
            on = [ "<S-Enter>" ]; 
            run = "plugin extract --args='--subdir'";
            desc = "Extract into a subdirectory named after archive";
          }
          # ИСПРАВЛЕНО: Рабочий бинд на Ctrl + t
          {
            on = [ "<C-t>" ];
            run = "shell \"$SHELL\" --block";
            desc = "Open shell in current directory";
          }
        ];
      };
    };
  };
}

