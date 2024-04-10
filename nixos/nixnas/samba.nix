{ pkgs, ...}:
{
  users.groups.smbusers.gid = 111; 

  # Samba users
  users.users.michael = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/nologin";
    createHome = false;
    uid = 1111;
    group = "smbusers";
  };
  
  users.users.lkv = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/nologin";
    createHome = false;
    uid = 1112;
    group = "smbusers";
  };
  
  users.users.schaefergbr = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/nologin";
    createHome = false;
    uid = 1113;
    group = "smbusers";
  };


  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
    workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    security = user 
    #use sendfile = yes
    #max protocol = smb2
    # note: localhost is the ipv6 localhost ::1
    hosts allow = 192.168.178. 127.0.0.1 localhost
    hosts deny = 0.0.0.0/0
    guest account = nobody
    map to guest = bad user
    hide unreadable = yes
    '';

    shares = {
      public = {
      };

      michael = {
        path = "/mnt/michael_docs";
        browseable = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "michael";
        "force group" = "smbusers";
        "veto files" = "/._*/.DS_Store/.Trashes/.TemporaryItems/";
        "delete veto files" = "yes";
      };

      betrieb = {
        path = "/mnt/schaefergbr_docs";
        browseable = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "schaefergbr";
        "force group" = "smbusers";
        "veto files" = "/._*/.DS_Store/.Trashes/.TemporaryItems/";
        "delete veto files" = "yes";
      };
      
      lkv = {
        path = "/mnt/lkv_docs";
        browseable = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "lkv";
        "force group" = "smbusers";
        "veto files" = "/._*/.DS_Store/.Trashes/.TemporaryItems/";
        "delete veto files" = "yes";
      };
    };
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    nssmdns4 = true;
    nssmdns6 = true;
    enable = true;
    openFirewall = true;
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
