{
  flake-utils,
  nmaGappRs,
  flutterApp,
}: {
  default = flake-utils.lib.mkApp {
    drv = nmaGappRs;
    exePath = "/bin/nma_gapp_rs";
  };

  nma-gapp-rs = flake-utils.lib.mkApp {
    drv = nmaGappRs;
    exePath = "/bin/nma_gapp_rs";
  };

  nma-gapp-flutter = flake-utils.lib.mkApp {
    drv = flutterApp;
    exePath = "/bin/nma_gapp";
  };
}
