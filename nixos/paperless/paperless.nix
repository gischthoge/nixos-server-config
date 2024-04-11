{ pkgs, ... }:
{
  services.paperless = {
    enable = true;
    dataDir = "/mnt/paperless_data";
    consumptionDir = "/home/paperless";

    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "paperless" ];
  };
}
