return {
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        config = function()
            require("nordic").setup({
                transparent_bg = {
                    bg = true
                }-- Enable this to disable setting the background color
            })
            require("nordic").load()
        end
    }
}
