return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}

            vim.list_extend(opts.ensure_installed, {
                "markdown",
                "markdown_inline",
                "tsx",
                "typescript",
            })

            vim.filetype.add({
                extension = {
                    mdx = "mdx",
                },
            })

            vim.treesitter.language.register("markdown", "mdx")

            return opts
        end,
    },
}
