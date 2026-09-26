{ ... }:

{
  programs.yazi = {
    enable = true;

    settings = {
      opener = {
        pdf = [
          {
            run = ''okular "$@"'';
            desc = "Okular";
          }
        ];
        image = [
          {
            run = ''imv "$@"'';
            orphan = true;
            desc = "IMV";
          }
        ];
        video = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            desc = "MPV";
          }
        ];
        text = [
          {
            run = ''nvim "$@"'';
            desc = "Neovim";
          }
        ];
      };

      open.prepend_rules = [
        {
          mime = "application/pdf";
          use = "pdf";
        }
        {
          mime = "image/*";
          use = "image";
        }
        {
          mime = "video/*";
          use = "video";
        }
        {
          mime = "text/*";
          use = "text";
        }
      ];
    };

    keymap = {
      manager = {
        prepend_keymap = [
          {
            on = [ "<Enter>" ];
            run = "open";
            desc = "Open the selected file";
          }
          {
            on = [ "e" ];
            run = "plugin extract";
            desc = "Extract here";
          }
          {
            on = [ "E" ];
            run = "plugin extract --args='--subdir'";
            desc = "Extract into a subdirectory named after archive";
          }
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
