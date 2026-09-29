{
  flake.modules.homeManager.claude =
    { pkgs, ... }:
    let
      image = pkgs.dockerTools.buildLayeredImage {
        name = "claude-sandbox";
        tag = "latest";
        contents = with pkgs.dockerTools; [
          binSh
          usrBinEnv
          fakeNss
        ];
        includeStorePaths = false;
        compressor = "none";
      };
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "claude" ''
          [ -d .git ] || { echo ".git not found" >&2; exit 1; }

          mkdir -p "$HOME/.claude"
          touch "$HOME/.claude.json"

          podman load -q -i ${image} >/dev/null

          exec podman run --rm --init --pull=never -i \
            --tty="$([ -t 0 ] && echo true || echo false)" \
            --tz=local \
            --tmpfs /tmp \
            -v /nix:/nix:ro \
            -v /etc/nix/nix.conf:/etc/nix/nix.conf:ro \
            -v /etc/nix/registry.json:/etc/nix/registry.json:ro \
            -v "$HOME/.claude:/root/.claude" \
            -v "$HOME/.claude.json:/root/.claude.json" \
            -v "$PWD:$PWD" \
            -v "$PWD/.git:$PWD/.git:ro" \
            -w "$PWD" \
            -e HOME=/root \
            -e IS_SANDBOX=1 \
            -e NIX_REMOTE=daemon \
            -e COLORTERM \
            -e TERM_PROGRAM \
            -e SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
            -e PATH="$(readlink -f "/etc/profiles/per-user/$USER")/bin:$(readlink -f /run/current-system)/sw/bin" \
            claude-sandbox:latest \
            ${pkgs.claude-code}/bin/claude --dangerously-skip-permissions "$@"
        '')
      ];
    };
}
