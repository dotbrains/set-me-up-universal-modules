{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jdk
    mise
  ];
}
