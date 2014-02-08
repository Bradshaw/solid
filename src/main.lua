function love.load(arg)
	gstate = require "gamestate"
	game = require("game")
	gstate.switch(game)
end

function love.draw(...)
	gstate.draw(...)
end


function love.errhand(...)
	gstate.errhand(...)
end


function love.focus(...)
	gstate.focus(...)
end


function love.keypressed(...)
	gstate.keypressed(...)
end


function love.keyreleased(...)
	gstate.keyreleased(...)
end


function love.mousefocus(...)
	gstate.mousefocus(...)
end


function love.mousepressed(...)
	gstate.mousepressed(...)
end


function love.mousereleased(...)
	gstate.mousereleased(...)
end


function love.quit(...)
	gstate.quit(...)
end


function love.resize(...)
	gstate.resize(...)
end


function love.textinput(...)
	gstate.textinput(...)
end


function love.threaderror(...)
	gstate.threaderror(...)
end


function love.update(...)
	gstate.update(...)
end


function love.visible(...)
	gstate.visible(...)
end


function love.gamepadaxis(...)
	gstate.gamepadaxis(...)
end


function love.gamepadpressed(...)
	gstate.gamepadpressed(...)
end


function love.gamepadreleased(...)
	gstate.gamepadpressed(...)
end


function love.joystickadded(...)
	gstate.joystickadded(...)
end


function love.joystickaxis(...)
	gstate.joystickaxis(...)
end


function love.joystickhat(...)
	gstate.joystickhat(...)
end


function love.joystickpressed(...)
	gstate.joystickpressed(...)
end


function love.joystickreleased(...)
	gstate.joystickreleased(...)
end


function love.joystickremoved(...)
gstate.joystickremove(...)
end

