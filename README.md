# Klein
A declarative UI Library made for Roblox. Klein strives to be lightweight, asynchronous, and intuitive.
This project is currently in very early stages. **It is unstable, so do not use it in your projects yet.**

### Why Klein?
Currently, the most popular UI library out there is [Roact](https://roblox.github.io/roact/). However, Roact is not asynchronous - which is fine for smaller projects,
but may cause performance issues in projects which large component trees. Klein attempts to solve this.

Furthermore, Klein tries to make mutable state more intuitive. It is founded on the principle that programmers should expect state to be mutated from the get-go without special accessors.

### What to expect?
This project is in an early stage. It is nowhere near production-ready, and currently serves as a proof of concept.
Roact is a perfectly fine UI library for most use-cases. But Klein tries to achieve things in a different way, which may be useful to some people.


# Syntax
#### An UI object is created as a *KleinObject*.
```lua
local Klein = require(Klein.KleinObject)

Klein("TextLabel") -- This serves as a template for a Textlabel without any properties.
```
#### In order to use the TextLabel, we must create a component.
```lua
local Klein = require(Klein.KleinObject)
local Component = require(Klein.Component)

-- We create a Component called Clock
local Clock = Component.new("Clock")

-- We call the Component's Template method, which requires a KleinObject (such as the TextLabel).
Clock:Template(Klein("TextLabel"))

-- Mount the Clock component. This will simply place a TextLabel in the workspace.
Clock:Mount(workspace)
```
#### Mutable state can also be added to a component.
```lua
local Clock = Component.new("Clock", {
  currentTime = 0,
})
```
#### We can change our TextLabel for the text to display the currentTime property.
```lua
Clock:Template(Klein("TextLabel", {
  Text = Clock.Data.currentTime -- The Text property will now update asynchronously whenever currentTime updates.
}))
```
#### String concatenation
```lua
Clock:Template(Klein("TextLabel", {
  Text = "Elapsed time: {{currentTime}}" -- Display the current time. This approach may change significantly in the future.
}))
```
#### Component lifecycles
```lua
-- This method runs after the component has mounted.
function Clock:AfterMount()
  self.running  = true
  
  -- Add 1 to the current time with each second.
  task.spawn(function()
    while self.running do
      self.Data.currentTime = self.Data.currentTime.Value + 1
      task.wait(1)
    end
  end)
end

function Clock:BeforeDestroy()
  self.running = false
end

-- Current time will update to the count of 5, after which the loop in AfterMount ends.
Clock:Mount(workspace)
task.wait(5)
Clock:Destroy()
```
#### Children
```lua
-- Our Component isn't visible yet to the user, since it's in workspace. We must put it in a screenGui first.
local Players = game:GetService("Players")
local Klein = require(Klein.KleinObject)
local Component = require(Klein.Component)
local Clock = Component.new("Clock" {
  currentTime = 1
})

Clock:Template(Klein("ScreenGui", {
  Klein("TextLabel", {
    Text = "Elapsed time: {{currentTime}}"
  }) -- We can add a child to the screengui by simply treating a KleinObject as a property of the screengui.
}))

-- Mount the screengui to PlayerGui with a textlabel as its child.
Clock:Mount(Players.LocalPlayer.PlayerGui)
```
