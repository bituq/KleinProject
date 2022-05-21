local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)

local a = Ref.new("Hello ")
local c = Ref.new("World")
local b = "Hello and " .. a .. c

print(a.Value)

a.Value = "Goodbye "

print(b.Value)

a.Value = "Goodmorning "
c.Value = "Universe"

print(b.Value)