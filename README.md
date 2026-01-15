# My blog

### Development
Enter the dev environment with `nix develop`. 
Run the app locally with `npm install` then `npm run dev`.

### Production
Build the app with `nix build`.
Run the production build with `node result/build`. 
This depends on a GITHUB_TOKEN with read access to my profile for full functionality.
The runtime is also provided as a systemd service inside of the NixOS module.
