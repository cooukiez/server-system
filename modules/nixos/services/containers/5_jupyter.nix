{

  containers.jupyter = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.5";

    config =
      { config, pkgs, ... }:
      let
        dsPackages =
          ps: with ps; [
            pandas
            numpy
            matplotlib
            scipy
            seaborn
            notebook
            jupyterlab
          ];
      in
      {
        services.jupyterhub = {
          enable = true;

          host = "0.0.0.0";
          port = 8000;

          jupyterhubEnv = pkgs.python3.withPackages (
            ps:
            (dsPackages ps)
            ++ [
              ps.jupyterhub
              ps.jupyterhub-systemdspawner
            ]
          );

          jupyterlabEnv = pkgs.python3.withPackages (
            ps:
            (dsPackages ps)
            ++ [
              ps.jupyterhub
              ps.jupyterlab
            ]
          );
        };

        networking.firewall.allowedTCPPorts = [ 8000 ];
        system.stateVersion = "25.11";
      };
  };
}
