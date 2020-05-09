# cava-ppa

[CAVA](https://github.com/karlstav/cava) is an audio visualization tool.
This repo contains scripts to build and push cava to my PPA: https://launchpad.net/~hsheth2/+archive/ubuntu/ppa.

If you just want to install cava, execute this:
```bash
sudo add-apt-repository ppa:hsheth2/ppa
sudo apt-get update
sudo apt-get install cava
```

## Setup

- Requires Docker.
- The secrets directory should contain two files: `launchpad_id_rsa` and `launchpad_key.asc`.

## Building a new version

1. Update the cava submodule to contain the latest code.
2. Remove the stuff related to `CONFIGDIR` from the `autogen.sh` file in cava.
3. Update the version number in `env.sh`.
4. Execute `./ppa.sh` to build the package. This will eventually drop into an
   interactive shell. Follow the commands printed out at the end.
5. To test that it builds successfully, execute `./tester.sh` and run the
   commands printed by the `ppa.sh` script.
   
## Notes
- The `bzr dh-make` didn't work for me on Ubuntu 18 or 20 -- that's why the `ppa.sh` script is based on xenial.
- `pbuilder-dist` requires `--privileged` when run within Docker because of this bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930684.
- The way this is set up, both `ppa.sh` and `tester.sh` create Docker containers. They share a Docker volume, which contains all the files related to the deployment.

## References
- https://packaging.ubuntu.com/html/packaging-new-software.html
- https://packaging.ubuntu.com/html/getting-set-up.html
- https://github.com/ismd/screenshotgun/blob/master/deploy/launchpad/deploy.sh
- https://wiki.debian.org/Packaging/BinaryPackage
