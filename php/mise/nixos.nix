{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mise
    php
  ];
}
