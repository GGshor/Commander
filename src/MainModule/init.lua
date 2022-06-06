local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local debounce = false

return function(Settings: {}, CustomPackages: Folder, Stylesheets: Folder)
	if debounce == true then
		return
	else
		debounce = true
	end

	script.SystemPackages.Settings:Destroy()
	Settings.Name = "Settings"
	CustomPackages.Name = "Custom"
	CustomPackages.Parent = script.Packages
	Settings.Parent = script.SystemPackages
	for _, stylesheet: ModuleScript? in pairs(Stylesheets:GetChildren()) do
		if stylesheet:IsA("ModuleScript") then
			stylesheet.Parent = script.Library.UI.Stylesheets
		end
	end
	Stylesheets:Destroy()

	warn("Commander; Preparing...")
	local remotefolder = Instance.new("Folder")

	local isPlayerAddedFired = false
	local remotes = {
		Function = Instance.new("RemoteFunction"),
		Event = Instance.new("RemoteEvent"),
	}

	local packages, packagesButtons, systemPackages, permissionTable, disableTable, cachedData, sharedCommons =
		{}, {}, {}, {}, {}, {}, {}
	local currentTheme = nil

	remotefolder.Name = "Commander Remotes"
	remotes.Function.Parent, remotes.Event.Parent = remotefolder, remotefolder
	remotefolder.Parent = ReplicatedStorage
	remotefolder = nil

	for _, package in pairs(script.Packages:GetDescendants()) do
		if package:IsA("ModuleScript") then
			local success, response = pcall(function()
				local mod = require(package)
				if mod.Execute and mod.Name and mod.Description and mod.Location then
					packagesButtons[#packagesButtons + 1] = {
						Name = mod.Name,
						Protocol = mod.Name,
						Description = mod.Description,
						Location = mod.Location,
						PackageId = package.Name,
					}
				end
			end)
			if success == false then
				warn(
					"Commander; Error while trying to setup package:",
					tostring(package),
					"with reason:",
					tostring(response)
				)
			end
		end
	end

	-- Added by TurtleIdiot: used to recursively navigate inheritance when actually building permission tables
	local function buildTempPermissions(permissions, group, groupconfig)
		local temptable = {}
		if
			groupconfig["Inherits"]
			and permissions[groupconfig["Inherits"]]
			and permissions[groupconfig["Inherits"]]["Commands"]
		then
			for _, perm in ipairs(permissions[groupconfig["Inherits"]]["Commands"]) do
				table.insert(temptable, perm)
			end
			local inherited = buildTempPermissions(
				permissions,
				groupconfig["Inherits"],
				permissions[groupconfig["Inherits"]]
			)
			if inherited ~= false then
				for _, perm in ipairs(inherited) do
					table.insert(temptable, perm)
				end
			end
			return temptable
		else
			return false
		end
	end

	-- Builds permission tables to allow indexing for permissions.
	local function buildPermissionTables()
		local permissions = systemPackages.Settings["Permissions"]

		for rank, config in pairs(permissions) do
			permissionTable[rank] = {}

			if config["Commands"] then
				for _, perm in ipairs(config["Commands"]) do
					permissionTable[rank][perm] = true
				end
			end

			if config["Inherits"] and permissions[config["Inherits"]] and permissions[config["Inherits"]]["Commands"] then
				local inherited = buildTempPermissions(permissions, rank, config)
				if inherited ~= false then
					for _, perm in ipairs(inherited) do
						permissionTable[rank][perm] = true
					end
				end
			end
		end
	end

	-- Builds disable prefix table.
	local function buildDisableTables()
		local permissions = systemPackages.Settings["Permissions"]

		for rank, config in pairs(permissions) do
			disableTable[rank] = {}

			if config["DisallowPrefixes"] then
				for _, disallow in ipairs(config["DisallowPrefixes"]) do
					disableTable[config][disallow:lower()] = true
				end
			end
		end
	end

	local function loadPackages()
		for _, package in pairs(script.SystemPackages:GetChildren()) do
			if package:IsA("ModuleScript") then
				local name = package.Name
				package = require(package)
				systemPackages[name] = package
			end
		end

		buildPermissionTables()
		buildDisableTables()
		systemPackages.API.PermissionTable = permissionTable
		systemPackages.API.DisableTable = disableTable
		systemPackages.Settings.Version = { "0.0.1", "0.0.1 (UnOfficial Build)", "Yoke" }

		--@OVERRIDE
		systemPackages.Settings.LatestVersion, systemPackages.Settings.IsHttpEnabled = "1.5.0", false
		systemPackages.Settings.UI.AlertSound = systemPackages.Settings.UI.AlertSound or 6518811702
		systemPackages.Settings.Misc.DataStoresKey = systemPackages.Settings.Misc.DataStoresKey or {}
		if systemPackages.Settings.Misc.AutoCreatorAdmin and systemPackages.Settings.Misc.AutoCreatorAdminTo then
			if systemPackages.Settings.Permissions[systemPackages.Settings.Misc.AutoCreatorAdminTo] then
				if game.CreatorType == Enum.CreatorType.User and game.CreatorId then
					systemPackages.Settings.Admins[game.CreatorId] = systemPackages.Settings.Misc.AutoCreatorAdminTo
				elseif game.CreatorType == Enum.CreatorType.Group and game.CreatorId then
					local success, response = pcall(GroupService.GetGroupInfoAsync, GroupService, game.CreatorId)
					if success then
						systemPackages.Settings.Admins[response.CreatorId] = systemPackages.Settings.Misc.AutoCreatorAdminTo
					end
				end
			end
		end
		--

		for name, v in pairs(systemPackages) do
			for index, value in pairs(systemPackages) do
				if systemPackages[index] ~= v and typeof(v) ~= "function" and name ~= "Settings" then
					v.Remotes = remotes
					v[index] = value
				end
			end
		end

		for _, instance in pairs(script.Packages:GetDescendants()) do
			if instance:IsA("ModuleScript") and not instance.Parent:IsA("ModuleScript") then
				local ok, response = pcall(function()
					local package = require(instance)
					package.Services = systemPackages.Services
					package.API = systemPackages.API
					package.Settings = systemPackages.Settings
					package.Remotes = remotes
					package.Shared = sharedCommons
					package.fetchLogs = script.waypointBindable
					package.PackageId = package.Name
					if package and package.Name and package.Description and package.Location then
						packages[package.Name] = package
					end

					if not package.Init then
						package.Execute(nil, "firstrun")
					else
						package.Init()
					end
				end)

				if not ok then
					error(
						"\n\nOh snap! Commander encountered a fatal error while trying to compile commands in the runtime...\n\nAffected files: game."
							.. instance:GetFullName()
							.. ".lua\nError message: "
							.. response
							.. "\n\n"
					)
				end
			end
		end
	end

	loadPackages()

	if not script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme) then
		warn("ERR! | Theme " .. systemPackages.Settings.UI.Theme .. " is not installed")
		warn("Switching to default theme...")
		assert(script.Library.UI.Stylesheets:FindFirstChild("Minimal"), "Default theme missing...")
		local themeColorValue = Instance.new("Color3Value")
		themeColorValue.Name = "ThemeColor"
		themeColorValue.Value = systemPackages.Settings.UI.Accent
		currentTheme = script.Library.UI.Stylesheets:FindFirstChild("Minimal"):Clone()
		currentTheme.Name = "Stylesheet"
		themeColorValue.Parent = currentTheme
		currentTheme.Parent = script.Library.UI.Panel.Scripts.Library.Modules
	else
		local themeColorValue = Instance.new("Color3Value")
		themeColorValue.Name = "ThemeColor"
		themeColorValue.Value = systemPackages.Settings.UI.Accent
		currentTheme = script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme):Clone()
		currentTheme.Name = "Stylesheet"
		themeColorValue.Parent = currentTheme
		currentTheme.Parent = script.Library.UI.Panel.Scripts.Library.Modules
	end

	script.waypointBindable.OnInvoke = function()
		return systemPackages.Services.Waypoints.fetch()
	end

	remotes.Function.OnServerInvoke = function(Client, Type, Protocol, Attachment)
		if CollectionService:HasTag(Client, "commander.admins") and Type ~= "notifyCallback" then
			if Type == "command" and packages[Protocol] then
				if systemPackages.API.checkHasPermission(Client.UserId, packages[Protocol].PackageId) then
					local status = packages[Protocol].Execute(Client, Type, Attachment)
					if status then
						systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name, { Attachment })
					elseif status == nil then
						systemPackages.Services.Waypoints.new(
							Client.Name,
							packages[Protocol].Name .. " (TRY)",
							{ Attachment }
						)
					end
				else
					warn(Client.UserId, "does not have permission to run", Protocol)
				end

				return
			elseif Type == "input" then
				-- bindable aren't really good for this, yikes
				local Event = script.Bindables:FindFirstChild(Protocol)
				if Event and Attachment then
					Event:Fire(Attachment or false)
					Event:Destroy()
				else
					return false
				end
			elseif Type == "getAdmins" then
				return systemPackages.API.getAdmins()
			elseif Type == "getAvailableAdmins" then
				return #CollectionService:GetTagged("commander.admins")
			elseif Type == "getCurrentVersion" then
				return systemPackages.Settings.Version[1], systemPackages.Settings.Version[2]
			elseif Type == "getHasPermission" then
				return systemPackages.API.checkHasPermission(Client.UserId, Protocol)
			elseif Type == "getElapsedTime" then
				return workspace.DistributedGameTime
			elseif Type == "setupUIForPlayer" then
				remotes.Event:FireClient(Client, "firstRun", "n/a", systemPackages.Settings)
				CollectionService:AddTag(Client, "commander.admins")

				-- Filter out commands that the user doesn't have access to.
				local packagesButtonsFiltered = {}

				for i, v in ipairs(packagesButtons) do
					if systemPackages.API.checkHasPermission(Client.UserId, v.PackageId) then
						table.insert(packagesButtonsFiltered, v)
					end
				end

				remotes.Event:FireClient(Client, "fetchCommands", "n/a", packagesButtonsFiltered)
				remotes.Event:FireClient(
					Client,
					"fetchAdminLevel",
					"n/a",
					systemPackages.API.getAdminLevel(Client.UserId)
				)
				systemPackages.API.Players.message(
					Client,
					"System",
					"Welcome to Commander "
						.. systemPackages.Settings.Version[1]
						.. ", you are now authorized (ranked as "
						.. systemPackages.API.getAdminLevel(Client.UserId)
						.. ")\n\n Open the panel either with the keybind or the Command button at the top right hand corner.",
					30
				)
			elseif Type == "getSettings" then
				return systemPackages.Settings
			elseif Type == "getLocale" then
				if cachedData.serverlocale then
					return cachedData.serverlocale
				else
					local ok, response = systemPackages.Services.Promise.new(function(Resolve, Reject)
						local ok, data = pcall(
							systemPackages.Services.HttpService.GetAsync,
							systemPackages.Services.HttpService,
							"http://ip-api.com/json/"
						)
						if ok then
							data = systemPackages.Services.HttpService:JSONDecode(data).countryCode
							Resolve(data)
						else
							Reject(data)
						end
					end):await()

					if ok then
						cachedData.serverlocale = response
						return response
					else
						warn(response)
					end
				end
			elseif Type == "getPlaceVersion" then
				return game.PlaceVersion
			end
		end

		if Type == "notifyCallback" then
			-- bindable aren't really good for this, yikes
			local Event = script.Bindables:FindFirstChild(Protocol)
			if Event and Attachment then
				Event:Fire(Attachment or false)
				Event:Destroy()
			else
				return false
			end
		end
	end

	local function setupUIForPlayer(Client)
		local UI = script.Library.UI.Client:Clone()
		UI.ResetOnSpawn = false
		UI.Scripts.Core.Disabled = false
		UI.Parent = Client.PlayerGui

		if systemPackages.API.checkAdmin(Client.UserId) then
			CollectionService:AddTag(Client, "commander.admins")
			isPlayerAddedFired = true
			UI = script.Library.UI.Panel:Clone()
			UI.Name = "Panel"
			UI.ResetOnSpawn = false
			UI.Scripts.Core.Disabled = false
			UI.Parent = Client.PlayerGui
		end
	end

	Players.PlayerAdded:Connect(function(Client)
		setupUIForPlayer(Client)
	end)

	-- for situations where PlayerAdded will not work as expected in Studio
	if not isPlayerAddedFired then
		for i, v in pairs(Players:GetPlayers()) do
			setupUIForPlayer(v)
		end
	end

	warn("Commander; Loaded!")
end
