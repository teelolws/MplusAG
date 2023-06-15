local addonName, addon = ...

function addon:setupOptions()
    local defaults = {
        profile = {
            highestFortTyr = true,
            itemUpgrade = true,
            lootTab = true,
            portalButtons = true,
            watermark = true,
        },
    }
        
    addon.db = LibStub("AceDB-3.0"):New("MPlusAdventureGuideADB", defaults)
        
    local options = {
        type = "group",
        args = {
            description = {
                name = "All changes require a /reload to take effect!",
                type = "description",
                fontSize = "medium",
                order = 0,
            },
            highestFortTyr = {
                type = "toggle",
                name = "Enable Highest Fortified/Tyrannical Module",
                set = function(info, v) addon.db.profile.highestFortTyr = v end,
                get = function() return addon.db.profile.highestFortTyr end,
            },
            showCompleted = {
                type = "toggle",
                name = "Enable Item Upgrade Range Module",
                set = function(info, v) addon.db.profile.itemUpgrade = v end,
                get = function() return addon.db.profile.itemUpgrade end,
            },
            showEventInfo = {
                type = "toggle",
                name = "Enable Loot Tab Module",
                set = function(info, v) addon.db.profile.lootTab = v end,
                get = function() return addon.db.profile.lootTab end,
            },
            showCoordinates = {
                type = "toggle",
                name = "Enable Portal Buttons Module",
                set = function(info, v) addon.db.profile.portalButtons = v end,
                get = function() return addon.db.profile.portalButtons end,
            },
            hideZoneCaldera = {
                type = "toggle",
                name = "Enable Watermark Module",
                set = function(info, v) addon.db.profile.watermark = v end,
                get = function() return addon.db.profile.watermark end,
            },
        },
    }

    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"mplusadventureguide"})
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
end
