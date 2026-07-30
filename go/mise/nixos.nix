{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    mise
  ];
}
