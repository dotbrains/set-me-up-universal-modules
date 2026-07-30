{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mise
    nodejs
  ];
}
