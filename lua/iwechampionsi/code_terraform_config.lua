-- Code: Terraform `self` type inference
--
-- Automatically inserts:
--
-- from typing import TYPE_CHECKING, cast
--
-- if TYPE_CHECKING:
--     self = Fabricator()
--
-- Resolution order:
--
-- 1. Persistent per-script cache
-- 2. Generated __builtins__.pyi inference
-- 3. Manual prompt with class-name completion
--
-- __builtins__.pyi itself is parsed only once per Neovim session unless
-- its modification time or size changes.

local cache_path = vim.fn.stdpath("state") .. "/codeterraform-self-types.json"

---------------------------------------------------------------------------
-- Runtime caches
---------------------------------------------------------------------------

local builtin_cache = {}

_G.CodeTerraformSelfType = _G.CodeTerraformSelfType or {
	completion_items = {},
}

---------------------------------------------------------------------------
-- Completion
---------------------------------------------------------------------------

function _G.CodeTerraformSelfType.complete(arglead, _, _)
	local result = {}
	local lead = arglead:lower()

	for _, class_name in ipairs(_G.CodeTerraformSelfType.completion_items or {}) do
		if lead == "" or class_name:lower():find(lead, 1, true) == 1 then
			result[#result + 1] = class_name
		end
	end

	return result
end

---------------------------------------------------------------------------
-- General helpers
---------------------------------------------------------------------------

local function normalize_name(name)
	return name:gsub("[^%w]", ""):lower()
end

local function get_scripts_dir(bufnr)
	local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))

	return path:match("^(.-_scripts)/")
end

local function get_script_path(bufnr)
	return vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
end

local function get_builtin_path(bufnr)
	local scripts_dir = get_scripts_dir(bufnr)

	if not scripts_dir then
		return nil
	end

	return scripts_dir .. "/__builtins__.pyi"
end

---------------------------------------------------------------------------
-- Persistent per-stub type cache
--
-- Cache keys use only the filename stub:
--
-- fabricator_1.py    -> fabricator
-- fabricator_12.py   -> fabricator
-- pressure_1.py      -> pressure
-- bio_exchange_3.py  -> bio_exchange
--
-- This lets every instance of the same machine type share one cached
-- resolution, including instances from different saves.
---------------------------------------------------------------------------

local function get_script_stub(bufnr)
	local path = get_script_path(bufnr)
	local filename = vim.fn.fnamemodify(path, ":t:r")

	-- Remove only a trailing generated instance number.
	--
	-- fabricator_1   -> fabricator
	-- pressure_12    -> pressure
	-- bio_exchange_3 -> bio_exchange
	--
	-- Non-numbered names remain unchanged:
	--
	-- pressure_sensor -> pressure_sensor
	return filename:gsub("_%d+$", "")
end

local function load_type_cache()
	if vim.fn.filereadable(cache_path) ~= 1 then
		return {}
	end

	local lines = vim.fn.readfile(cache_path)

	if #lines == 0 then
		return {}
	end

	local ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))

	if not ok or type(decoded) ~= "table" then
		vim.notify("Failed to read Code: Terraform type cache", vim.log.levels.WARN)

		return {}
	end

	return decoded
end

local type_cache = load_type_cache()

local function save_type_cache()
	vim.fn.mkdir(vim.fn.fnamemodify(cache_path, ":h"), "p")

	local ok, encoded = pcall(vim.json.encode, type_cache)

	if not ok then
		vim.notify("Failed to encode Code: Terraform type cache", vim.log.levels.ERROR)

		return
	end

	vim.fn.writefile({ encoded }, cache_path)
end

local function get_cached_type(bufnr)
	local stub = get_script_stub(bufnr)

	return type_cache[stub]
end

local function cache_type(bufnr, type_name)
	local stub = get_script_stub(bufnr)

	if type_cache[stub] == type_name then
		return
	end

	type_cache[stub] = type_name
	save_type_cache()
