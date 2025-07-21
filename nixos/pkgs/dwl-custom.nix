{ pkgs, stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "dwl-custom";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "gf-charles";
    repo = "dwl-v0.7";
    tag = "v1.1.0";
    sha256 = "sha256-SMp3BbY1WrouFWOVRu9H2UtjNPUCWuh2QD0KqRofxKI=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = with pkgs; [
    libglvnd
    libinput
    pixman
    wayland
    wayland-protocols
    libdrm
    libevdev
    libxkbcommon
    libudev-zero
    libcap
    wlroots
    fcft
    wbg
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
    wayland-scanner
  ];

  meta = with lib; {
    description = "Personal fork of Wayland tiling manager dwl.";
    homepage = "https://github.com/gf-charles/dwl-v0.7";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
