{ config, pkgs, ... }: {
  # I see NixOS as a way to have a config i can slap on a system and have my setup exactly the way i like it
  # running binaries not packaged for nix is a pain i learned and altough i could just steam-run everything
  # this is much simpler
  #
  # Reproducibility is not my main if i have to tinker a little bit it's fine
  # having to tinker with every binary i want to run? no thank you
  programs.nix-ld.enable = true;
  programs.nix-ld = {

    # libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    # ^ this doesn't work the list here is weird
    # based on LSB 5.0
    # reference: http://refspecs.linuxfoundation.org/LSB_5.0.0/LSB-Common/LSB-Common/requirements.html#RLIBRARIES
    libraries = with pkgs;  [
      # Core
      glibc
      gcc.cc
      stdenv.cc.cc.lib
      zlib
      ncurses5
      linux-pam
      nspr
      nspr
      nss
      openssl

      # Runtime Languages
      libxml2
      libxslt

      # Bonus (not in LSB)
      bzip2
      curl
      expat
      libusb1
      libcap
      dbus
      libuuid


      # Desktop

      ## Graphics Libraries (X11)
      xorg.libX11
      xorg.libxcb
      xorg.libSM
      xorg.libICE
      xorg.libXt
      xorg.libXft
      xorg.libXrender
      xorg.libXext
      xorg.libXi
      xorg.libXtst
      xorg.libXcursor
      xorg.libXcomposite
      xorg.libXfixes
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXScrnSaver
      xorg.libXfixes
      libxkbcommon

      ## OpenGL Libraries
      libGL
      libGLU

      ## Misc. desktop
      libpng12
      libjpeg
      fontconfig
      freetype
      libtiff
      cairo
      pango
      atk

      ## GTK+ Stack Libraries
      gtk2
      gdk-pixbuf
      glib
      dbus-glib
      at-spi2-core
      at-spi2-atk

      ## Sound libraries
      alsa-lib
      openal

      ## SDL
      SDL
      SDL_image
      SDL_mixer
      SDL_ttf
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf

      # Imaging
      cups
      sane-backends

      # Trial Use
      libpng
      gtk3

    ];
  };

  services = {
    envfs = {
      enable = true;
    };
  };
}

