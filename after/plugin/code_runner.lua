require("code_runner").setup({
	filetype = {
		python = "python3 -u",
		typescript = "deno run",
		c = "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
	},
})
