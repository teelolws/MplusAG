local addonName, addon = ...

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    addon:setupOptions()
    addon:initWatermark()
    
    C_Timer.After(0.1, function()
        EventUtil.ContinueOnAddOnLoaded("Blizzard_ChallengesUI", function()
            addon:initHighestFortTyr()
            addon:initPortalButtons()
        end)
        
        EventUtil.ContinueOnAddOnLoaded("Blizzard_EncounterJournal", function()
            addon:initLootTab()
        end)
    end)
end)
