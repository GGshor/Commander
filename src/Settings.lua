--[[[
	## FAQs

	Q: How to add a new admin?
	A: You can refer to our documentation (https://github.com/GGshor/Commander)

	Q: How can I change the theme colour?
	A: You can change it by modifying the Accent settings below

	Q: How can I change the toggle keybind?
	A: You can change it by modifying the Keybind settings below.

	Q: I don't see Commander, what's going on?
	A: You probably have disabled API access for Studio or your game is not published. If none of this solves the issue, just send a DM to GGshor.
--]]

local Admins = {
	["GGshor"] = "Owner",
	-- [12312322] = "Moderator", -- user with User Id 12312322 will get Moderator,
	-- ["Roblox"] = "Moderator", -- user with name Roblox will get Moderator
	-- for more information such as group ranking, refer to the documentation
}

local Permissions = {
	["Moderator"] = {
		["Priority"] = 1,
		["DisallowPrefixes"] = {
			"All",
			"Others",
		},
		["Permissions"] = {
			"Kick",
			"ChatLogs",
			"JoinLogs",
			"CheckBan",
			"Message",
			"HandTo",
			"View",
			"Unview",
		},
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
			"ServerLock",
		},
	},
	["Owner"] = {
		["Inherits"] = "Admin",
		["Priority"] = 3,
		["Permissions"] = {
			"*",
		},
	},
}

local UI = {
	["Accent"] = Color3.fromRGB(64, 157, 130),
	["Keybind"] = Enum.KeyCode.Semicolon,
	["Theme"] = "Minimal Dark",
}

local Misc = {
	["DisableCredits"] = false,
	-- v this only works outside Studio.
	["AutoCreatorAdmin"] = true, -- when enabled, this automatically grants the game owner admin
	["AutoCreatorAdminTo"] = "Owner", -- configure this if needed
}

return {
	["Admins"] = Admins,
	["Permissions"] = Permissions,
	["UI"] = UI,
	["Misc"] = Misc
}
