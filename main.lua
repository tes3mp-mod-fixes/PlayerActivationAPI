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
	-- check current cell
	if LoadedCells[cellDescription] == nil then
		return
	end
	
	-- skip if it's not a player
	for objectIndex, objectContainer in pairs(objects) do
		return
	end

	-- get target player
	local playerObject = nil
	for playerIndex, playerContainer in pairs(players) do
		playerObject = playerContainer
		break
	end

	-- check target player
	if playerObject == nil then
		return
	end

	-- validate players
	if eventStatus.validDefaultHandler == false then
		return
	end

	local targetPid = playerObject.pid
	eventStatus = customEventHooks.triggerValidators("OnPlayerActivate", {pid, targetPid, cellDescription})

	-- create menu
	local MenuKey = "PlayerActivationAPI_Menu_" .. string.format(pid)
	Menus[MenuKey] = {
		text = Players[targetPid].name, 
		buttons = {
			{
				caption = "Close", 
				destinations = nil
			}
		}
	}

	customEventHooks.triggerHandlers("OnPlayerActivate", eventStatus, {pid, targetPid, Menus[MenuKey], cellDescription})

	-- display menu
	Players[pid].currentCustomMenu = MenuKey
	menuHelper.DisplayMenu(pid, MenuKey)
end

-- this validator just makes sure everyone is logged in
function PlayerActivationAPI.OnPlayerActivateValidator(eventStatus, currentPlayer, targetPlayer, cellDescription)
	if (Players[currentPlayer] == nil or
		Players[targetPlayer] == nil or
		Players[currentPlayer]:IsLoggedIn() == false or
		Players[targetPlayer]:IsLoggedIn() == false) then
		return customEventHooks.makeEventStatus(false, false)
	end
end

-- register that function to be called when the player activates an object
customEventHooks.registerHandler("OnObjectActivate", ObjectToPlayerHandler)
customEventHooks.registerValidator("OnPlayerActivate", PlayerActivationAPI.OnPlayerActivateValidator)

tes3mp.LogMessage(enumerations.log.INFO, "PlayerActivationAPI is ready.")

return PlayerActivationAPI
