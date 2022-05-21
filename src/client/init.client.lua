local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)
local Klein = require(ReplicatedStorage.Common.KleinObject)

local a = Ref.new("world!")
local c = Ref.new(" This is a text!")
local b = "Hello " .. a .. c
Klein(Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui").Test, {Text = b})

wait(1)

a.Value = "universe!"

wait(1)

c.Value = " Thanks for waiting."