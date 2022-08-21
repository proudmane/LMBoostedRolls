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

    -- Main:HelloWorld()

    message("test")

    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_SYSTEM")
    frame:SetScript("OnEvent", function (test2, event, test)
        local test = string.find(event, "[abc]")
        print(test)
    end)
end

-- function Main:HelloWorld()
--     message(Main.CSV:Test())
-- end

