{ config, pkgs, ... }:

{
  users.users.utyara3 = {
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [ "wheel" "networkmanager" "docker"];
    hashedPassword = "$6$jCXEPojXfl.VMU.b$5m5HPMMkjVpZ1Sj65oOcr91vkm9zb6f4KTX7.i2x1oMsxfFnG6vl0YC2mpPtVQozuIrJcZ527jtvjGgI0diHy/";
  };
  users.mutableUsers = false;
}
