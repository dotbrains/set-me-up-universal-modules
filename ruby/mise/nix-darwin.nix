{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mise
    ruby
  ];
}
