local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)
local Klein = require(ReplicatedStorage.Common.KleinObject)

local a = Ref.new("Hello ")
local b = a .. "world!"
Klein(Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui").Test, {Something = Instance.new("TextLabel")})

wait(3)

a.Value = "universe!"