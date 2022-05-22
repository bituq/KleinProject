local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)

function Assign(listeners: table, object: Instance | table, key: any, value: any)

	-- The value is a ref
	if Ref.Is(value) then
		if listeners[key] then
			listeners[key]:Destroy()
		end

		listeners[key] = value.Changed(function (new)
			object[key] = Ref.Is(new) and new.Value or new
		end)

		object[key] = value.Value
		return
	end

	local success, hasProperty = pcall(function ()
		return object[key] == nil or object[key] ~= nil
	end)

	-- The given property exists on the object
	if success and hasProperty then
		object[key] = value
		return
	end

	-- The property does not exist on the object, so make the value a child
	if typeof(value) == "Instance" then
		value.Parent = object
		return
	end
end

function KleinObject(object: string | Instance, properties: table)
	local instance = (typeof(object) == "string") and Instance.new(object) or object
	local listeners = {}

	for key, value in pairs(properties) do
		if instance then
			Assign(listeners, instance, key, value)
		end
	end

	return instance
end

return KleinObject
