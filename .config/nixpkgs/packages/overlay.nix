self: super: {
	discord = super.discord.overrideAttrs (_: {
        src = builtins.fetchTarball
          "https://discord.com/api/download?platform=linux&format=tar.gz";
     	 });
	awesome-git = super.awesome.overrideAttrs (_: {
	
        src = super.fetchFromGitHub {
#  	owner = "Elv13";
#  	repo = "awesome-1";
#  	rev = "11fdccdc445ac56c46cf87e650783f4bd11b527b";
#  	sha256 =  "0cmvrcy8ad0ga0lvc4gg4rah0bxsyi24s570a0ydps6hp41p0nbv";
 	 owner = "awesomeWM";
         repo = "awesome";
         rev = "master";
# 	 rev = "f1871873aa4e196f2343690c935d6c8da300ffb5";
 	 sha256 = "15cas610psik838rnqdj306g8ys69i96q3c8cda384yvk9i979s7";
      };
    });

    st-custom = super.callPackage ./st.nix {};
    ranger-git = super.ranger.overrideAttrs (_: {
      src = super.fetchFromGitHub {
      owner= "alnj";
      repo= "ranger";
      rev ="973667cc5ef375a4c093ffdadd172ea9c3137846";
      sha256= "0fl5b150bq5affmrzflmd4p6i5jd1agzjnzqy5fpsljd8r7pqk7c";
    };
  });
    boox = super.callPackage ./boox.nix {};
      tmux = super.tmux.overrideAttrs (_: {
        src = super.fetchFromGitHub {
        owner = "tmux";
        repo ="tmux";
        rev ="ffe39edf2fdd8f0489c05022ca8f6e9994396881";
        sha256 = "0pjjb64qg6vhgk5x7zfv9vhbiz53wd2raymslrhw76vzzl2g3gzq";
      };
    });

      
}
