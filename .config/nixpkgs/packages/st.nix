{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
	name = "st";
	src = pkgs.fetchFromGitHub {
        owner = "Tanish2002";
        repo = "st-tanish2002";
        rev = "9a2c72ef17250be5f0719ca6d50e0669f0cddd84";
        sha256 = "03r9l8j36bkynvsj5lb4vl3s3wqj2h2vydbwicxgqsgamy7yj4mz";
	};
	nativeBuildInputs = with pkgs;[ pkgconfig harfbuzz ncurses ];
	buildInputs = with pkgs.xorg;[ libX11 libXft ] ;
	buildPhase = ''
                sed -i -e 's/static int borderpx = 45;/static int borderpx = 25;/g' config.h  
                sed -i -e 's/FuraCode Nerd Font Mono:pixelsize=15:style:Bold:antialias=true:autohint=true/IBM Plex Mono:pixelsize=13:style=Regular:antialias=true:autohint=true/g' config.h
		make	
	'';
	installPhase = ''
	    TERMINFO=$out/share/terminfo make install PREFIX=$out
	  '';


}
