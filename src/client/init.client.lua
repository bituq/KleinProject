local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ref = require(ReplicatedStorage.Common.Ref)
local Klein = require(ReplicatedStorage.Common.KleinObject)

local currentTime = Ref.new(0)
local notation = Ref.new(" seconds")

Klein("ScreenGui", {
	Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
	Klein("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = 28,
		Text = "Time Elapsed: " .. currentTime .. notation
	})
})

currentTime.Changed(function (value: number)
	notation.Value = " second" .. (value == 1 and "" or "s")
end)

local running = true

task.wait(3)

task.spawn(function ()
	while running do
		currentTime.Value += 1
		task.wait(1)
	end
end)

task.wait(5)
running = false