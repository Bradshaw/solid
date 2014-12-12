require("useful")
function love.load(arg)
	diplodocus = require "diplodocus"
	gstate = require "gamestate"
	game = require "game"
	gstate.registerEvents()
	gstate.switch(game)
end