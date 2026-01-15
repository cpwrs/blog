# My blog

### Development
Enter the dev environment with `nix develop`. 
Run the app locally with `npm install` then `npm run dev`.

### Production
Build the app with `nix build`.
The build depends on a GITHUB_TOKEN with read access to my profile for full functionality.
Run the production build with `node result/build`. 
A NixOS module is provided to run the app as a systemd service.
