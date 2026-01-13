# NixOS Docker Container

This is a minimal NixOS container configuration with home-manager support.

## Building Locally

```bash
nix build .#dockerImage
docker load < result
docker run -it nixos-container:latest
```

## GitHub Actions

The container is automatically built and pushed to `cr.lffl.me` on every push to main/master.

## Tagged Images

- `cr.lffl.me/nixos-container:latest` - Latest build
- `cr.lffl.me/nixos-container:<commit-sha>` - Specific commit
