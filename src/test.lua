local state = {}



function state:init()
end


function state:enter( pre )
	for k,v in pairs(table) do
		print(k,v,type(v))
	end


	sh = diplodocus.shade()
end


function state:leave( next )
end


function state:update(dt)
end


function state:draw()
	sh:setTarget()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.rectangle("line", w/4, h/4, w/2, h/2)
	love.graphics.line(w/4, h/4, 3*w/4, 3*h/4)
	love.graphics.line(3*w/4, h/4, w/4, 3*h/4)

	sh:prep()
	sh:blur(0.03+math.sin(love.timer.getTime())*0.03)
	sh:invert()
	sh:release()

	sh:pushToScreen()
end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
	end
end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
end


function state:quit()
end


function state:resize(w, h)
end


function state:textinput( t )
end


function state:threaderror(thread, errorstr)
end


function state:visible(v)
end


function state:gamepadaxis(joystick, axis)
end


function state:gamepadpressed(joystick, btn)
end


function state:gamepadreleased(joystick, btn)
end


function state:joystickadded(joystick)
end


function state:joystickaxis(joystick, axis, value)
end


function state:joystickhat(joystick, hat, direction)
end


function state:joystickpressed(joystick, button)
end


function state:joystickreleased(joystick, button)
end


function state:joystickremoved(joystick)
end

return state