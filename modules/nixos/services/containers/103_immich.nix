{
  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.102";

    bindMounts = {
      # gpu acceleration
      "/dev/dri" = { 
        hostPath = "/dev/dri"; 
        isReadOnly = false; 
      };
      
      # persistent storage
      "/var/lib/immich" = {
        hostPath = "/var/lib/immich";
        isReadOnly = false;
        mountPoint = "/var/lib/immich";
      };
    };

    config = { config, pkgs, ... }: {
      services.immich = {
        enable = true;
        port = 8000;
        host = "0.0.0.0";
        
        # set to null for auto-detection of hardware acceleration
        accelerationDevices = null; 
      };

      users.users.immich.extraGroups = [ "video" "render" ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      environment.variables = {
        LIBVA_DRIVER_NAME = "i965";
      };

      networking.firewall.allowedTCPPorts = [ 8000 ];
      system.stateVersion = "25.11";
    };
  };
}