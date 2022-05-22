Original script by DavidMeagher1 at https://github.com/DavidMeagher1/TES3MP_Scripts
## PlayerActivationAPI
`PlayerActivationAPI = require("custom.PlayerActivationAPI.main")`  
Adds an event when you activate a player called `OnPlayerActivate(pid, otherpid, menu, cellDescription)`  
| argument        | description                                           |
| --------------- | ----------------------------------------------------- |
| pid             | The player id of the **activating** player            |
| otherpid        | The player id of the **activated** player             |
| menu            | A table that will be passed to menuHelper.DisplayMenu |
| cellDescription | The cell description of the **activated** player      |
