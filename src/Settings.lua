--[[[
	WWWWWWWWWWWWWW\ ;MWWR`      xWWW\    _tpNWWM&9L-  
	WWWMRRRRRRRRRR~  rWWWy     ^WWWi   `yWWWNKpRMWWMu`
	WWW0              LWWW+   :NWWe    pWWN^     rMWW2
	WWW0               sWWM~ `mWW0`   ;WWWL       xWWW
	WWWN\\\\\\\\\,      RWWB-yWWM;    `&WWK'     ,gWWR
	WWWWWWWWWWWWW|      ,0WWNWWM^      ;0WWMe}?jEMWW8:
	WWWN+++++++++-       ;MWWWW}        `vmWWWWWWMO1` 
	WWW0                  ~xff+             "~!~-     
	WWW0                                              
	WWWMqqqqqqqqqq~                                   
	WWWWWWWWWWWWWW\                                               
	
	Commander 4 by Evo
	
	## FAQs
	
	Q: How to add a new admin?
	A: You can refer to our documentation (https://commander-4.vercel.app)
	
	Q: How can I change the theme colour?
	A: You can change it by modifying the Accent settings below
	
	Q: How can I change the toggle keybind?
	A: You can change it by modifying the Keybind settings below.
	
	Q: I don't see Commander, what's going on?
	A: You probably have disabled API access for Studio or your game is not published. If none of this solves the issue, just send a DM to nana_kon or join
	our community.
--]]

local module = {}

module.Admins = {
	["7kayoh"] = "Owner",
	-- [12312322] = "Moderator", -- user with User Id 12312322 will get Moderator,
	-- ["Roblox"] = "Moderator", -- user with name Roblox will get Moderator
	-- for more information such as group ranking, refer the documentation
}

module.Permissions = {
	["Moderator"] = {
		["Priority"] = 1,
		["DisallowPrefixes"] = {
			"All",
			"Others"
		},
		["Permissions"] = {
			"Kick",
			"ChatLogs",
			"JoinLogs",
			"CheckBan",
			"Message",
			"HandTo",
			"View",
			"Unview"
		}
	},
	["Admin"] = {
		["Inherits"] = "Moderator",
		["Priority"] = 2,
		["Permissions"] = {
			"Ban",
			"Shutdown",
			"TimeBan",
			"Unban",
			"SystemMessage",
			"ServerLock"
		}
	},
	["Owner"] = {
		["Inherits"] = "Admin",
		["Priority"] = 3,
		["Permissions"] = {
			"*"
		}
	}
}

module.UI = {
	["Accent"] = Color3.fromRGB(64, 157, 130),
	["Keybind"] = Enum.KeyCode.Semicolon,
	["Theme"] = "Minimal Dark"
}

module.Misc = {
	["DisableCredits"] = false,
	-- v this only works outside Studio.
	["AutoCreatorAdmin"] = true, -- when enabled, this automatically grants the game owner admin
	["AutoCreatorAdminTo"] = "Owner" -- configure this if needed
}

return module
