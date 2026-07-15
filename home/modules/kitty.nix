# home/modules/kitty.nix

{ ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # Background
      background_opacity = "0.65";
      # background_blur = "1";

      # Advance
      term = "xterm-kitty";

      # Font
      font_family = "Fira Code Nerd Font";
      font_size = "12.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Cursor
      cursor_shape = "block";
      cursor_shape_unfocused = "hollow";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "0";
      shell_integration = "no-cursor";
      cursor_trail = "1";
      cursor_trail_decay = "0.1 0.3";
      cursor_trail_start_threshold = "0";
      # cursor_trail_color #C742FF
      # cursor_trail_color #FE8019
      # cursor_trail_color #88C0D0
      scrollback_lines = "5000";
      scrollbar = "hovered";
      wheel_scroll_multiplier = "3.0";

      # Mouse
      mouse_hide_wait = "3";

      # Window Layout
      remember_window_size = "yes";
      initial_window_width = "1200";
      initial_window_height = "750";
      window_border_width = "1.5pt";
      enabled_layouts = "tall";
      window_padding_width = "0";
      window_margin_width = "1";
      hide_window_decorations = "yes";

      # Tab Bar Customization
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      tab_bar_edge = "bottom";
      tab_bar_align = "center";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";

      # Disable audio
      enable_audio_bell = "no";

      # Close window without confirm
      confirm_os_window_close = "0";
    };
  };
}
