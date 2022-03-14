local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(script.Parent.Types)
local Signal = require(ReplicatedStorage.Common.signal)

local Data = {}

function Data.new()
	local self = setmetatable({}, Data)

	rawset(self, "_data", {})

	return self
end

function Data:__index(key: any)
	return rawget(self, "_data")[key]
end

function Data:__newindex(key: any, value: any)
	if value == nil then
		if self._data[key] then
			self._data[key]:Destroy()
		end

		self._data[key] = nil
		return
	end

	if not self._data[key] then
		local event = Signal.new()

		local destroy = function()
			event:Destroy()
		end

		event:Connect(function(newValue)
			self._data[key].Value = newValue
		end)

		local dataPoint: Types.DataPoint = {
			Event = event,
			Destroy = destroy,
			Value = nil,
			_name = key,
			Type = Types.Named("DataPoint"),
		}

		self._data[key] = dataPoint
	end

	self._data[key].Event:Fire(value)
end

return Data
