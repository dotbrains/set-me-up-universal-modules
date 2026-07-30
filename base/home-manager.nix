{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    file
    git
    procps
  ];
}
