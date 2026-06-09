{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
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

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nixd
            nodejs
            svelte-language-server
            typescript-language-server
          ];

          PUBLIC_COMMIT = "";
        };

        packages.default = pkgs.buildNpmPackage {
          pname = "blog";
          version = self.shortRev or "dirty";
          src = ./.;
          npmDepsHash = "sha256-/mRgu3CXpvA3rb1I9j7K0GRCXfx+q+0ERFyMj/Q1hyA=";
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
            address = mkOption {
              type = types.str;
              default = "::1";
              description = "IP address to run the blog on";
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
                ExecStart = "${lib.getExe pkgs.nodejs} ${self.packages.${pkgs.system}.default}/build";
                WorkingDirectory = "${self.packages.${pkgs.system}.default}";
                EnvironmentFile = config.blog.secretEnv;
                Environment = [
                  "NODE_ENV=production"
                  "HOST=${config.blog.address}"
                  "PORT=${toString config.blog.port}"
                ];
              };
            };
          };
        };
    };
}
