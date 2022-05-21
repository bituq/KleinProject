local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)

local a = Ref.new("Hello ")
local b = a .. "world"

print(a.Value)

print(b)
print(b.Value)