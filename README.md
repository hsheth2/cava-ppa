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
5. After running the final command (`dput`), wait for the build to succeed on
   launchpad. Once it succeeds, copy the build to other release series (e.g.
   eoan, focal).

## Notes
- The build process is split between a docker container and a build script. The `ppa.sh` script manages both of them.
- The Docker container installs build and packaging dependencies and basically serves as a checkpoint to make the process faster.
- The `build.sh` script finishes the build process, creates and `.deb` file, and lets the user issue the final command to upload the PPA.

## References
- https://packaging.ubuntu.com/html/packaging-new-software.html
- https://packaging.ubuntu.com/html/getting-set-up.html
- https://github.com/ismd/screenshotgun/blob/master/deploy/launchpad/deploy.sh
- https://wiki.debian.org/Packaging/BinaryPackage
