# Secrets

This repository is prepared for `sops-nix` in Home Manager.

Use encrypted files under `secrets/`, for example:

- `secrets/home.yaml`
- `secrets/mail.env`
- `secrets/app.ini`

Example Home Manager usage:

```nix
{
  sops.defaultSopsFile = ../../../secrets/home.yaml;

  sops.secrets."git-credentials" = {
    path = "${config.home.homeDirectory}/.config/git/credentials";
  };
}
```

Create or edit a secret file with:

```sh
nix shell nixpkgs#sops -c sops secrets/home.yaml
```

Generate an Age key for the current user with:

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```
