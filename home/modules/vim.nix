{ ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard.register = "unnamedplus";
    colorschemes.ayu = {
      enable = true;
    };
    globals.mapleader = " ";
    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
    autoCmd = [
      # Highlight on yank
      {
        event = [ "TextYankPost" ];
        pattern = [ "*" ];
        command = "silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=100}";
      }
    ];
    keymaps = [
      {
        key = "<leader>w";
        action = ":write<CR>";
      }
      {
        key = "<leader>e";
        action = "<cmd>CHADopen<CR>";
      }
      {
        key = "<leader>q";
        action = ":quit<CR>";
      }
      {
        key = "<c-k>";
        action = ":wincmd k<CR>";
        options = {
          silent = true;
        };
      }
      {
        key = "<c-j>";
        action = ":wincmd j<CR>";
        options = {
          silent = true;
        };
      }
      {
        key = "<c-h>";
        action = ":wincmd h<CR>";
        options = {
          silent = true;
        };
      }
      {
        key = "<c-l>";
        action = ":wincmd l<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
