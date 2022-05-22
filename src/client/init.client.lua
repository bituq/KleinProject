local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)
local Klein = require(ReplicatedStorage.Common.KleinObject)

local currentTime = Ref.new(0)

Klein("ScreenGui", {
	Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
	Klein("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Text = "Time Elapsed: " .. currentTime,
	})
})

local running = true

task.spawn(function ()
	while running do
		currentTime.Value += 1
		task.wait(1)
	end
end)

task.wait(5)
running = false