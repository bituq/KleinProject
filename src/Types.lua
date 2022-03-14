--!strict
export type DataPoint = {
	Value: any,
	Event: any,
	Destroy: () -> (),
	_name: any,
}

export type KleinObjectEntry = string | { [any]: any }

export type KleinObject = {
	[any]: any,
	GenerateTree: ({ [string]: any }) -> Instance,
}

local Type = {}

function Type.Named(name: string)
	local meta = newproxy(true)

	getmetatable(meta).__tostring = function()
		return name
	end

	return meta
end

return Type
