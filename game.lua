---------------------------------------------------------------------------------
--
-- game.lua
--
---------------------------------------------------------------------------------

local storyboard = require("storyboard")
local physics = require("physics")
local movieclip = require("movieclip")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local scene = storyboard.newScene()

local bg, timeIcon, currentTime, scoreIcon, currentScore, lifeIcon, currentLife
local player, leftButton, rightButton
local backButton, myScore, overlayRect, title

local untouch = 30
local delay

local isPlay, timeLimit, score, life, timeCount
local itemGroup
local mainTimer

---------------------------------------------------------------
-- LISTENERS
---------------------------------------------------------------

--[[ MOVE LEFT ]]--
local moveLeft = function(event)
	if event.phase == "began" then
		leftButton:play{startFrame=1, endFrame=2, loop=1, remove=false}
	elseif event.phase == "ended" then
		leftButton:play{startFrame=2, endFrame=1, loop=1, remove=false}
		if player.x > player.width / 2 + 20 then
			player.x = player.x - 35
		end
	end
end

--[[ MOVE RIGHT ]]--
local moveRight = function(event)
	if event.phase == "began" then
		rightButton:play{startFrame=1, endFrame=2, loop=1, remove=false}
	elseif event.phase == "ended" then
		rightButton:play{startFrame=2, endFrame=1, loop=1, remove=false}
		if player.x < screenW - player.width / 2 - 20 then
			player.x = player.x + 35
		end
	end
end

--[[ FALLING OBJECTS ]]--
local main = function(event)
	if isPlay then
		local rand = math.random(100)
		
		if rand < 25 then --APPLE
			item = movieclip.newAnim{"images/item_apple.png", "images/coin30.png", "images/coin30.png", "images/coin30.png"}
			item.x = 60 + math.random(screenW - 120)
			item.y = -100
			physics.addBody(item, {density = 1.4, friction = 0.3, bounce = 0.2, radius = 21})
			item.myName = 'a'
		elseif rand < 50 then --BERRY
			item = movieclip.newAnim{"images/item_berry.png", "images/coin20.png", "images/coin20.png", "images/coin20.png"}
			item.x = 60 + math.random(screenW - 120)
			item.y = -100
			physics.addBody(item, {density=1.4, friction=0.3, bounce=0.2, radius = 21})
			item.myName = 'b'
		elseif rand < 75 then --MANGO
			item = movieclip.newAnim{"images/item_mango.png", "images/coin10.png", "images/coin10.png", "images/coin10.png"}
			item.x = 60 + math.random(screenW - 120)
			item.y = -100
			physics.addBody(item, {density=1.4, friction=0.3, bounce=0.2, radius = 17})
			item.myName = 'm'
		elseif rand < 95 then --POISON
			item = movieclip.newAnim{"images/item_poison.png", "images/poison_eat.png", "images/poison_eat.png", "images/poison_eat.png"}
			item.x = 60 + math.random(screenW - 120)
			item.y = -100
			physics.addBody(item, {density=1.4, friction=0.3, bounce=0.2, radius = 20})
			item.myName = 'p'
		else --CAPSULE
			item = movieclip.newAnim{"images/item_capsule.png", "images/heart.png", "images/heart.png", "images/heart.png"}
			item.x = 60 + math.random(screenW - 120)
			item.y = -100
			physics.addBody(item, {density=1.4, friction=0.3, bounce=0.2, radius = 20})
			item.myName = 'c'
		end
		itemGroup:insert(item)
	else
		--
		physics.stop()
		timer.pause(mainTimer)
	end
end

--[[ COLLISION EVENT ]]--
local onCollision = function(event)
	if event.phase == "began" then
		if event.object2.myName == 'a' then --APPLE
			if event.object2.y > untouch then
				score = score + 30
				currentScore.text = score
				player:play{startFrame=1, endFrame=5, loop=1, remove=false}
				event.object2:play{startFrame=1, endFrame=3, loop=1, remove=true}
				print(score)
			end
		elseif event.object2.myName == 'b' then --BERRY
			if event.object2.y > untouch then
				score = score + 20
				currentScore.text = score
				player:play{startFrame=1, endFrame=5, loop=1, remove=false}
				event.object2:play{startFrame=1, endFrame=3, loop=1, remove=true}
				print(score)
			end
		elseif event.object2.myName == 'm' then --MANGO
			if event.object2.y > untouch then
				score = score + 10
				currentScore.text = score
				player:play{startFrame=1, endFrame=5, loop=1, remove=false}
				event.object2:play{startFrame=1, endFrame=3, loop=1, remove=true}
				print(score)
			end
		elseif event.object2.myName == 'p' then --POISON
			if event.object2.y > untouch then
				score = score - 15
				currentScore.text = score
				life = life - 1
				currentLife.text = life
				player:play{startFrame=1, endFrame=5, loop=1, remove=false}
				event.object2:play{startFrame=1, endFrame=3, loop=1, remove=true}
				print(score)
			end
		else
			if event.object2.y > untouch then --CAPSULE
				life = life + 1
				if life > 3 then
					life = 3
					currentLife.text = life
				else
					currentLife.text = life
				end
				player:play{startFrame=1, endFrame=5, loop=1, remove=false}
				event.object2:play{startFrame=1, endFrame=3, loop=1, remove=true}
				print(score)
			end
		end
	end
end

