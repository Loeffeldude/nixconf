return {
  -- Disable indent animations
  {
    "nvim-mini/mini.indentscope",
    opts = {
      -- animation = false,  -- this was wrong
      draw = {
        -- Use this to disable the animation
        delay = 0,
        priority = 2,
      },
      symbol = "│",
      options = { try_as_border = true },
    },
  },
  -- Disable noice fancy UI
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Disable animations for windows/splits
  {
    "nvim-mini/mini.animate",
    enabled = false,
  },
}
