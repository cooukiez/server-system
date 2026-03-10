{
  containers.glances = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.21";

    config =
      { config, pkgs, ... }:
      {
        services.glances = {
          enable = true;
          extraArgs = [
            "-w"
            "-p"
            "8000"
            "-B"
            "0.0.0.0"
          ];
        };

        networking.firewall.allowedTCPPorts = [ 8000 ];
        system.stateVersion = "25.11";
      };
  };
}
