--!strict
-- Services
-- Packages
-- Modules
local Runner = require("./Runner")

-- Types
export type TransitionRunner = Runner.TransitionRunner

-- Constants
-- Variables
-- References
-- Private Functions
-- Class
-- Types
-- Class
local Util = {}
Util.Runner = Runner
Util.Easing = require("./Easing")
Util.Duration = require("./Duration")

return Util
