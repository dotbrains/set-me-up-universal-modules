{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    mise
    rustc
  ];
}
