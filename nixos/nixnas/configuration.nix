{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./samba.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  

  networking = {
    hostName = "nixNAS"; # Define your hostname.
    hostId = "aec12eae";
    firewall.enable = true;
    firewall.allowPing = true;
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  
  programs.fish.enable = true;

  users.users.gischthoge = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/gischthoge";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgPPWgYAhp9VP3eFN+mvmhOq+Sw3asFTb25ECzNs/El michael@nixos" 
    ];
  };

  
  fileSystems = {
    "/mnt/michael_docs" = { 
      device = "/dev/disk/by-uuid/8862479b-a424-41f5-a896-47dee36c0c81";
      fsType = "ext4";
    };
    "/mnt/lkv_docs" = {
      device = "/dev/disk/by-uuid/539e617c-d650-4a83-95c0-771189b9827a";
      fsType = "ext4";
    };
    "/mnt/schaefergbr_docs" = {
      device = "/dev/disk/by-uuid/d32bd0db-78ce-4c09-a4e5-9384db6e6ca7";
      fsType = "ext4";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.xe-guest-utilities.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment?
}