end

local function remove_cached_type(bufnr)
	local stub = get_script_stub(bufnr)

	if type_cache[stub] == nil then
		vim.notify("No cached Code: Terraform type for " .. stub, vim.log.levels.INFO)

		return
	end

	local old_type = type_cache[stub]

	type_cache[stub] = nil
	save_type_cache()

	vim.notify("Removed cached Code: Terraform type: " .. stub .. " -> " .. old_type, vim.log.levels.INFO)
end

---------------------------------------------------------------------------
-- Generated builtin parsing
---------------------------------------------------------------------------

local function parse_builtin_file(path)
	local lines = vim.fn.readfile(path)

	local classes = {}
	local component_classes = {}
	local machine_types = {}
	local exact_components = {}

	local in_machine_types = false

	for _, line in ipairs(lines) do
		------------------------------------------------------------------
		-- All classes
		------------------------------------------------------------------

		local class_name = line:match("^class%s+([%w_]+)")

		if class_name then
			classes[normalize_name(class_name)] = class_name
		end

		------------------------------------------------------------------
		-- Component subclasses
		------------------------------------------------------------------

		local component_class = line:match("^class%s+([%w_]+)%s*%(%s*Component%s*%)%s*:")

		if component_class then
			component_classes[#component_classes + 1] = component_class
		end

		------------------------------------------------------------------
		-- MachineTypeId
		------------------------------------------------------------------

		if line:match("^MachineTypeId%s*=%s*Literal%[") then
			in_machine_types = true
		elseif in_machine_types then
			if line:match("^%]") then
				in_machine_types = false
			else
				local machine_type = line:match('^%s*"([^"]+)"')

				if machine_type then
					machine_types[#machine_types + 1] = machine_type
				end
			end
		end

		------------------------------------------------------------------
		-- Exact get_component() overloads
		--
		-- Example:
		--
		-- def get_component(name: Literal["bio_exchange_1"])
		--     -> BioExchange | None: ...
		------------------------------------------------------------------

		local component_id, return_type =
			line:match('^def%s+get_component%(%s*name:%s*Literal%["([^"]+)"%]%s*%)%s*%-%>%s*([%w_]+)')

		if component_id and return_type then
			exact_components[component_id] = return_type
		end
	end

	table.sort(component_classes)

	return {
		classes = classes,
		component_classes = component_classes,
		machine_types = machine_types,
		exact_components = exact_components,
	}
end

---------------------------------------------------------------------------
-- Cached generated-builtin parser
--
-- The large __builtins__.pyi is not repeatedly scanned.
--
-- Cache validity is based on:
--
--     modification time
--     file size
--
-- If the game regenerates the stub, the cache automatically refreshes.
---------------------------------------------------------------------------

local function get_parsed_builtin(bufnr)
	local path = get_builtin_path(bufnr)

	if not path then
		return nil
	end

	local stat = vim.uv.fs_stat(path)

	if not stat then
		return nil
	end

	local cached = builtin_cache[path]

	local mtime_sec = stat.mtime.sec
	local mtime_nsec = stat.mtime.nsec
	local size = stat.size

	if cached and cached.mtime_sec == mtime_sec and cached.mtime_nsec == mtime_nsec and cached.size == size then
		return cached.parsed
	end

	local parsed = parse_builtin_file(path)

	builtin_cache[path] = {
		mtime_sec = mtime_sec,
		mtime_nsec = mtime_nsec,
		size = size,
		parsed = parsed,
	}

	return parsed
end

---------------------------------------------------------------------------
-- Automatic type inference
---------------------------------------------------------------------------

local function infer_codeterraform_type(bufnr, parsed)
	local path = get_script_path(bufnr)
	local component_id = vim.fn.fnamemodify(path, ":t:r")

	----------------------------------------------------------------------
	-- 1. Exact generated get_component() overload
	--
	-- bio_exchange_1.py
	--     ->
	-- get_component("bio_exchange_1")
	--     ->
	-- BioExchange
	----------------------------------------------------------------------

	local exact = parsed.exact_components[component_id]

	if exact and exact ~= "Component" then
		return exact
	end

	----------------------------------------------------------------------
	-- Strip numeric instance suffix.
	--
	-- fabricator_1 -> fabricator
	-- pressure_3   -> pressure
	-- bio_lab_2    -> bio_lab
	----------------------------------------------------------------------

	local stem = component_id:gsub("_%d+$", "")

	----------------------------------------------------------------------
	-- 2. Exact MachineTypeId match
	----------------------------------------------------------------------

	for _, machine_type in ipairs(parsed.machine_types) do
		if machine_type == stem then
			local class_name = parsed.classes[normalize_name(machine_type)]

			if class_name then
				return class_name
			end
		end
	end

	----------------------------------------------------------------------
	-- 3. Abbreviated filename prefix
	--
	-- pressure_1
	--     ->
	-- pressure
	--
	-- possible generated types:
	--
	-- pressure_generator
	-- pressure_sensor
	--
	-- pressure_sensor is already an exact singleton component ID, so it
	-- is discarded. PressureGenerator remains.
	----------------------------------------------------------------------

	local candidates = {}

	for _, machine_type in ipairs(parsed.machine_types) do
		if machine_type:sub(1, #stem + 1) == stem .. "_" then
			if not parsed.exact_components[machine_type] then
				local class_name = parsed.classes[normalize_name(machine_type)]

				if class_name then
					candidates[#candidates + 1] = class_name
				end
			end
		end
	end

	if #candidates == 1 then
		return candidates[1]
	end

	return nil
end

---------------------------------------------------------------------------
-- Manual fallback
---------------------------------------------------------------------------

local function ask_codeterraform_type(bufnr, parsed, callback)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local path = get_script_path(bufnr)
	local component_id = vim.fn.fnamemodify(path, ":t:r")

	_G.CodeTerraformSelfType.completion_items = parsed.component_classes

	vim.ui.input({
		prompt = "Could not infer type for " .. component_id .. ". Class: ",
		completion = "customlist,v:lua.CodeTerraformSelfType.complete",
		scope = "buffer",
	}, function(type_name)
		_G.CodeTerraformSelfType.completion_items = {}

		if type_name == nil then
			return
		end

		type_name = vim.trim(type_name)

		if type_name == "" then
			return
		end

		if not type_name:match("^[%a_][%w_]*$") then
			vim.notify("Invalid Python class name: " .. type_name, vim.log.levels.ERROR)

			return
		end

		local known = false

		for _, class_name in ipairs(parsed.component_classes) do
			if class_name == type_name then
				known = true
				break
			end
		end

		if not known then
			vim.notify(
				"Class " .. type_name .. " was not found among generated Component classes; using it anyway",
				vim.log.levels.WARN
			)
		end

		callback(type_name)
	end)
end

---------------------------------------------------------------------------
-- Type resolution
---------------------------------------------------------------------------

local function resolve_codeterraform_type(bufnr, callback)
	----------------------------------------------------------------------
	-- 1. Persistent exact-file cache
	--
	-- This is the normal fast path.
	----------------------------------------------------------------------

	local cached = get_cached_type(bufnr)

	if cached then
		callback(cached)
		return
	end

	----------------------------------------------------------------------
	-- 2. Parse generated builtin.
	--
	-- get_parsed_builtin() itself is cached, so the giant .pyi is read
	-- only once unless the game regenerates it.
	----------------------------------------------------------------------

	local parsed = get_parsed_builtin(bufnr)

	if not parsed then
		vim.notify("Could not read Code: Terraform __builtins__.pyi", vim.log.levels.WARN)

		return
	end

	----------------------------------------------------------------------
	-- 3. Automatic inference
	----------------------------------------------------------------------

	local inferred = infer_codeterraform_type(bufnr, parsed)

	if inferred then
		cache_type(bufnr, inferred)
		callback(inferred)
		return
	end

	----------------------------------------------------------------------
	-- 4. Manual fallback
	--
	-- Manual answers are cached exactly like automatic answers.
	----------------------------------------------------------------------

	ask_codeterraform_type(bufnr, parsed, function(type_name)
		cache_type(bufnr, type_name)
		callback(type_name)
	end)
end

---------------------------------------------------------------------------
-- Existing self declaration detection
---------------------------------------------------------------------------

local function has_codeterraform_self_type(bufnr)
	local line_count = vim.api.nvim_buf_line_count(bufnr)

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(line_count, 40), false)

	for _, line in ipairs(lines) do
		if line:match("^%s*self%s*=%s*[%a_][%w_]*%(%s*%)%s*$") then
			return true
		end
	end

	return false
end

---------------------------------------------------------------------------
-- Insert self declaration
---------------------------------------------------------------------------

local function add_codeterraform_self_type(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local path = get_script_path(bufnr)

	----------------------------------------------------------------------
	-- Only Code: Terraform Python scripts
	----------------------------------------------------------------------

	if not path:match("_scripts/") then
		return
	end

	if not path:match("%.py$") then
		return
	end

	----------------------------------------------------------------------
	-- Ignore support/generated files
	----------------------------------------------------------------------

	if path:match("_scripts/lib/") then
		return
	end

	if path:match("/user_stubs%.py$") then
		return
	end

	if path:match("/__builtins__%.py$") then
		return
	end

	----------------------------------------------------------------------
	-- Already typed
	----------------------------------------------------------------------

	if has_codeterraform_self_type(bufnr) then
		return
	end

	----------------------------------------------------------------------
	-- Resolve type
	----------------------------------------------------------------------

	resolve_codeterraform_type(bufnr, function(type_name)
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		-- Protect against duplicate async execution.
		if has_codeterraform_self_type(bufnr) then
			return
		end

		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, {
			"from typing import TYPE_CHECKING, cast",
			"",
			"if TYPE_CHECKING:",
			"    self = " .. type_name .. "()",
			"",
		})

		vim.notify("Code: Terraform self type: " .. type_name, vim.log.levels.INFO)
	end)
end

---------------------------------------------------------------------------
-- Commands
---------------------------------------------------------------------------

-- Forget only the current script's cached type.
vim.api.nvim_create_user_command("CodeTerraformForgetType", function()
	remove_cached_type(vim.api.nvim_get_current_buf())
end, {
	desc = "Forget cached Code: Terraform self type for current script",
})

-- Display the persistent cache.
vim.api.nvim_create_user_command("CodeTerraformTypeCache", function()
	print(vim.inspect(type_cache))
end, {
	desc = "Show cached Code: Terraform self types",
})

-- Clear every persistent script-type entry.
vim.api.nvim_create_user_command("CodeTerraformClearTypeCache", function()
	type_cache = {}
	save_type_cache()

	vim.notify("Cleared Code: Terraform self type cache", vim.log.levels.INFO)
end, {
	desc = "Clear all cached Code: Terraform self types",
})

-- Force re-reading __builtins__.pyi during this Neovim session.
--
-- Normally unnecessary because mtime/size changes invalidate it
-- automatically.
vim.api.nvim_create_user_command("CodeTerraformClearBuiltinCache", function()
	builtin_cache = {}

	vim.notify("Cleared Code: Terraform builtin parse cache", vim.log.levels.INFO)
end, {
	desc = "Clear Code: Terraform parsed builtin cache",
})

---------------------------------------------------------------------------
-- Automatic execution
---------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.py",
	callback = function(args)
		add_codeterraform_self_type(args.buf)
	end,
	desc = "Infer Code: Terraform self type",
})
