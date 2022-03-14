--!strict
local Types = require(script.Parent.Types)
local KleinObject = {}
KleinObject.__index = KleinObject
KleinObject.Type = Types.Named("KleinObject")

function CheckType(thing: { [any]: any }, typeName: string): boolean
	local success, result = pcall(function()
		return tostring(thing.Type) == typeName
	end)

	if not success then
		return success
	end

	return result
end

function IsComponent(thing: { [any]: any })
	return CheckType(thing, "Component")
end

function IsKleinObject(thing: { [any]: any })
	return CheckType(thing, "KleinObject")
end

function new(instance: Types.KleinObjectEntry?, properties: { [string]: any }?)
	local self = setmetatable({}, KleinObject)

	if instance then
		if typeof(instance) == "string" then
			-- It's a property
			local isValid, result = pcall(Instance.new, instance)
			assert(isValid, instance .. " is not a valid instance type.")
			self.Instance = result
		elseif IsComponent(instance) or IsKleinObject(instance) then
			-- It's a component or KleinObject
			if tostring(instance.Type) == "Component" and properties then
				for propKey, _ in pairs(instance.Data) do
					if not properties[propKey] then
						continue
					end
					instance.Data[propKey] = properties[propKey]
					properties[propKey] = nil
				end
			end
			self.Instance = instance
		end
	end

	self.Properties = properties or {}

	-- Expected to be injected by the component using :SetComponent before :GenerateTree is called.
	self.Component = nil

	return self
end

function KleinObject:Clone()
	return self:GenerateTree()
end

function KleinObject:GenerateTree(): Instance
	local clone = self.Instance:Clone()

	for propertyName, propertyValue in pairs(self.Properties) do
		local canAssignProp, reason = pcall(KleinObject.SetProperty, self, clone, propertyName, propertyValue)

		if canAssignProp then
			continue
		end

		if IsComponent(propertyValue) or IsKleinObject(propertyValue) then
			if IsKleinObject(propertyValue) then
				propertyValue:SetComponent(self.Component)
			end

			propertyValue = propertyValue:Clone()
			propertyValue.Parent = clone

			if propertyName then
				propertyValue.Name = propertyName
			end
			continue
		end

		if IsComponent(self.Instance) then
			if self.Instance.Data[propertyName] then
				self.Instance.Data[propertyName] = propertyValue
				continue
			end
		end

		warn('"' .. propertyName .. '" is not a valid property of ' .. typeof(clone) .. ".")
		warn(reason)
	end

	return clone
end

function KleinObject:SetComponent(component: { [any]: any })
	self.Component = component
end

function KleinObject:SetProperty(instance: Instance, propertyName: string, propertyValue: any)
	if typeof(propertyValue) == "string" then
		propertyValue = self:LinkString(instance, propertyName, propertyValue)
	elseif CheckType(propertyValue, "DataPoint") then
		self:Link(instance, propertyValue._name, propertyName)
		return
	end

	instance[propertyName] = propertyValue
end

function KleinObject:Link(instance: Instance, dataName: string, propertyName: string)
	if not self.Component then
		return
	end

	local dataPoint: Types.DataPoint = self.Component.Data[dataName]

	dataPoint.Event:Connect(function(value: any)
		instance[propertyName] = value
	end)

	instance[propertyName] = dataPoint.Value
end

function KleinObject:LinkString(instance: Instance, propertyName: string, s: string): string
	if not self.Component then
		return s
	end

	local varName = string.match(s, "{{(%w+)}}")
	local dataPoint: Types.DataPoint = self.Component.Data[varName]

	if not dataPoint then
		return s
	end

	local function getString(value: any): string
		return string.gsub(s, "{{%w+}}", tostring(value))
	end

	dataPoint.Event:Connect(function(value: any)
		instance[propertyName] = getString(value)
	end)

	return getString(dataPoint.Value)
end

return function(instance: Types.KleinObjectEntry?, properties: { [string]: any }?)
	local returned = new(instance, properties)
	return returned
end
