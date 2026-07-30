{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    mise
    rustc
  ];
}
