{ pkgs, ... }:

{
  nord = pkgs.vimUtils.buildVimPlugin {
	name = "nord";
	src = pkgs.fetchFromGitHub{
	  owner = "arcticicestudio";
          repo =  "nord-vim";
          rev =  "ea7ff9c343392ec6dfac4e9ec3fe0c45afb92a40";
          sha256 = "142w4dxgv07q38sp5vxmrhzxhy4n1q94zfs3i2vq4p2iqbpgqfw4";

    };
  };
  discord = pkgs.vimUtils.buildVimPlugin {
    name = "discord.nvim";
    src = pkgs.fetchFromGitHub {
    owner  =  "aurieh";
    repo  =  "discord.nvim";
    rev  =  "a9c4587359e0660051dbd099f93d161bca2b1e9a";
    sha256  =  "1yx7dqw7rmhmzk5f5gphly90f2lydvg2vs6n6f6mv8s78nr57g2y";
  };
};
coloresque = pkgs.vimUtils.buildVimPlugin {
  name = "Coloresque";
  src = pkgs.fetchFromGitHub {
    owner =  "ObserverOfTime";
    repo =  "coloresque.vim";
    rev =  "c83c2635eec840200d64df08417ec4331b08baaa";
    sha256 =  "03hpn2zsacczfc1q3jh9jkn6il1cqyda1r8c7h9n2imhcgxk8516";
  };
};
ayu = pkgs.vimUtils.buildVimPlugin {
  name = "ayu";
  src = pkgs.fetchFromGitHub {
    owner= "ayu-theme";
    repo= "ayu-vim";
    rev= "0745635421688ce777f663d13531996cb4da6514";
    sha256= "0w7ixhz72g3lr1hkn450k6x8sdgv95pp6pxbykka3s01i506rzmj";
  };
};
}
