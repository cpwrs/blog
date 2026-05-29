{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nixd
            nodejs_20
            svelte-language-server
            typescript-language-server
            inputs.agenix.packages.${system}.default
            age
          ];

          PUBLIC_COMMIT = "";
          PROD = 0;
        };

        packages.default = pkgs.buildNpmPackage {
          pname = "blog";
          version = self.shortRev or "dirty";
          src = ./.;
          npmDepsHash = "sha256-ZO41iGIyqsPLev/CSVc+IOBbg/tbkW7J3VH9oPYokIw=";
          npmBuildScript = "build";
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r build $out/
            runHook postInstall
          '';

          PUBLIC_COMMIT = self.shortRev or "";
        };
      };

      flake.nixosModules.default = {
        config,
        lib,
        pkgs,
        ...
      }:
        with lib; {
          options.blog = {
            enable = mkEnableOption "A NixOS config that runs my blog using a systemd service";
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
          };

          config = mkIf config.blog.enable {
            systemd.services.blog = {
              description = "Carson's blog";
              after = ["network.target"];
              wantedBy = ["multi-user.target"];

              startLimitIntervalSec = 60;
              startLimitBurst = 5;

              serviceConfig = {
                DynamicUser = true;
                Restart = "on-failure";
                RestartSec = 5;
                ExecStart = "${lib.getExe pkgs.nodejs_20} ${self.packages.${pkgs.system}.default}/build";
                WorkingDirectory = "${self.packages.${pkgs.system}.default}";
                EnvironmentFile = config.blog.secretEnv;
                Environment = [
                  "PROD=1"
                  "NODE_ENV=production"
                  "PORT=${toString config.blog.port}"
                ];
              };
            };
          };
        };
    };
}
