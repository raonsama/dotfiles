return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          -- Additional Intelephense settings can go here
          settings = {
            intelephense = {
              telemetry = { enabled = false },
            },
          },
        },

        lua_ls = false,

        tailwindcss = {
          filetypes_exclude = { "markdown", "php" },
          filetypes_include = {},
          -- additional settings for the server, e.g:
          settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          },
        },

      },
    },
  },
}
