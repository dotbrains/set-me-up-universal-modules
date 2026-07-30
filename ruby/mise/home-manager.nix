{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mise
    ruby
  ];
}