--[[ COUNT DOWN ]]--
local countDwon = function()
	if isPlay then
		if timeCount == 0 then -- GAME CLEAR
			isPlay = false
			Runtime:removeEventListener("collision", onCollision)
			Runtime:removeEventListener("enterFrame", countDwon)
			print("GAME CLEAR!")
			physics.stop()
			timer.pause(mainTimer)
			
			resultScore = score
			storyboard.gotoScene("finish", "crossFade", 400)
			
		elseif life == 0 then -- GAME OVER
			isPlay = false
			Runtime:removeEventListener("collision", onCollision)
			Runtime:removeEventListener("enterFrame", countDwon)
			print("GAME OVER!")
			physics.stop()
			timer.pause(mainTimer)
			
			overlayRect.y = screenH / 2
			
			title.y = screenH / 2 - 120
			
			myScore.text = "SCORE:"..score
			myScore.y = screenH / 2 - 44
			
			backButton.y = screenH / 2 + 76
		else
			timeCount = timeCount - 1
			currentTime.text = math.floor(timeCount/30)
		end
	end
end

--[[ BACK BUTTON ]]--
local onBackButton = function(event)
	if event.phase == "began" then
		storyboard.gotoScene("splash", "crossFade", 400)
    return true
	end
end


-- Called when the scene's view does not exist:
function scene:createScene(event)
	local screenGroup = self.view
	
	isPlay = true
	timeLimit = 60
	score = 0
	life = 3
	timeCount = timeLimit * 30 -- sec * fps
	delay = 500
	
	itemGroup = display.newGroup()
	
	physics.start()
	--physics.setDrawMode("hybrid")
	
	--[[ BACKGROUND ]]--
	bg = display.newImage("images/bg.png")
	bg.x = screenW / 2
	bg.y = screenH / 2
	screenGroup:insert(bg)
	
	--[[ TIMER TEXT ]]--
	timeIcon = display.newImage("images/clock.png")
	timeIcon.x = 25
	timeIcon.y = 25
	screenGroup:insert(timeIcon)
	--
	currentTime = display.newText("", 0, 0, native.systemFont, 24)
	currentTime.text = "00"
	currentTime.x = 26
	currentTime.y = 56
	currentTime:setTextColor(0, 0, 0)
	screenGroup:insert( currentTime )
	
	--[[ SCORE TEXT ]]--
	scoreIcon = display.newImage("images/coin.png")
	scoreIcon.x = screenW - 30
	scoreIcon.y = 27
	screenGroup:insert(scoreIcon)
	--
	currentScore = display.newText("", 0, 0, native.systemFont, 24)
	scoreIcon.x = screenW - 30
	scoreIcon.y = 27
	currentScore.text = "0"
	currentScore.x = screenW - 30
	currentScore.y = 26
	currentScore:setTextColor(0, 0, 0)
	screenGroup:insert( currentScore )
	
	--[[ LIFE TEXT ]]--
	lifeIcon = display.newImage("images/heart.png")
	lifeIcon.x = screenW - 30
	lifeIcon.y = 72
	screenGroup:insert(lifeIcon)
	--
	currentLife = display.newText("", 0, 0, native.systemFont, 24)
	currentLife.text = life
	currentLife.x = screenW - 30
	currentLife.y = 74
	currentLife:setTextColor(0, 0, 0)
	screenGroup:insert(currentLife)
	
	--[[ PLAYER ]]--
	player = movieclip.newAnim{"images/droid.png", "images/droid_eat.png", "images/droid_eat.png", "images/droid_eat.png", "images/droid.png"}
	player.x = screenW / 2
	player.y = screenH - 75
	physics.addBody(player, "static", {friction = 0.5, bounce = 0.3, radius = 34})
	player.name = 'droid'
	screenGroup:insert(player)
	
	--[[ LEFT CONTROL BUTTON ]]--
	leftButton = movieclip.newAnim{"images/btn.png", "images/btn_on.png"}
	leftButton.x = leftButton.width / 2
	leftButton.y = screenH - leftButton.width / 2
	screenGroup:insert(leftButton)

	--[[ RIGHT CONTROL BUTTON ]]--
	rightButton = movieclip.newAnim{"images/btn.png", "images/btn_on.png"}
	rightButton.x = screenW - rightButton.width / 2
	rightButton.y = screenH - rightButton.width / 2
	screenGroup:insert(rightButton)
	
	screenGroup:insert(itemGroup)
	
	--[[ GMAE OVER ]]--
	overlayRect = display.newRect(0, 0, screenW, screenH)
	overlayRect:setFillColor(0,0,0,178)
	overlayRect.y = -1000
	screenGroup:insert(overlayRect)
	--
	myScore = display.newText("", 0, 0, native.systemFont, 36)
	myScore.x = screenW / 2
	myScore.y = -1000
	myScore:setTextColor(255, 255, 255)
	screenGroup:insert(myScore)
	--
	title = display.newImage("images/title_gameover.png")
	title.x = screenW / 2
	title.y = -1000
	screenGroup:insert(title)
	
	--[[ BACK BUTTON ]]--
	backButton = display.newImage("images/btn_back.png")
	backButton.x = screenW / 2
	backButton.y = -1000
	screenGroup:insert(backButton)
	
	-- RUN MAIN
	mainTimer = timer.performWithDelay(delay, main, 0)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	-- remove previous
	storyboard.purgeScene(storyboard.getPrevious())
	-- add listener
	leftButton:addEventListener("touch", moveLeft)
	rightButton:addEventListener("touch", moveRight)
	Runtime:addEventListener("collision", onCollision)
	Runtime:addEventListener("enterFrame", countDwon)
	backButton:addEventListener("touch" , onBackButton)
end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	-- remove listener
	leftButton:removeEventListener("touch", leftButton)
	rightButton:removeEventListener("touch", rightButton)
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("enterFrame", countDwon)
	backButton:removeEventListener("touch", backButton)
	timer.cancel(mainTimer)
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