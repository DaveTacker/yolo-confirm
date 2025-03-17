local YOLO_Confirm = LibStub("AceAddon-3.0"):GetAddon("YOLO_Confirm")
local L = {}  -- Localization table if needed in the future

-- Default settings
local defaults = {
    profile = {
        enableLootRolls = true,
        enableDeleteItem = true,
        enableTransmog = true,
        enableAppearance = true,
        debug = false,
    }
}

-- Setup the configuration
local function SetupConfig()
    -- Initialize database
    YOLO_Confirm.db = LibStub("AceDB-3.0"):New("YOLO_ConfirmDB", defaults, true)
    
    -- Configuration options
    local options = {
        name = "YOLO Confirm",
        handler = YOLO_Confirm,
        type = "group",
        args = {
            general = {
                name = "General Settings",
                type = "group",
                order = 1,
                args = {
                    description = {
                        type = "description",
                        name = "YOLO Confirm automatically accepts confirmation dialogs to streamline your gameplay.",
                        order = 0,
                        fontSize = "medium",
                    },
                    lootRolls = {
                        name = "Auto-confirm Loot Rolls",
                        desc = "Automatically confirm loot rolls",
                        type = "toggle",
                        width = "full",
                        order = 1,
                        get = function() return YOLO_Confirm.db.profile.enableLootRolls end,
                        set = function(_, val) YOLO_Confirm.db.profile.enableLootRolls = val end,
                    },
                    deleteItem = {
                        name = "Auto-confirm Item Deletion",
                        desc = "Automatically confirm when deleting items",
                        type = "toggle",
                        width = "full",
                        order = 2,
                        get = function() return YOLO_Confirm.db.profile.enableDeleteItem end,
                        set = function(_, val) YOLO_Confirm.db.profile.enableDeleteItem = val end,
                    },
                    transmog = {
                        name = "Auto-confirm Legendary Transmog",
                        desc = "Automatically confirm when transmogrifying legendary items",
                        type = "toggle",
                        width = "full",
                        order = 3,
                        get = function() return YOLO_Confirm.db.profile.enableTransmog end,
                        set = function(_, val) YOLO_Confirm.db.profile.enableTransmog = val end,
                    },
                    appearance = {
                        name = "Auto-confirm Appearance Collection",
                        desc = "Automatically confirm when collecting appearances",
                        type = "toggle",
                        width = "full",
                        order = 4,
                        get = function() return YOLO_Confirm.db.profile.enableAppearance end,
                        set = function(_, val) YOLO_Confirm.db.profile.enableAppearance = val end,
                    },
                    debugMode = {
                        name = "Debug Mode",
                        desc = "Enable/disable debug messages in chat",
                        type = "toggle",
                        width = "full",
                        order = 5,
                        get = function() return YOLO_Confirm.db.profile.debug end,
                        set = function(_, val) YOLO_Confirm.db.profile.debug = val end,
                    },
                },
            },
        },
    }

    -- Register the options table
    LibStub("AceConfig-3.0"):RegisterOptionsTable("YOLO_Confirm", options)
    
    -- Add to Interface Options
    YOLO_Confirm.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("YOLO_Confirm", "YOLO Confirm")
    
    -- Create slash command
    YOLO_Confirm:RegisterChatCommand("yolo", "ChatCommand")
    YOLO_Confirm:RegisterChatCommand("yoloconfirm", "ChatCommand")
end

function YOLO_Confirm:ChatCommand(input)
    LibStub("AceConfigDialog-3.0"):Open("YOLO_Confirm")
end

-- Run the setup automatically when this file loads
SetupConfig() 
