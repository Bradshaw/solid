

function love.load(arg)

	diplodocus = require "diplodocus"
	useful = diplodocus.useful
	gstate = require "gamestate"
	game = require "game"
	gstate.registerEvents()
	gstate.switch(game)
end