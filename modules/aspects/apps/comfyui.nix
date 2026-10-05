{
  flake.modules.nixos.comfyui =
    { lib, pkgs, ... }:
    let
      version = "0.38.2";

      src = pkgs.fetchFromGitHub {
        owner = "Comfy-Org";
        repo = "ComfyUI";
        tag = "v${version}";
        hash = "sha256-JtHeAkF9ueQShhfoeHC7DbrEMLEKX50AW9JPtOoa8UI=";
      };

      deps =
        pkgs.runCommand "comfyui-deps-${version}"
          {
            nativeBuildInputs = [ (pkgs.python313.withPackages (ps: [ ps.pip ])) ];
            outputHashMode = "recursive";
            outputHashAlgo = "sha256";
            outputHash = "sha256-Pm3oXjEGkgprbYusOr9Kb35MvB5jpLYLCdzjec+cEVs=";
          }
          ''
            export HOME=$TMPDIR
            pip install --target $out --no-compile \
              --extra-index-url https://stable.repo.amd.com/rocm/whl-next/ \
              "torch[device-gfx1100]==2.13.0+rocm10.0.0" "torchvision[device-gfx1100]==0.28.0+rocm10.0.0" \
              -r ${src}/requirements.txt
            rm -r $out/bin
          '';
    in
    {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "comfyui" ''
          export PYTHONPATH=${deps}
          export PYTHONPYCACHEPREFIX=$HOME/.cache/comfyui
          export LD_LIBRARY_PATH=${
            lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.zlib
              pkgs.zstd
              pkgs.xz
            ]
          }
          export PATH=${pkgs.gcc}/bin:$PATH
          export HIP_VISIBLE_DEVICES=0
          mkdir -p ~/.local/share/comfyui/custom_nodes
          exec ${pkgs.python313}/bin/python3 ${src}/main.py --base-directory ~/.local/share/comfyui --preview-method latent2rgb --disable-dynamic-vram --disable-async-offload "$@"
        '')
      ];
    };
}
