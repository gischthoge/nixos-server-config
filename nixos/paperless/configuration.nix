{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./samba.nix
#      ./paperless.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "paperless"; # Define your hostname.
    hostId = "103b7a74";
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

  
#  fileSystems = {
#    "/mnt/paperless_data" = {
#      device = "/dev/disk/by-uuid/223d264f8-2a7e-4ab6-beae-b69ba2ad67e7";
#      fsType = "ext4";
#    };
#  };

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

