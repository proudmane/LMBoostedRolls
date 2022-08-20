local Main = LibStub("AceAddon-3.0"):NewAddon(
    "LMBoostedRolls", 
    "AceConsole-3.0",
    "AceEvent-3.0"
)

-- local AceEvent = LibStub("AceEvent-3.0")

LMBoostedRolls = Main

local defaults = {

}


function Main:OnInitialize()
    Main.db = LibStub("AceDB-3.0"):New("LMBoostedRollsDB", defaults)
    
    Main:RegisterEvent(
        'CHAT_MSG_LOOT',
        onChatMsgLoot
    )

    Main:HelloWorld()
end

local function onChatMsgLoot(arg1, arg2)
    message("testing")
end

function Main:HelloWorld()
    message(Main.CSV:Test())
end

