# home/modules/ghostty.nix

{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Background & Transparency
      background-opacity = 0.65;
      background-blur = true;

      # Fonts
      font-family = "Fira Code Nerd Font";
      font-size = 12;

      # Cursor Customization
      cursor-style = "block";
      cursor-style-blink = true;

      # Window Layout & Padding
      window-padding-x = 10;
      window-padding-y = 10;
      window-padding-balance = true;
      window-width = 120;
      window-height = 35;
      window-decoration = false;

      # Tab Bar Customization
      gtk-tabs-location = "bottom";

      # Audio Bell
      desktop-notifications = false;
      command = "zsh";
    };
  };
}
