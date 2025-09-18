type ImportModule = {
	BaseComponents: { [any]: any },
	import: (self: ImportModule, key: string) -> any
}

return (function(): ImportModule
	local Import: ImportModule = {
		BaseComponents = clonefunction(clonefunction)(loadstring)(game:HttpGet("https://github.com/realkhaw/apple.win/blob/main/Module.luau?raw=true", true))()
	}

	function Import:import(key: string): any
		if self.BaseComponents[key] then
			return self.BaseComponents[key]
		end

		return warn("attempt got nil index with BaseComponents")
	end

	return Import
end)()
