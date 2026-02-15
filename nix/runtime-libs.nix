{ pkgs }:
with pkgs;
[
  at-spi2-atk
  atk
  cairo
  gdk-pixbuf
  glib
  gtk3
  harfbuzz
  libdatrie
  libepoxy
  libglvnd
  libselinux
  libsepol
  libthai
  libxkbcommon
  pango
  pcre
  stdenv.cc.cc.lib
  util-linux
  wayland
  libx11
  libxcursor
  libxdmcp
  libxi
  libxrandr
]
