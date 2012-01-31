---------------------------------------------------------------------------------
--
-- splash.lua
--
---------------------------------------------------------------------------------

local storyboard = require("storyboard")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local scene = storyboard.newScene()

local bg

-- Touch event
local gotoTop = function(event)
	storyboard.gotoScene("start", "crossFade", 400)
end


-- Called when the scene's view does not exist:
function scene:createScene(event)
	local screenGroup = self.view
	
	bg = display.newImage("images/splash.png")
	bg.x = screenW / 2
	bg.y = screenH / 2
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	-- remove previous
	storyboard.purgeScene(storyboard.getPrevious())
	-- add listener
	timer.performWithDelay( 1500, gotoTop, 1 )
end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	-- remove listener
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