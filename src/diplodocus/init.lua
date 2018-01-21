--   .    .     .
--  _|*._ | _  _| _  _.. . __
-- (_]|[_)|(_)(_](_)(_.(_|_)
--     |
--
-- /dɪˈplɒdəkəs,ˌdɪplə(ʊ)ˈdəʊkəs/Submit
-- noun
-- A huge herbivorous dinosaur of the late Jurassic period, with a long slender neck and tail.
--
-- 14th track on the album "Split The Atom" by Noisia
--
-- A collection of tools for making games with Lua
-- Designed for use in Löve2d, also compatible with Lövr

local current_folder = (...):gsub('%.init$', '')
local diplodocus = {}
diplodocus.useful = require(current_folder.."/useful")
diplodocus.thing = require(current_folder.."/thing")
diplodocus.query = require(current_folder.."/query")
diplodocus.vector = require(current_folder.."/vector")
diplodocus.event = require(current_folder.."/event")
if love then
	diplodocus.shade = require(current_folder.."/shade")
end



math.tau = math.pi*2







return diplodocus