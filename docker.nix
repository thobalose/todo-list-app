/*
 * The proposal is for FloxPM to use a Nix expression like the following
 * to render containers from a profile path containing:
 *   a) the closure of that path
 *   b) a copy of bashInteractive
 *   c) a copy of GNU coreutils
 *   d) a stub ("fake") version of nameservice files
 *
 * We could either generate docker images proactively as new generations
 * are created or permit the initial fetching of the container to trigger
 * the generation. My preference would be to do a combination of the two,
 * allowing new generation to create containers in a nonblocking way while
 * download attempts would block waiting for builds (which should already
 * be running in the background) to complete.
 *
 * Bottom line: this Nix expression does not get committed to the project
 * repository, but is part of the flox infrastructure. I'm only putting a
 * copy here to document the process and to provide instructions for
 * simulating container creation. Test using the following commands:
 *
 *   floxrun
 *   nix-build docker.nix
 *   docker load < result
 *   docker build -t todo-list-app .
 *   docker run -it -p 8080:8080 --name todo_list_app todo-list-app
 */
{
  name ? "limeytexan/todo-list-app",
  profilePath ? /nix/profiles/limeytexan/todo-list-app,
  maxLayers ? 120,
  tag ? "latest",  # The default :-\
  pkgs ? import <nixpkgs> {}
}:

with pkgs;
let
  # Provide a /etc/passwd and /etc/group that contain root and nobody.
  # Useful when packaging binaries that insist on using nss to look up
  # username/groups (like nginx).
  # /bin/sh is fine to not exist, and provided by another shim.
  fakeNss = symlinkJoin {
    name = "fake-nss";
    paths = [
      (writeTextDir "etc/passwd" ''
        root:x:0:0:root user:/var/empty:/bin/sh
        nobody:x:65534:65534:nobody:/var/empty:/bin/sh
      '')
      (writeTextDir "etc/group" ''
        root:x:0:
        nobody:x:65534:
      '')
      (writeTextDir "etc/nsswitch.conf" ''
        hosts: files dns
      '')
      (runCommand "var-empty" { } ''
        mkdir -p $out/var/empty
      '')
    ];
  };
  # We use buildEnv() here because buildLayeredImage() does not include
  # logic to recursively traverse the dependency graph when building
  # user environments.
  profileClosure = buildEnv {
    name = "${builtins.baseNameOf name}-env";
    paths = [
      bashInteractive coreutils fakeNss (builtins.storePath profilePath)
    ];
  };

in dockerTools.buildLayeredImage {
  inherit name maxLayers tag;
  # config.Labels = "profilePath=\"${profilePath}\"";
  # See https://label-schema.org/rc1/
  config.Labels = {
    "build-date" = builtins.toString builtins.currentTime;
    name = "${builtins.baseNameOf name}";
    # description =
    # usage =
    # url =
    # vcs-url =
    # vcs-ref =
    vendor = "flox";
    # N.B. evaluating profilePath in this way implicitly returns
    # realpath(), thus exposing the 32-character Nix identifier.
    version = builtins.substring 0 32 (builtins.baseNameOf "${profilePath}");
    # schema-version =
    # docker.cmd
    # docker.cmd.devel
    # docker.cmd.test
    # docker.cmd.debug
    # docker.cmd.help
    # docker.params
    # rkt.cmd
    # rkt.cmd.devel
    # rkt.cmd.test
    # rkt.cmd.debug
    # rkt.cmd.help
    # rkt.params
  };
  contents = profileClosure;
  config.Cmd = [ "/bin/sh" ];
}
