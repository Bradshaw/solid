local current_folder = (...):gsub('%.init$', '')
local diplodocus = {}
diplodocus.useful = require(current_folder.."/useful")
diplodocus.query = require(current_folder.."/query")
diplodocus.vector = require(current_folder.."/vector")
diplodocus.event = require(current_folder.."/event")









return diplodocus