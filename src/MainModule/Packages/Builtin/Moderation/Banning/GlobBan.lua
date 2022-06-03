local module = {}
local private = {}

module.Name = "Global Ban"
module.Description = "Bans a player from the game globally"
module.Location = "Player"

function module.Execute(Client: Player?, Type: string, Attachment)
    if Type == "command" then
        local possiblyUserId = module.API.Players.getUserIdFromName(Attachment)
        if type(possiblyUserId) == "string" or module.API.Players.getAdminStatus(possiblyUserId) then
            return false
        end

        local possiblyUser = module.API.Players.getPlayerByUserId(possiblyUserId)
        local input = module.API.Players.sendModal(Client, "What's the reason?").Event:Wait()
        if not input then
            return false
        end
        local ok, content = module.API.Players.filterString(Client, input)
        if not ok then
            module.API.Players.hint(Client, "System", "An error occured while trying to filter string message")
            return false
        end

        local data = private.DataStore:GetAsync("data")
        if not data then data = {} end
        data[possiblyUserId] = {
            ["By"] = {Client.UserId, Client.Name},
            ["At"] = os.date("%c", os.time()),
            ["End"] = "PERM",
            ["Reason"] = content
        }

        local ok, response = pcall(private.DataStore.SetAsync, private.DataStore, "data", data)
        module.API.Players.hint(Client, "System", ok and "Successfully banned player " .. possiblyUserId .. "!" or "An error occured while trying to ban player " .. possiblyUserId .. "\n\nError message:\n" .. response)
        if ok and possiblyUser then
            possiblyUser:Kick("Banned by " .. Client.Name .. " at " .. data[possiblyUserId].At .. "\n\nReason: " .. content .. "\n\nNote: This ban is a global ban, you will not be allowed to join this game unless unbanned")
        end
    end
end

function module.Init()
    private.DataStore = module.Services.DataStoreService:GetDataStore(module.Settings.Misc.DataStoresKey.Ban or "commander.bans")
    module.API.Players.listenToPlayerAdded(function(Player: Player)
        local ok, data = pcall(private.DataStore.GetAsync, private.DataStore, "data")
        if not ok then
            Player:Kick("Something went wrong while trying to fetch data, retry later")
        end

        if data[tostring(Player.UserId)] then
            data = data[tostring(Player.UserId)]
            if data.End == "PERM" then
                module.API.Players.hint("all", "System", "Player " .. Player.UserId .. " tried to join but is banned")
                Player:Kick("Banned by " .. data.By[2] .. " at " .. data.At .. "\n\nReason: " .. data.Reason .. "\n\nNote: This ban is a global ban, you will not be allowed to join this game unless unbanned")
            elseif type(data.End) == "number" and data.End > os.time() then
                module.API.Players.hint("all", "System", "Player " .. Player.UserId .. " tried to join but is banned")
                Player:Kick("Banned by " .. data.By[2] .. " at " .. data.At .. "\n\nReason: " .. data.Reason .. "\n\nNote: This ban is a timed global ban, you will not be allowed to join this game until " .. os.date("%c", data.End))
            end
        end
    end)
end

return module