{ inputs, lib, ... }:

let
  desktop = import ../config/desktop.nix;

  commonKeybinds = builtins.listToAttrs (
    map (binding: {
      name = binding.key;
      value = "spawn:${lib.escapeShellArgs binding.command}";
    }) desktop.spawnBindings
  );

  umbrielKeybinds = {
    "Mod+Shift+Slash" = "cheatsheet-toggle";

    "Mod+V" = "window-toggle-floating";
    "Mod+P" = "window-cycle-primary-extent";
    "Mod+Q" = "window-close";
    "Mod+F" = "window-toggle-maximize";
    "Mod+Shift+F" = "window-toggle-maximize-to-edges";
    "Mod+Ctrl+F" = "window-toggle-fullscreen";
    "Mod+Tab" = "overview-toggle";

    "Mod+Minus" = "window-modify-primary-extent:-0.05";
    "Mod+Equal" = "window-modify-primary-extent:0.05";

    "Mod+H" = "window-focus-left";
    "Mod+L" = "window-focus-right";
    "Mod+K" = "window-focus-or-workspace-up";
    "Mod+J" = "window-focus-or-workspace-down";

    "Mod+Shift+H" = "column-move-left";
    "Mod+Shift+L" = "column-move-right";
    "Mod+Shift+K" = "window-move-up";
    "Mod+Shift+J" = "window-move-down";

    "Mod+Ctrl+H" = "window-consume-or-expel-left";
    "Mod+Ctrl+L" = "window-consume-or-expel-right";

    "Mod+Ctrl+Minus" = "window-modify-height-down:-0.05";
    "Mod+Ctrl+Equal" = "window-modify-height-down:0.05";

    "Mod+1" = "workspace-switch:1";
    "Mod+2" = "workspace-switch:2";
    "Mod+3" = "workspace-switch:3";
    "Mod+4" = "workspace-switch:4";
    "Mod+5" = "workspace-switch:5";
    "Mod+6" = "workspace-switch:6";
    "Mod+7" = "workspace-switch:7";
    "Mod+8" = "workspace-switch:8";
    "Mod+9" = "workspace-switch:9";
    "Mod+0" = "workspace-switch:10";

    "Mod+Shift+1" = "column-move-to-workspace:1";
    "Mod+Shift+2" = "column-move-to-workspace:2";
    "Mod+Shift+3" = "column-move-to-workspace:3";
    "Mod+Shift+4" = "column-move-to-workspace:4";
    "Mod+Shift+5" = "column-move-to-workspace:5";
    "Mod+Shift+6" = "column-move-to-workspace:6";
    "Mod+Shift+7" = "column-move-to-workspace:7";
    "Mod+Shift+8" = "column-move-to-workspace:8";
    "Mod+Shift+9" = "column-move-to-workspace:9";
    "Mod+Shift+0" = "column-move-to-workspace:10";

    "Mod+WheelDown" = "workspace-next";
    "Mod+WheelUp" = "workspace-previous";

    "Print" = "spawn:noctalia msg screenshot-region";
    "Shift+Print" = "spawn:noctalia msg screenshot-fullscreen";
    "Ctrl+Print" = "spawn:noctalia msg screenshot-annotate";
    "Mod+Print" = "spawn:noctalia msg screenshot-fullscreen pick";

    "XF86AudioRaiseVolume" = "spawn:wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
    "XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    "XF86AudioMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "XF86AudioMicMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

    "XF86MonBrightnessUp" = "spawn:brightnessctl -e4 -n2 set 5%+";
    "XF86MonBrightnessDown" = "spawn:brightnessctl -e4 -n2 set 5%-";

    "XF86AudioNext" = "spawn:playerctl next";
    "XF86AudioPause" = "spawn:playerctl play-pause";
    "XF86AudioPlay" = "spawn:playerctl play-pause";
    "XF86AudioPrev" = "spawn:playerctl previous";

  };
in
{
  imports = [
    inputs.umbriel.homeModules.default
  ];

  programs.umbriel = {
    enable = true;

    settings = {
      general.show_cheatsheet = false;

      input = {
        keyboard = {
          layout = desktop.keyboard.layout;
          options = desktop.keyboard.options;
        };

        mouse.natural_scroll = true;

        touchpad = {
          natural_scroll = true;
          tap = true;
          disable_while_typing = true;
        };

        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          follows_focus = true;
          hide_when_typing = true;
        };

        focus.follows_mouse = true;
      };

      appearance = {
        prefer_no_csd = true;

        border_width = 2;
        outer_border_width = 0;
        corner_radius = 18;

        shadow = {
          enabled = true;
          softness = 24;
          offset_x = 0;
          offset_y = 6;
        };

        blur = {
          enabled = true;
          optimized = true;
          passes = 3;
          radius = 5;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
      };

      animation = {
        enabled = true;
        duration_ms = 250;
        curve = "easeout";

        windows_in = {
          enabled = true;
          curve = "spring:0.95,700";
          style = "popin";
          scale = 0.92;
        };

        windows_out = {
          enabled = true;
          curve = "spring:0.95,700";
          style = "popin";
          scale = 0.92;
        };

        windows_move = {
          enabled = true;
          curve = "spring:0.9,700";
        };

        workspaces = {
          enabled = true;
          style = "slide";
          curve = "spring:0.95,600";
        };

        overview = {
          enabled = true;
          curve = "spring:0.95,600";
          workspace_curve = "spring:0.95,600";
        };

        border = {
          enabled = true;
          curve = "spring:0.95,900";
        };
      };

      layer_rule = [
        {
          match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";

          blur = true;
          blur_ignore_alpha = 0.5;
          blur_popups = true;
          blur_optimized = false;
        }
      ];

      window_rule = [
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";

          default_floating = true;
          default_maximize = false;

          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }

        {
          match.app_id = "^kitty$";
          default_scrolling_extent = 0.5;
        }

        {
          match.app_id = "^dev.noctalia.Noctalia$";

          default_floating = true;
          default_floating_size_px = {
            width = 1020;
            height = 900;
          };
        }

        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";

          default_floating = true;
          default_floating_size_px = {
            width = 800;
            height = 600;
          };
        }

        {
          match.title = "^notificationtoasts_.+_desktop";

          default_position = {
            x = 0;
            y = 0;
            anchor = "bottom_right";
          };

          default_focused = false;
          default_pinned = true;
        }
      ];

      layout.gap = 18;

      # Подключаем динамическую палитру Noctalia,
      # если её файл существует.
      include.optional.files = [
        "/home/utyara3/.config/umbriel/noctalia.toml"
      ];
      keybinds = commonKeybinds // umbrielKeybinds;
    };
  };
}
