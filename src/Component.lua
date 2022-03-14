--!strict
local Types = require(script.Parent.Types)
local Data = require(script.Parent.ComponentData)

local Component = {}
Component.__index = Component
Component.Type = Types.Named("Component")

function Component.new(name: string?, data: { [string]: any }?)
	local self = setmetatable({}, Component)

	self.Name = name
	self.Data = Data.new()
	self.KleinObject = nil
	self.Instance = nil

	if data then
		for key, value in pairs(data) do
			self.Data[key] = value
		end
	end

	return self
end

function Component:Get(name: string): any
	return self.Data[name].Value
end

function Component:Set(name: string, value: any)
	self.Data[name] = value
end

function Component:Bind(name: string)
	return self.Data[name]
end

function Component:Clone()
	local clone = self:GetInstance()
	return clone
end

function Component:Mount(parent: Instance): Instance
	self.Instance = self:GetInstance()
	self.Instance.Parent = parent
	self:AfterMount()
	return self.Instance
end

function Component:GetInstance(): Instance
	return self.KleinObject:GenerateTree()
end

function Component:Template(kleinObject: { [any]: any })
	kleinObject:SetComponent(self)
	self.KleinObject = kleinObject
end

function Component:Destroy()
	self:BeforeDestroy()

	for _, data in pairs(self.Data._data) do
		data:Destroy()
	end

	self.Instance:Destroy()
end

function Component:BeforeDestroy() end

function Component:AfterMount() end

return Component
