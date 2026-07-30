{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mise
    python3
  ];
}
