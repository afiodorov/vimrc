---@diagnostic disable: undefined-global

-- Function to toggle between Scala main and test files
_G.toggle_scala_test_file = function()
	local current_path = vim.fn.expand('%:p')
	local current_dir = vim.fn.expand('%:p:h')
	local base_name = vim.fn.expand('%:t:r') -- Name without extension
	local extension = ".scala"
	local test_suffixes = { "Spec", "Test" } -- Common test suffixes

	local target_path = nil

	-- Try switching from main to test
	if current_path:find("/src/main/scala/", 1, true) then
		local test_dir = current_dir:gsub("/src/main/scala/", "/src/test/scala/", 1)
		if test_dir == current_dir then
			vim.notify("Not in a standard src/main/scala structure", vim.log.levels.WARN)
			return
		end
		for _, suffix in ipairs(test_suffixes) do
			local potential_test_file = test_dir .. "/" .. base_name .. suffix .. extension
			if vim.fn.filereadable(potential_test_file) == 1 then
				target_path = potential_test_file
				break
			end
		end
		if not target_path then
			vim.notify(
				"Corresponding test file (.." ..
				table.concat(test_suffixes, "/") .. extension .. ") not found.",
				vim.log.levels.WARN)
			return
		end

		-- Try switching from test to main
	elseif current_path:find("/src/test/scala/", 1, true) then
		local main_dir = current_dir:gsub("/src/test/scala/", "/src/main/scala/", 1)
		if main_dir == current_dir then
			vim.notify("Not in a standard src/test/scala structure", vim.log.levels.WARN)
			return
		end
		local main_base_name = nil
		for _, suffix in ipairs(test_suffixes) do
			-- Check if base_name ends with the suffix
			if #base_name > #suffix and base_name:sub(- #suffix) == suffix then
				main_base_name = base_name:sub(1, - #suffix - 1)
				break
			end
		end

		if not main_base_name then
			vim.notify(
				"Test filename doesn't end with standard suffix (" ..
				table.concat(test_suffixes, "/") .. ").",
				vim.log.levels.WARN)
			return
		end

		local potential_main_file = main_dir .. "/" .. main_base_name .. extension
		if vim.fn.filereadable(potential_main_file) == 1 then
			target_path = potential_main_file
		else
			vim.notify("Corresponding main file (" .. main_base_name .. extension .. ") not found.",
				vim.log.levels.WARN)
			return
		end
	else
		vim.notify("File is not in src/main/scala or src/test/scala.", vim.log.levels.WARN)
		return
	end

	-- If a target path was found, edit it
	if target_path then
		vim.cmd('edit ' .. vim.fn.fnameescape(target_path))
	end
end

vim.api.nvim_set_keymap('n', '<leader>et', '<Cmd>lua _G.toggle_scala_test_file()<CR>',
	{ noremap = true, silent = true, desc = "Toggle Scala Test/Main File" })
