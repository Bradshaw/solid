local current_folder = (...):gsub('%.init$', '')
local diplodocus = {}
diplodocus.vector = require(current_folder.."/vector")
diplodocus.event = require(current_folder.."/event")









return diplodocus