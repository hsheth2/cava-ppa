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
2. Update the version number and debian revision in `ppa.sh`.
3. For each series (e.g. bionic, eoan, focal, groovy):
    1. Execute `./ppa.sh bionic` to build the package.
    2. When the build finishes it will drop into an interactive shell. Run the `dput` command to upload the package to Launchpad.

## Notes
- The build process is split between a docker container and a build script. The `ppa.sh` script manages both of them.
- The Docker container installs build and packaging dependencies and basically serves as a checkpoint to make the process faster.
- The `build.sh` script finishes the build process, creates and `.deb` file, and lets the user issue the final command to upload the PPA.
- Since the autogen.sh script from cava requires modification, we use a debian/patches directory. This directory is managed by quilt.
- TODO: figure out how to exclude the orig.tar.gz upload.

## References
- https://packaging.ubuntu.com/html/packaging-new-software.html
- https://packaging.ubuntu.com/html/getting-set-up.html
- https://github.com/ismd/screenshotgun/blob/master/deploy/launchpad/deploy.sh
- https://wiki.debian.org/Packaging/BinaryPackage
