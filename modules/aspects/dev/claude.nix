{
  flake.modules.homeManager.claude =
    { pkgs, ... }:
    let
      image = pkgs.dockerTools.buildImage {
        name = "claude-sandbox";
        tag = "latest";
      };
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "claude" ''
          mkdir -p "$HOME/.claude" "$HOME/.cache/claude-sandbox/nix"
          touch "$HOME/.claude.json"

          docker load -i ${image} >/dev/null

          tty=""
          [ -t 0 ] && tty="-t"

          user_name="$(id -un)"
          user_id="$(id -u)"
          user_group_id="$(id -g)"

          exec docker run --rm --init -i $tty \
            --user "$user_id:$user_group_id" \
            --mount "type=tmpfs,destination=$HOME,tmpfs-mode=1777" \
            --mount "type=tmpfs,destination=$HOME/.cache,tmpfs-mode=1777" \
            --mount "type=tmpfs,destination=/tmp,tmpfs-mode=1777" \
            -v /nix:/nix:ro \
            -v /run/current-system:/run/current-system:ro \
            -v "/etc/profiles/per-user/$user_name:/etc/profiles/per-user/$user_name:ro" \
            -v /etc/nix/nix.conf:/etc/nix/nix.conf:ro \
            -v /etc/nix/registry.json:/etc/nix/registry.json:ro \
            -v /etc/passwd:/etc/passwd:ro \
            -v /etc/group:/etc/group:ro \
            -v "$HOME/.claude:$HOME/.claude" \
            -v "$HOME/.claude.json:$HOME/.claude.json" \
            -v "$HOME/.cache/claude-sandbox/nix:$HOME/.cache/nix" \
            -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
            -v "$PWD:$PWD" \
            -w "$PWD" \
            -e PATH="/etc/profiles/per-user/$user_name/bin:/run/current-system/sw/bin" \
            claude-sandbox:latest \
            ${pkgs.claude-code}/bin/claude "$@"
        '')
      ];
    };
}
