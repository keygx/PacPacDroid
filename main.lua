-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require("storyboard")

screenW, screenH = display.contentWidth, display.contentHeight
resultScore = 0

maskTop = display.newRect(0, 0, screenW, 400)
maskTop:setFillColor(0,0,0)
maskTop.x = screenW / 2
maskTop.y = - 200

maskBottom = display.newRect(0, 0, screenW, 400)
maskBottom:setFillColor(0,0,0)
maskBottom.x = screenW / 2
maskBottom.y = screenH + 200

storyboard.gotoScene("splash")