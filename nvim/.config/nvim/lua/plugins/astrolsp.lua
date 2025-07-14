---@type LazySpec
return {
  "AstroNvim/astrolsp",
  -- use a function to override options
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    local lsp_util = require "lspconfig.util"

    -- Register omnisharp
    opts.servers = opts.servers or {}
    vim.list_extend(opts.servers, { "omnisharp" })

    -- Extend omnisharp config
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      omnisharp = {
        cmd = {
          vim.fn.stdpath "data" .. "/mason/packages/omnisharp/OmniSharp",
          "-z",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
          "--encoding",
          "utf-8",
          "FormattingOptions:EnableEditorConfigSupport=true",
          "Sdk:IncludePrereleases=true",
        },
        filetypes = { "cs", "vb" },
        root_dir = lsp_util.root_pattern("*.sln", "*.csproj", ".git"),
      },
    })
  end,
}
