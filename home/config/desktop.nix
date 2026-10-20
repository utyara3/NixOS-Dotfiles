let
  apps = {
    terminal = "kitty";
    vpn = "happ";
    fileManager = "kitty -e yazi";
    fileManagerGui = "thunar";
    browser = "zen-beta";
  };
in
{
  inherit apps;

  keyboard = {
    layout = "us,ru";
    options = "grp:caps_toggle";
  };

  spawnBindings = [
    {
      key = "Mod+Shift+C";
      command = [ "qalculate-gtk" ];
    }
    {
      key = "Mod+D";
      command = [ "discord" ];
    }
    {
      key = "Mod+Shift+V";
      command = [ apps.vpn ];
    }
    {
      key = "Mod+A";
      command = [ "AyuGram" ];
    }
    {
      key = "F12";
      command = [
        "voxtype"
        "record"
        "toggle"
      ];
    }
    {
      key = "Mod+T";
      command = [ apps.terminal ];
    }
    {
      key = "Mod+Shift+T";
      command = [ "dialect" ];
    }
    {
      key = "Mod+E";
      command = [
        "sh"
        "-c"
        apps.fileManager
      ];
    }
    {
      key = "Mod+Shift+E";
      command = [ apps.fileManagerGui ];
    }
    {
      key = "Mod+B";
      command = [ apps.browser ];
    }
    {
      key = "Mod+R";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "launcher"
      ];
    }
    {
      key = "Mod+C";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "clipboard"
      ];
    }
    {
      key = "Mod+Escape";
      command = [
        "noctalia"
        "msg"
        "session"
        "lock"
      ];
    }
    {
      key = "Mod+M";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "session"
      ];
    }
    {
      key = "Mod+O";
      command = [ "obsidian" ];
    }
    {
      key = "Mod+Shift+O";
      command = [ "obs" ];
    }
    {
      key = "Mod+N";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "control-center"
        "notifications"
      ];
    }
    {
      key = "Mod+W";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "wallpaper"
      ];
    }
    {
      key = "Mod+Shift+W";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "control-center"
        "network"
      ];
    }
    {
      key = "Mod+I";
      command = [
        "noctalia"
        "msg"
        "panel-toggle"
        "control-center"
      ];
    }
  ];
}
