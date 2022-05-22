--[[

Adds an event when you activate a player called `OnPlayerActivate(pid, otherpid, menu, cellDescription)`  

| argument        | description                                           |
| --------------- | ----------------------------------------------------- |
| pid             | The player id of the **activating** player            |
| otherpid        | The player id of the **activated** player             |
| menu            | A table that will be passed to menuHelper.DisplayMenu |
| cellDescription | The cell description of the **activated** player      |

]] --


PlayerActivationAPI = {}

-- this function checks to see if this is a player activating another player and calls the validator and handler for "OnPlayerActivate"
local function ObjectToPlayerHandler(eventStatus, pid, cellDescription, objects, players)
	if Players[pid] == nil or Players[pid]:IsLoggedIn() == false then
		return
	end

	if LoadedCells[cellDescription] == nil then
		return
	end

	-- Players (number of players)
	-- players (other pid)

	if tes3mp.IsObjectPlayer(#objects) == false then
		return
	end

	if eventStatus.validDefaultHandler then
		local otherPid = #players
		local MenuKey = "PlayerActivationApiMenu_" .. tostring(pid)
		eventStatus = customEventHooks.triggerValidators("OnPlayerActivate", {pid, otherPid, cellDescription})

		Menus[MenuKey] = {
			text = "",
			buttons = {{caption = "Close", destinations = nil}}
		}

		local menu = Menus[MenuKey]
		customEventHooks.triggerHandlers("OnPlayerActivate", eventStatus, {pid, otherPid, menu, cellDescription})

		if eventStatus.validDefaultHandler then
			menu.text = Players[otherPid].name
			Players[pid].currentCustomMenu = MenuKey
			menuHelper.DisplayMenu(pid, MenuKey)
		end

		Menus[MenuKey] = nil
	end
end

-- this validator just makes sure everyone is logged in
function PlayerActivationAPI.OnPlayerActivateValidator(eventStatus, activatingPlayer, activatedPlayer, cellDescription)
	if (Players[activatingPlayer] == nil or
		Players[activatedPlayer] == nil or
		Players[activatingPlayer]:IsLoggedIn() == false or
		Players[activatedPlayer]:IsLoggedIn() == false or
		LoadedCells[cellDescription] == nil) then
		return customEventHooks.makeEventStatus(false, false)
	end
end

-- register that function to be called when the player activates an object
customEventHooks.registerHandler("OnObjectActivate", ObjectToPlayerHandler)
customEventHooks.registerValidator("OnPlayerActivate", PlayerActivationAPI.OnPlayerActivateValidator)

tes3mp.LogMessage(enumerations.log.INFO, "PlayerActivationAPI is ready.")

return PlayerActivationAPI
