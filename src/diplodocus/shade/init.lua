--   .    .     .                  .       .
--  _|*._ | _  _| _  _.. . __    __|_  _. _| _
-- (_]|[_)|(_)(_](_)(_.(_|_)  * _) [ )(_](_](/,
--     |
--
-- an attempt at a shader stack for Löve2d

local current_folder = (...):gsub('%.init$', '')
local frags = {
	identity = love.graphics.newShader(current_folder.."/identity.fs"),
	invert = love.graphics.newShader(current_folder.."/invert.fs"),
	blurh = love.graphics.newShader(current_folder.."/blurh.fs"),
	blurv = love.graphics.newShader(current_folder.."/blurv.fs"),
	glitch = love.graphics.newShader(current_folder.."/glitch.fs")
}
local shade_mt = {}
local shade = setmetatable({},{
	__call = function(_, img)
		local self = setmetatable({},{__index = shade_mt})
		self.a = img or love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
		self.b = love.graphics.newCanvas(self.a:getWidth(), self.a:getHeight())
		self.state = {
			prepped = false
		}
		return self
	end
})

function shade_mt:setTarget()
	if self.state.prepped then
		error("Target unavailable - Shade is set")
	end
	love.graphics.setCanvas(self.a)
	love.graphics.clear()
end

function shade_mt:pushToScreen(...)
	if self.state.prepped then
		self:release()
	end
	love.graphics.setCanvas()
	love.graphics.origin()
	love.graphics.draw(self.a,...)
end

function shade_mt:applySettings(settings)
	local shader = love.graphics.getShader()
	for k,v in pairs(settings) do
		shader:send(k,v)
	end
end


function shade_mt:process(proc, ...)
	if not self.state.prepped then
		error("Shade isn't prepped - Please prep before processing")
	end
	if proc then
		love.graphics.setShader(proc.shader)
		if proc.settings then
			self:applySettings(proc.settings)
		end
		love.graphics.draw(self.a)
		self:flip()
		self:process(...)
	end
end


function shade_mt:prep()
	if self.state.prepped then
		error("Shade is already prepped")
	end

	local r,g,b,a = love.graphics.getColor()
	local canvas = love.graphics.getCanvas()
	local shader = love.graphics.getShader()
	love.graphics.setCanvas(self.b)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.origin()
	self.state = {
		prepped = true,
		col = {r=r,g=g,b=b,a=a},
		canvas = canvas,
		shader = shader

	}
end

function shade_mt:flip()
	if not self.state.prepped then
		error("Shade hasn't been prepped")
	end

	self.a, self.b = self.b, self.a
	love.graphics.setCanvas(self.b)
	love.graphics.clear()
end

function shade_mt:release()
	if not self.state.prepped then
		error("Shade isn't prepped")
	end

	love.graphics.setColor(
		self.state.col.r,
		self.state.col.g,
		self.state.col.b,
		self.state.col.a
	)
	love.graphics.setCanvas(self.state.canvas)
	love.graphics.setShader(self.state.shader)
	love.graphics.pop()
	self.state = {prepped = false}
end

function shade_mt:blur(dist, samples)
	if dist<=0 then
		print("skip")
		return
	end
	local settings = {
		dist = dist or 0.03,
		samples = samples or 16
	}
	self:process({
		shader = frags.blurv,
		settings = settings
	})
	self:process({
		shader = frags.blurh,
		settings = settings
	})
end
function shade_mt:invert()
	self:process({shader = frags.invert})
end
function shade_mt:identity()
	self:process({shader = frags.identity})
end
function shade_mt:glitch(noise)
	self:process({
		shader = frags.glitch,
		settings = {
			sw=sh.a:getWidth(),
			sh=sh.a:getHeight(),
			cw=sh.a:getWidth(),
			ch=sh.a:getHeight(),
			distort=0,
			flip=-1,
			time=(love.timer.getTime()%5)+10,
			shimmer=noise or 1
		}
	})
end





return shade


--[[

shade(img).blur(5).colorize(255,0,255).


]]