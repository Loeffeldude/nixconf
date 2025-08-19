{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome_6
    fira-code
    fira-code-symbols
  ];
}
