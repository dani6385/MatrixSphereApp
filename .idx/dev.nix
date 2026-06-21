# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "unstable"; # Using unstable channel for better package availability
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.jdk21
    pkgs.unzip
    pkgs.chromium
    pkgs.cmake
    pkgs.pkg-config # Diperlukan untuk pengembangan Linux
    pkgs.ninja      # Diperlukan untuk pengembangan Linux
    pkgs.android-sdk
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = { };
      # To run something each time the workspace is (re)started, use the `onStart` hook
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        #web = { command = ["flutter" "run" "-d" "web-server" "--web-port" "$PORT" "--no-hot-reload"];manager = "web";};
        # android = { ... };
      };
    };
  };
}
