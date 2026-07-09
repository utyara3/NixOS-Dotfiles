{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "utyara3";
	email = "prorok2018pro@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
