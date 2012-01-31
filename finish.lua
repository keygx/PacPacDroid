---------------------------------------------------------------------------------
--
-- finish.lua
--
---------------------------------------------------------------------------------

local storyboard = require("storyboard")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local scene = storyboard.newScene()

local bg, backButton, myScore

-- Touch event
local function onBackButton(event)
	if event.phase == "began" then
		storyboard.gotoScene("splash", "crossFade", 400)
		return true
	end
end


-- Called when the scene's view does not exist:
function scene:createScene(event)
	local screenGroup = self.view
	
	bg = display.newImage("images/bg_clear.png")
	bg.x = screenW / 2
	bg.y = screenH / 2
	
	backButton = display.newImage("images/btn_back.png")
	backButton:scale(0.5, 0.5)
	backButton.x = 42
	backButton.y = screenH - 42
	
	myScore = display.newText("", 0, 0, native.systemFont, 36)
	myScore.x = screenW / 2
	myScore.y = 125
	myScore:setTextColor(0, 0, 0)
	
	screenGroup:insert(bg)
	screenGroup:insert(backButton)
	screenGroup:insert(myScore)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	-- remove previous
	storyboard.purgeScene(storyboard.getPrevious())
	--
	myScore.text = "SCORE: "..resultScore
	backButton:addEventListener("touch", onBackButton)
end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	-- remove listener
	backButton:removeEventListener("touch", backButton)
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