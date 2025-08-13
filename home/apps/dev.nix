{ config, pkgs, flake-inputs, ... }: {
  services.flatpak = {
    packages = [
      "com.jetbrains.Rider"
      "io.dbeaver.DBeaverCommunity"
      "org.eclipse.Java"
      "org.thonny.Thonny"
      "org.ghidra_sre.Ghidra"
      "org.godotengine.GodotSharp"
    ];
  };

}
