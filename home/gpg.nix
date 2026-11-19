{ config, pkgs, ... }:
let
  # secret-edit <file.gpg>: decrypt a passphrase-encrypted file into RAM, edit it
  # in nvim, re-encrypt it (AES256) on quit when it changed, then shred the
  # plaintext. A missing file is created. The passphrase goes to gpg over a file
  # descriptor (never argv/env) in loopback mode, so gpg-agent never caches it.
  secret-edit = pkgs.writeShellApplication {
    name = "secret-edit";
    runtimeInputs = [
      config.programs.gpg.package
      config.programs.neovim.finalPackage
      pkgs.coreutils
    ];
    text = ''
      if [ "$#" -ne 1 ]; then
        echo "usage: secret-edit <file.gpg>" >&2
        exit 2
      fi
      file=$1

      read -rsp "Passphrase: " pass
      echo >&2
      if [ ! -e "$file" ]; then
        read -rsp "Confirm passphrase: " pass2
        echo >&2
        if [ "$pass" != "$pass2" ]; then
          echo "Passphrases do not match" >&2
          exit 1
        fi
      fi

      # plaintext lives in RAM only and is shredded however the script exits
      tmp=$(mktemp -p /dev/shm secret-edit.XXXXXX)
      trap 'shred -u "$tmp" 2>/dev/null || rm -f "$tmp"' EXIT
      trap 'exit 130' INT TERM

      gpg_args=(--batch --quiet --pinentry-mode loopback --passphrase-fd 3)

      if [ -e "$file" ]; then
        if ! gpg "''${gpg_args[@]}" --decrypt "$file" > "$tmp" 3< <(printf '%s' "$pass"); then
          echo "Decryption failed (wrong passphrase?); $file left untouched" >&2
          exit 1
        fi
        before=$(sha256sum < "$tmp")
      else
        before=new
      fi

      # no swap, shada, undo or backup files, so nothing is written to disk
      nvim -n -i NONE --cmd 'set nobackup nowritebackup noundofile' "$tmp"

      if [ "$(sha256sum < "$tmp")" = "$before" ]; then
        echo "No changes; $file left untouched" >&2
        exit 0
      fi

      gpg "''${gpg_args[@]}" --yes --symmetric --cipher-algo AES256 \
        --output "$file.new" "$tmp" 3< <(printf '%s' "$pass")
      mv -f "$file.new" "$file"
      echo "Encrypted $file" >&2
    '';
  };
in
{
  programs.gpg.enable = true;

  home.packages = [ secret-edit ];
}
