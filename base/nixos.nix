{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    file
    git
    procps
  ];
}
