local YOLO_Confirm = LibStub("AceAddon-3.0"):NewAddon("YOLO_Confirm", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

-- Utility function for debug messages - defined early so it's available immediately
function YOLO_Confirm:DebugMsg(message)
    if self.db and self.db.profile and self.db.profile.debug then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF99YOLO_Confirm|r: " .. message)
    end
end

-- Regular message function - used for user-facing information
function YOLO_Confirm:PrintMsg(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF99YOLO_Confirm|r: " .. message)
end

function YOLO_Confirm:OnInitialize()
    -- Print initialization message
    self:PrintMsg("Addon initialized")
    
    -- Register for loot roll confirmation
    self:RegisterEvent("CONFIRM_LOOT_ROLL")
    
    -- Wait until the UI is loaded before hooking frames
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    self:DebugMsg("Events registered")
end

function YOLO_Confirm:PLAYER_ENTERING_WORLD()
    -- Unregister to ensure this only runs once
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    
    -- Hook all static popup frames
    for i = 1, 4 do
        local frame = _G["StaticPopup" .. i]
        if frame then
            self:SecureHookScript(frame, "OnShow", "HandleStaticPopup")
            self:DebugMsg("Hooked StaticPopup" .. i)
        end
    end
end

function YOLO_Confirm:HandleStaticPopup(frame)
    -- Get the popup type from the frame
    local which = frame.which
    if not which then return end
    
    self:DebugMsg("Popup shown: " .. tostring(which))
    
    -- Check if this is a dialog we want to auto-confirm
    if which == "DELETE_ITEM" and self.db.profile.enableDeleteItem then
        self:DebugMsg("Auto-confirming item deletion")
        frame.button1:Click()
        return
    elseif which == "CONFIRM_TRANSMOGRIFY_LEGENDARY" and self.db.profile.enableTransmog then
        self:DebugMsg("Auto-confirming legendary transmog")
        frame.button1:Click()
        return
    elseif which == "CONFIRM_COLLECT_APPEARANCE" and self.db.profile.enableAppearance then
        self:DebugMsg("Auto-confirming appearance collection")
        
        -- Just click the confirmation button
        frame.button1:Click()
        
        -- Only use the API if it exists (for retail WoW)
        if C_TransmogCollection and frame.data then
            C_TransmogCollection.ConfirmCollectAppearanceFromItem(frame.data)
        end
        
        return
    end
    
    -- For other popups, do nothing and let them show normally
end

function YOLO_Confirm:CONFIRM_LOOT_ROLL(event, rollID, rollType, confirmReason)
    -- Check if loot roll confirmation is enabled
    if not self.db.profile.enableLootRolls then
        self:DebugMsg("Loot roll confirmation is disabled - skipping")
        return
    end
    
    self:DebugMsg("Auto-confirming loot roll - ID: " .. tostring(rollID) .. ", Type: " .. tostring(rollType))
    ConfirmLootRoll(rollID, rollType)
end
