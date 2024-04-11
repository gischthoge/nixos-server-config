{ pkgs, ...}:
{
  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
    workgroup = WORKGROUP
    server string = paperless
    netbios name = paperless
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

      paperup = {
        path = "/home/paperless";
        browseable = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "paperless";
        "force group" = "paperless";
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
