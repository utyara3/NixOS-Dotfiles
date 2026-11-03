# home/modules/git.nix

{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "utyara3";
        email = "utyara3.geek@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
