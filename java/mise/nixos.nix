{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jdk
    mise
  ];
}
