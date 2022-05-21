--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

type CallbackConnection = {
	Destroy: () -> ()
}

local Ref = {}
Ref.__index = Ref

function Ref.new(value: any)
	local self = newproxy(true)
	local data = {}

	data._callbacks = {}
	data.Value = value

	getmetatable(self).__newindex = function (_, index, value)
		rawset(data, index, value)

		-- 'Value' setter
		if index ~= "Value" then return end

		for _, callback in ipairs(self._callbacks) do
			callback(value, data.Value)
		end
	end

	getmetatable(self).__concat = function(left: any, right: any)
		local isLeft = left.Value
		local newRef = Ref.new(isLeft and left.Value .. right or left .. right.Value)
	
		-- Ref.Changed(self, function (_, new)
		-- 	rawset(newRef, 'Value', isLeft and new .. right or left .. new)
		-- end)
	
		print(newRef)
	
		return newRef
	end

	getmetatable(self).__index = data

	function self.Changed(callback: (any, any) -> ()): CallbackConnection
		local handler = {}
		local ref = self
	
		function handler:Destroy()
			table.remove(ref._callbacks, table.find(ref._callbacks, callback))
		end
	
		table.insert(self._callbacks, callback)
	
		return handler
	end

	return self
end

return Ref