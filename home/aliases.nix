{ lib, ... }: {
    home.shellAliases = {
      cat = "bat";
      cp = "cp -iv";
      dc = "docker compose";
      ln = "ln -v";
      ls = "exa";
      mv = "mv -iv";
      n = "lvim .";
      rm = "rm -v";
      S = "sudo systemctl";
      s = "sudo";
      Ss = "sudo systemctl status";
      Su = "systemctl --user";
      g = "lazygit";
      d = "lazydocker";
    };
}
