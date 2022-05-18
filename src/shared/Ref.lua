--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Type = require(ReplicatedStorage.Common.Types)

type CallbackConnection = {
	Destroy: () -> ()
}

local Ref = {}
Ref.__index = Ref

function Ref.new(value: any)
	local data = {}
	local self = setmetatable(Ref, {
		__newindex = function (_, index, value)
			rawset(data, index, value)
	
			if index ~= "Value" then return end
	
			for _, callback in ipairs(data._callbacks) do
				callback(value, data["Value"])
			end
		end,
		__index = data
	})

	getmetatable(self).__concat = function(left: any, right: any)
		return left == self and data.Value .. right or left .. data.Value
	end

	data.Value = value

	self._callbacks = {}
	self.Type = Type.Named("Ref")

	return self
end

function Ref:Connect(callback: (any, any) -> ()): CallbackConnection
	local handler = {}
	local ref = self

	function handler:Destroy()
		table.remove(ref._callbacks, table.find(ref._callbacks, callback))
	end

	table.insert(self._callbacks, callback)

	return handler
end

return Ref