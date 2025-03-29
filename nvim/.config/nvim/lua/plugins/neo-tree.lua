return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = true,
        hide_gitignored = true,
        never_show = {
          ".git",
          ".DS_Store",
          "thumbs.db",
          ".idea",
          ".vscode",
          ".venv",
        },
      },
    },
  },
}
