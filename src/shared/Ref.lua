--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Type = require(ReplicatedStorage.Common.Types)

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

	function data.Changed(callback: (any) -> ()): CallbackConnection
		local handler = {}
		local ref = self
	
		function handler:Destroy()
			table.remove(ref._callbacks, table.find(ref._callbacks, callback))
		end
	
		table.insert(self._callbacks, callback)
	
		return handler
	end

	getmetatable(self).__newindex = function (_, index, value)
		rawset(data, index, value)

		-- 'Value' setter
		if index ~= "Value" then return end

		-- Create -value class if it is not already

		for _, callback in ipairs(self._callbacks) do
			callback(data.Value)
		end
	end

	getmetatable(self).__concat = function(left: any, right: any)
		local isLeft = rawequal(left, self)
		local newRef = Ref.new(isLeft and left.Value .. (Ref.Is(right) and right.Value or right) or (Ref.Is(left) and left.Value or left) .. right.Value)
	
		if isLeft and Ref.Is(right) then
			right.Changed(function (new)
				newRef.Value = data.Value .. new
			end)
		end

		if not isLeft and Ref.Is(left) then
			left.Changed(function (new)
				newRef.Value = new .. data.Value
			end)
		end

		data.Changed(function (new)
			newRef.Value = isLeft and new .. right or left .. new
		end)
	
		return newRef
	end

	getmetatable(self).__index = data

	getmetatable(self).__tostring = function ()
		return data.Value
	end

	data.Type = Type.Named("ref")

	return self
end

function Ref.Is(other: any)
	local success, isRef = pcall(function ()
		return tostring(other.Type) == "ref"
	end)
	return success and isRef
end

return Ref