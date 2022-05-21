local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)

local a = Ref.new("Hello ")
local b = a .. "World!"

print(b.Value)

a.Value = "Goodbye "

print(b.Value)