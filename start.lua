---------------------------------------------------------------------------------
--
-- start.lua
--
---------------------------------------------------------------------------------

local storyboard = require("storyboard")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local scene = storyboard.newScene()

local bg

-- Touch event
local onTouch = function(event)
	if event.phase == "began" then
		storyboard.gotoScene("game", "crossFade", 400)
		return true
	end
end


-- Called when the scene's view does not exist:
function scene:createScene(event)
	local screenGroup = self.view
	
	bg = display.newImage("images/bg_start.png")
	bg.x = screenW / 2
	bg.y = screenH / 2
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	-- remove previous
	storyboard.purgeScene(storyboard.getPrevious())
	-- add listener
	bg:addEventListener("touch", onTouch)
end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	-- remove listener
	bg:removeEventListener("touch", bg)
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene(event)
	--
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener("createScene", scene)

scene:addEventListener("enterScene", scene)

scene:addEventListener("exitScene", scene)

scene:addEventListener("destroyScene", scene)

---------------------------------------------------------------------------------

return scene