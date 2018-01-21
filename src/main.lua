

function love.load(arg)

	for k,v in pairs(arg) do
		print(k,v)
	end

	diplodocus = require "diplodocus"


	useful = diplodocus.useful
	gstate = require "gamestate"
	gstate.registerEvents()
	game = require "game"
	local test = require "test"

	if arg[2]=="test" then
		gstate.switch(test)
	else
		gstate.switch(game)
	end
end