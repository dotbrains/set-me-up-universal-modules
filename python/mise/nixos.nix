{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mise
    python3
  ];
}
