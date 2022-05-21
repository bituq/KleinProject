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
	local self; self = setmetatable(Ref, {
		__newindex = function (_, index, value)
			rawset(data, index, value)
	
			-- 'Value' getter
			if index ~= "Value" then return end

			for _, callback in ipairs(self._callbacks) do
				callback(value, data["Value"])
			end
		end,
		__index = data,
	})

	self._callbacks = {}
	self.Type = Type.Named("Ref")

	data.Value = value

	getmetatable(self).__concat = function(left: any, right: any)
		local isLeft = left == self
		local newRef = Ref.new(isLeft and data.Value .. right or left .. data.Value)

		self:Changed(function (_, new)
			rawset(newRef, 'Value', isLeft and new .. right or left .. new)
		end)

		return newRef
	end

	return self
end

function Ref:Changed(callback: (any, any) -> ()): CallbackConnection
	local handler = {}
	local ref = self

	function handler:Destroy()
		table.remove(ref._callbacks, table.find(ref._callbacks, callback))
	end

	table.insert(self._callbacks, callback)

	return handler
end

return Ref