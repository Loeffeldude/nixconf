-- SketchyBar Lua Configuration
local colors = require("colors")
local bar = require("bar")
local icons = require("helpers.icons")

-- Configure bar
bar:init()

-- Load items
require("items.apple_menu")
require("items.workspaces")
require("items.clock")
require("items.media")
require("items.cpu")
require("items.ram")
require("items.battery")
require("items.volume")

-- Update the bar
sbar.exec("sketchybar --update")
