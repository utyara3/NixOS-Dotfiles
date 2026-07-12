{ config, pkgs, ... }:

let
  terminal = "kitty";
  vpnApp = "happ";
  fileManager = "kitty -e yazi";
  browser = "zen";
in
{
  programs.niri = {
    enable = true;

    settings = {
      cursor = {
        theme = "Bibata-Modern-Classic";
	size = 24;
	hide-on-key-press = true;
      };

      input = {
        keyboard.xkb = {
          layout = "us,ru";
          options = "grp:alt_shift_toggle";
        };

	warp-mouse-to-focus = {
	  enable = true;
	  mode = "center-xy-always";
	};

	focus-follows-mouse = {
	  enable = true;
	  max-scroll-amount = "1%";
	};
      };

      spawn-at-startup = [
        { command = [ "noctalia" ]; }
	{ command = [ "xwayland-satellite" ]; }
      ];

      binds = {
        
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
        
        "Mod+T".action.spawn = [ "${terminal}" ];
        "Mod+H".action.spawn = [ "sh" "-c" "${vpnApp}" ];
        "Mod+E".action.spawn = [ "sh" "-c" "${fileManager}" ];
        "Mod+B".action.spawn = [ "${browser}" ];
        # "Mod+R".action.spawn = [ "sh" "-c" "${menu}" ];
        "Mod+R".action.spawn = [ "noctalia" "msg" "panel-toggle" "launcher" ];
	"Mod+C".action.spawn = [ "noctalia" "msg" "panel-toggle" "clipboard" ];

        "Mod+L".action.spawn = [ "noctalia" "msg" "session" "lock" ];
        "Mod+M".action.spawn = [ "wlogout" ];
        "Mod+O".action.spawn = [ "obsidian" ];
        "Mod+N".action.spawn = [ "noctalia" "msg" "panel-toggle" "notification" ];
        "Mod+W".action.spawn = [ "noctalia" "msg" "panel-toggle" "wallpaper" ];

        "Mod+V".action.toggle-window-floating = [ ];
        "Mod+P".action.switch-preset-column-width = [ ]; 
        "Mod+Q".action.close-window = [ ];
        "Mod+F".action.maximize-column = [ ]; 
	"Mod+Shift+F".action.expand-column-to-available-width = [ ];
	"Mod+Tab".action.toggle-overview = [ ];

	"Mod+Minus".action.set-column-width = "-5%";
	"Mod+Equal".action.set-column-width = "+5%";

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Up".action.focus-window-or-workspace-up = [ ];
        "Mod+Down".action.focus-window-or-workspace-down = [ ];

        "Mod+Shift+Left".action.move-column-left = [ ];
        "Mod+Shift+Right".action.move-column-right = [ ];
        "Mod+Shift+Up".action.move-window-up = [ ];
        "Mod+Shift+Down".action.move-window-down = [ ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+0".action.move-column-to-workspace = 10;

        
        "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
        "Mod+WheelScrollUp".action.focus-workspace-up = [ ];

        
        "XF86AudioRaiseVolume".allow-inhibiting = false;
        "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        "XF86AudioLowerVolume".allow-inhibiting = false;
        "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        "XF86AudioMute".allow-inhibiting = false;
        "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        "XF86AudioMicMute".allow-inhibiting = false;
        "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        
        "XF86MonBrightnessUp".allow-inhibiting = false;
        "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "-e4" "-n2" "set" "5%+" ];
        "XF86MonBrightnessDown".allow-inhibiting = false;
        "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "-e4" "-n2" "set" "5%-" ];

        "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
        "XF86AudioPause".action.spawn = [ "playerctl" "play-pause" ];
        "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
        "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];

        "Print".action.screenshot = [ ];
        "Shift+Print".action.screenshot-screen = [ ];
        "Ctrl+Print".action.screenshot-window = [ ];
      };

      prefer-no-csd = true;
    };
  };
}

