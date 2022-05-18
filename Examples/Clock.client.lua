local Players = game:GetService("Players")
--local Klein = require(script.Parent.Klein.KleinObject)
--local Component = require(script.Parent.Klein.Component)

--local currentTime = 5

-- local clock = Component.new(Klein("ScreenGui", {
-- 	Klein("TextLabel", {
-- 		Size = UDim2.new(1, 0, 1 ,0),
-- 		Text = "Time Elapsed" .. function() return currentTime end,
-- 	})
-- })
-- )

-- local Clock = Component.new("Clock", {
-- 	currentTime = 0,
-- })

-- Clock:Template(Klein("ScreenGui", {
-- 	TimeLabel = Klein("TextLabel", {
-- 		Size = UDim2.new(1, 0, 1, 0),
-- 		Text = "Time Elapsed: {{currentTime}}",
-- 	}),
-- }))

-- function Clock:AfterMount()
-- 	self.running = true

-- 	task.spawn(function()
-- 		while self.running do
-- 			self.Data.currentTime = self.Data.currentTime.Value + 1

-- 			task.wait(1)
-- 		end
-- 	end)
-- end

-- function Clock:BeforeDestroy()
-- 	self.running = false
-- end

-- Clock:Mount(Players.LocalPlayer.PlayerGui)

-- task.wait(5)
-- Clock:Destroy()
