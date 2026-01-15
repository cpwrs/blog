{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        nixd
        nodejs_20
        svelte-language-server
        typescript-language-server
        agenix.packages.${system}.default
        age
      ];

      PUBLIC_COMMIT = "";
      PROD = 0;
    };

    packages.${system}.default = pkgs.buildNpmPackage {
      name = "blog";
      src = ./.;
      npmDepsHash = "sha256-zqpWINaUCYz97D4tuG1YPEkr3mkkGPWRD06nPOT4ndk=";
      npmBuildScript = "build";
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r build $out/
        runHook postInstall
      '';

      PUBLIC_COMMIT = self.shortRev or "";
    };

    nixosModules.default = {
      config,
      lib,
      pkgs,
      ...
    }:
      with lib; {
        options.blogRuntime = {
          enable = mkEnableOption "A NixOS config that defines my blog runtime as a systemd service";
          port = mkOption {
            type = types.int;
            default = 8000;
            description = "Port to host the blog on";
          };
          secretEnv = mkOption {
            type = types.path;
            description = ''
              Path to an environment file providing the secrets needed to run this app in production.
              Specifically, the blog requires read access to cpwrs GitHub profile via a GITHUB_TOKEN.
            '';
          };
          user = mkOption {
            type = types.str;
            description = "A username to start the blog runtime systemd service under";
          };
        };

        config = mkIf config.blogRuntime.enable {
          systemd.services.blog = {
            description = "My blog runtime";
            after = ["network.target"];
            wantedBy = ["multi-user.target"];

            serviceConfig = {
              User = "carson";
              Group = "users";
              ExecStart = "${pkgs.nodejs_20}/bin/node ${self.packages.${system}.default}/build";
              WorkingDirectory = "${self.packages.${system}.default}";
              EnvironmentFile = config.blogRuntime.secretEnv;
              Environment = [
                "PROD=1"
                "NODE_ENV=production"
                "PORT=${toString config.blogRuntime.port}"
              ];
            };
          };
        };
      };
  };
}
