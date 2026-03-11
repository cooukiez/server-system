{
  containers.jupyter = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.101";

    config =
      { config, pkgs, ... }:
      {
        services.jupyterhub = {
          enable = true;

          host = "0.0.0.0";
          port = 8000;

          jupyterhubEnv = pkgs.python3.withPackages (p: with p; [
            jupyterhub
            jupyterhub-systemdspawner
          ]);

          kernels = 
            {
              python3 = let
                env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                        ipykernel

                        pandas
                        numpy
                        matplotlib
                        scipy
                        seaborn
                      ]));
              in {
                displayName = "Python 3 (with packages)";
                argv = [
                  "${env.interpreter}"
                  "-m"
                  "ipykernel_launcher"
                  "-f"
                  "{connection_file}"
                ];
                language = "python";
                logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
                logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
              };
            };

          jupyterlabEnv = pkgs.python3.withPackages (p: with p; [
            jupyterhub
            jupyterlab
            notebook
          ]);

          extraConfig = ''
            c.Authenticator.allowed_users = { 'admin', 'hub'}
            c.Authenticator.admin_users = { 'admin' }
          '';
        };

        users.users.hub = {
          isNormalUser = true;
          initialPassword = "dunckerhub";
        };

        users.users.admin = {
          isNormalUser = true;
          initialPassword = "dunckerhub";
          extraGroups = [ "wheel" ];
        };

        networking.firewall.allowedTCPPorts = [ 8000 ];
        system.stateVersion = "25.11";
      };
  };
}
