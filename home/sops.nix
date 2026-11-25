{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.sops-nix.homeModules.sops ];

  # secrets kept encrypted in this repository (secrets/secrets.yaml; who can
  # decrypt is in .sops.yaml) and decrypted at login and on every switch by the
  # sops-nix user service, into the runtime folder (in memory, gone at logout),
  # linked from ~/.config/sops-nix/secrets. a module names what it needs with
  # sops.secrets."<path>" and reads it from config.sops.secrets."<path>".path, or
  # puts config.sops.placeholder."<path>" in a sops.templates file (home/aoide.nix)
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;

    # this machine's age key, where the sops command looks for it too. made once
    # with `age-keygen -o ~/.config/sops/age/keys.txt`; not in this repository,
    # so back it up: without it the secrets can't be read or edited
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };

  # `sops secrets/secrets.yaml` in ~/.nixos opens the secrets decrypted in $EDITOR
  # and encrypts them again on save
  home.packages = with pkgs; [
    age
    sops
  ];
}
