 if not (GetBuildInfo() == "10.0.0") then return end -- addon requires update for Dragonflight!

local SlotFilterToSlotName = {
	[Enum.ItemSlotFilterType.Head] = INVTYPE_HEAD,
	[Enum.ItemSlotFilterType.Neck] = INVTYPE_NECK,
	[Enum.ItemSlotFilterType.Shoulder] = INVTYPE_SHOULDER,
	[Enum.ItemSlotFilterType.Cloak] = INVTYPE_CLOAK,
	[Enum.ItemSlotFilterType.Chest] = INVTYPE_CHEST,
	[Enum.ItemSlotFilterType.Wrist] = INVTYPE_WRIST,
	[Enum.ItemSlotFilterType.Hand] = INVTYPE_HAND,
	[Enum.ItemSlotFilterType.Waist] = INVTYPE_WAIST,
	[Enum.ItemSlotFilterType.Legs] = INVTYPE_LEGS,
	[Enum.ItemSlotFilterType.Feet] = INVTYPE_FEET,
	[Enum.ItemSlotFilterType.MainHand] = INVTYPE_WEAPONMAINHAND,
	[Enum.ItemSlotFilterType.OffHand] = INVTYPE_WEAPONOFFHAND,
	[Enum.ItemSlotFilterType.Finger] = INVTYPE_FINGER,
	[Enum.ItemSlotFilterType.Trinket] = INVTYPE_TRINKET,
	[Enum.ItemSlotFilterType.Other] = EJ_LOOT_SLOT_FILTER_OTHER,
}

local dungeonIDs = {
    [1] = {
        instanceID = 1194,
        name = STREETS,
    },
    [2] = {
        instanceID = 1194,
        name = GAMBIT,
    },
    [3] = {
        instanceID = 1178,
        name = JUNKYARD,
    },
    [4] = {
        instanceID = 1178,
        name = WORKSHOP,
    },
    [5] = {
        instanceID = 860,
        name = LOWERKARA,
    },
    [6] = {
        instanceID = 860,
        name = UPPERKARA,
    },
    [7] = {
        instanceID = 536,
    },
    [8] = {
        instanceID = 558,
    }
}

local _, currentClass = UnitClass("player")

local classes = {
    DEATHKNIGHT = 1,
    DEMONHUNTER = 2,
    DRUID = 3,
    EVOKER = 4,
    HUNTER = 5,
    MAGE = 6,
    MONK = 7,
    PALADIN = 8,
    PRIEST = 9,
    ROGUE = 10,
    SHAMAN = 11,
    WARLOCK = 12,
    WARRIOR = 13,
}

currentClass = classes[currentClass]

-- loot table from https://www.wowhead.com/news/list-of-currently-confirmed-loot-drops-from-season-4-mythic-grimrail-depot-iron-328237
local lootTable = {
    Grimrail = {
        [109866] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
        [109846] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
    	[109972] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
    	[109932] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
    	[109901] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
    	[109869] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
    	[109978] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
    	[109937] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
    	[109897] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
    	[109934] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
    	[109983] = {classes.HUNTER, classes.SHAMAN},
    	[109890] = {classes.HUNTER, classes.SHAMAN},
    	[109942] = {classes.HUNTER, classes.SHAMAN},
    	[109895] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
    	[109988] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
    	[109840] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
    	[109821] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
    	[109946] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
    	[110052] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR}, --1h str mace
    	[110053] = {classes.PALADIN, classes.SHAMAN, classes.WARRIOR}, -- str int shield
    	[110054] = {classes.DRUID, classes.MAGE, classes.MONK, classes.PRIEST, classes.SHAMAN, classes.WARLOCK}, -- int staff
    	[110051] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR}, -- 2h str axe
    	[109996] = {classes.DEMONHUNTER, classes.DRUID, classes.HUNTER, classes.MONK, classes.ROGUE, classes.SHAMAN}, -- agi trinket
    	[110001] = {classes.DRUID, classes.MAGE, classes.MONK, classes.PALADIN, classes.PRIEST, classes.SHAMAN, classes.WARLOCK}, -- int trinket
    },
    IronDocks = {
        [109881] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
        [109903] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
        [109948] = {classes.MAGE, classes.PRIEST, classes.WARLOCK},
        [109979] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
        [109885] = {classes.DEMONHUNTER, classes.DRUID, classes.MONK, classes.ROGUE},
        [109875] = {classes.HUNTER, classes.SHAMAN},
        [109887] = {classes.HUNTER, classes.SHAMAN},
        [109980] = {classes.HUNTER, classes.SHAMAN},
        [109939] = {classes.HUNTER, classes.SHAMAN},
        [109879] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
        [109859] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
        [109802] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
        [109822] = {classes.DEATHKNIGHT, classes.PALADIN, classes.WARRIOR},
        [110058] = {classes.DEMONHUNTER, classes.MONK, classes.ROGUE}, -- 1h agi fist
        [110056] = {classes.HUNTER}, -- gun
        [110055] = {classes.DEMONHUNTER, classes.MONK, classes.ROGUE, classes.SHAMAN}, -- 1h agi axe
        [110057] = {classes.DRUID, classes.MONK, classes.PALADIN, classes.PRIEST, classes.SHAMAN}, -- 1h int mace
        [110059] = {classes.DRUID, classes.HUNTER, classes.MONK}, -- 2h agi staff
        [110060] = {classes.MAGE, classes.PRIEST, classes.WARLOCK}, -- wand
        [110017] = {classes.DEATHKNIGHT, classes.DEMONHUNTER, classes.DRUID, classes.HUNTER, classes.MAGE, classes.MONK, classes.PALADIN, classes.PRIEST, classes.ROGUE, classes.SHAMAN, classes.WARLOCK, classes.WARRIOR}, -- vers trinket
        [110002] = {classes.DRUID, classes.MAGE, classes.MONK, classes.PALADIN, classes.PRIEST, classes.SHAMAN, classes.WARLOCK}, -- int trinket
        [109997] = {classes.DEMONHUNTER, classes.DRUID, classes.HUNTER, classes.MONK, classes.ROGUE, classes.SHAMAN}, -- agi trinket
    },
}

-- simplify lootTable down to [itemid] = boolean based on the currently logged in class
for dungeon, dungeonLoot in pairs(lootTable) do
    for itemID, usableClasses in pairs(dungeonLoot) do
        local change
        for _, class in pairs(usableClasses) do
            if currentClass == class then
                lootTable[dungeon][itemID] = true
                change = true
                break
            end
        end
        if not change then
            lootTable[dungeon][itemID] = nil
        end
    end
end


local doOnce = true

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "Blizzard_EncounterJournal" then

        local STREETS = C_ChallengeMode.GetMapUIInfo(391)
        local GAMBIT = C_ChallengeMode.GetMapUIInfo(392)
        local JUNKYARD = C_ChallengeMode.GetMapUIInfo(369)
        local WORKSHOP = C_ChallengeMode.GetMapUIInfo(370)
        local LOWERKARA = C_ChallengeMode.GetMapUIInfo(227)
        local UPPERKARA = C_ChallengeMode.GetMapUIInfo(234)
        local GRIMRAIL = "" -- language dependent, but will leave as original journal name, not M+ name
        local IRONDOCKS = ""

        
        local dropDownOptionSelected = false
        local selectedDungeon = nil
        
        hooksecurefunc("EncounterJournal_TierDropDown_Select", function()
            dropDownOptionSelected = false
            selectedDungeon = nil
        end)
        
        local includedEncounterIDs = {}
        
        local function EncounterJournal_TierDropDown_Select(self, tier)
            dropDownOptionSelected = true
            UIDropDownMenu_SetText(EncounterJournal.instanceSelect.tierDropDown, CHALLENGES)
            EncounterJournal_ListInstances()
        end
        
        hooksecurefunc("EncounterJournal_ListInstances", function()
            if dropDownOptionSelected and (EncounterJournal.selectedTab == 2) then -- dungeons
                local dataProvider = CreateDataProvider();
            	for _, data in ipairs(dungeonIDs) do
                    local name, description, _, buttonImage, _, _, _, link, _, mapID = EJ_GetInstanceInfo(data.instanceID)
            		dataProvider:Insert({
            			instanceID = data.instanceID,
            			name = name,
            			description = description,
            			buttonImage = buttonImage,
            			link = link,
            			mapID = mapID,
            		});
            	end
            
            	EncounterJournal.instanceSelect.ScrollBox:SetDataProvider(dataProvider);
                
                GRIMRAIL = EncounterJournalInstanceSelect.ScrollBox:Find(7).name
                IRONDOCKS = EncounterJournalInstanceSelect.ScrollBox:Find(8).name
                
                if doOnce then
                    doOnce = false
                    local function buttonHandler(self)
                        if not dropDownOptionSelected then return end
                        local name = self.name:GetText()
                        EncounterJournalEncounterFrameInfoInstanceTitle:SetText(CHALLENGES.." - "..name)
                        EncounterJournalNavBarButton2:SetText(CHALLENGES.." - "..name)
                        
                        -- make it wider
                        EncounterJournalNavBarButton2:SetWidth(EncounterJournalNavBarButton2:GetWidth() + 200)
                    end
                    
                    for i = 1, 8 do
                        local button = EncounterJournalInstanceSelect.ScrollBox:GetView():GetFrames()[i]
                        local e = button:GetScript("OnClick")
                        button:SetScript("OnClick", function(self)
                            selectedDungeon = self.name:GetText()
                            wipe(includedEncounterIDs)
                            e(self)
                            buttonHandler(self)
                        end)
                    end
                end
            end
        end) 
        
        local oEJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
        function EJ_GetEncounterInfoByIndex(index, ...)
            local encounterID = select(3, oEJ_GetEncounterInfoByIndex(index, ...))
            
            if selectedDungeon then
                if selectedDungeon == STREETS then
                    if index > 5 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == GAMBIT then
                    if index < 4 then
                        index = index + 5
                    else
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == JUNKYARD then
                    if index > 4 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == WORKSHOP then
                    if index < 5 then
                        index = index + 4
                    else
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == LOWERKARA then
                    if index > 6 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == UPPERKARA then
                    if index < 7 then
                        index = index + 6
                    else
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                end
                encounterID = select(3, oEJ_GetEncounterInfoByIndex(index, ...))
                if encounterID then
                    includedEncounterIDs[encounterID] = true
                end
            end
            return oEJ_GetEncounterInfoByIndex(index, ...)
        end
        
        hooksecurefunc("EJTierDropDown_Initialize", function(self, level)
        	if not (EncounterJournal.selectedTab == 2) then return end -- dungeons only
            
            local info = UIDropDownMenu_CreateInfo();
        
        	info.text = CHALLENGES
        	info.func = EncounterJournal_TierDropDown_Select
        	info.checked = dropDownOptionSelected
        	info.arg1 = nil
        	UIDropDownMenu_AddButton(info, level)
        end)
        
        EncounterJournalNavBarHomeButton:HookScript("OnClick", function()
            if dropDownOptionSelected then
                EncounterJournal_TierDropDown_Select()
            end
        end)
        
        local oEJ_GetNumLoot = EJ_GetNumLoot
        local oGetLootInfoByIndex = C_EncounterJournal.GetLootInfoByIndex
        local loot = {}
        function EJ_GetNumLoot()
            if EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle then EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Show() end
            --if EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle then EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:Show() end
            if EncounterJournalEncounterFrameInfoDifficulty then EncounterJournalEncounterFrameInfoDifficulty:Show() end
            
            wipe(loot)
            local r = oEJ_GetNumLoot()
            if not selectedDungeon then return r end
            
            if (selectedDungeon == GRIMRAIL) or (selectedDungeon == IRONDOCKS) then
                --EJ_SetLootFilter(0, 0)
                EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Hide()
                --EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:Hide()
                EncounterJournalEncounterFrameInfoDifficulty:Hide()
                C_Timer.After(0.1, function() EncounterJournalEncounterFrameInfoDifficulty:Hide() end)
                
                local dungeonTable = lootTable.Grimrail
                if selectedDungeon == IRONDOCKS then dungeonTable = lootTable.IronDocks end
                
                local lootIndex = 1
                for itemID in pairs(dungeonTable) do
                    local itemInfo = {}
                    itemInfo.itemID = 0
                    itemInfo.encounterID = 1133
                    if selectedDungeon == IRONDOCKS then itemInfo.encounterID = 1238 end
                    itemInfo.lootIndex = lootIndex
                    itemInfo.displayAsPerPlayerLoot = false
                    itemInfo.itemQuality = "ffa335ee"
                    
                    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID) 
                    itemInfo.link = "|cffa335ee|Hitem:"..itemID.."::::::::60:64::16:8:7359:8266:8765:8136:8117:6652:3170:6646:1:28:1279:::::|h[Item Name Unknown]|h|r"
                    itemInfo.name = itemName
                    
                    -- all weapons use the same filter in the dungeon journal
                    if (itemEquipLoc == "INVTYPE_2HWEAPON") or (itemEquipLoc == "INVTYPE_WEAPON") or (itemEquipLoc == "INVTYPE_RANGEDRIGHT") then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end
                    
                    for enumName, localisedName in pairs(SlotFilterToSlotName) do
                        if _G[itemEquipLoc] == localisedName then
                            itemInfo.filterType = enumName
                        end
                    end
                    if not itemInfo.filterType then itemInfo.filterType = "Unknown" end
                    itemInfo.icon = itemTexture
                    itemInfo.armorType = itemType
                    itemInfo.slot = itemSubType
                    
                    if itemInfo.filterType then
                        if (itemInfo.filterType == C_EncounterJournal.GetSlotFilter()) or (C_EncounterJournal.GetSlotFilter() == 15) then
                            lootIndex = lootIndex + 1
                            table.insert(loot, itemInfo)
                        end
                    end
                end
                return #loot
            end
            
            for i = 1, r do
                local itemInfo = oGetLootInfoByIndex(i)
                
                if (includedEncounterIDs[itemInfo.encounterID]) and itemInfo then
                    if itemInfo.link and not ((selectedDungeon == STREETS) or (selectedDungeon == GAMBIT)) then
                        -- Kara
                        itemInfo.link = itemInfo.link:gsub("::23:1:3524:1:28:1180:", "::87:8:8252:8765:6652:7749:8136:8116:3164:6646:1:28:1180:")
                        
                        -- Mechagon
                        itemInfo.link = itemInfo.link:gsub("::23:1:3524:1:28:1264:", "::33:7:8280:8765:8136:8138:6652:3136:6646:1:28:464:")
                    end
                    
                    table.insert(loot, itemInfo)
                end
            end
            return #loot
        end
        
        function C_EncounterJournal.GetLootInfoByIndex(index, encounterIndex)
            if encounterIndex then
                return oGetLootInfoByIndex(index, encounterIndex)
            end
            
            if (not selectedDungeon) then
                return oGetLootInfoByIndex(index, encounterIndex)
            end
            
            return loot[index]
        end
        
        -- when the EJ is closed, clear all custom settings
        local restore
        local restore2
        EncounterJournal:HookScript("OnHide", function()
            restore = dropDownOptionSelected
            restore2 = selectedDungeon
            dropDownOptionSelected = nil
            selectedDungeon = nil
        end)
        
        -- when the EJ is opened back up again, if the custom option was previously selected, select it again
        -- wont update until the player scrolls or clicks something
        EncounterJournal:HookScript("OnShow", function()
            if restore then
                dropDownOptionSelected = restore
                selectedDungeon = restore2
                restore = nil
                restore2 = nil
            end
        end)
        
        local oEJ_GetNumEncountersForLootByIndex = EJ_GetNumEncountersForLootByIndex
        function EJ_GetNumEncountersForLootByIndex(...)
            if selectedDungeon then return 1 end
            return oEJ_GetNumEncountersForLootByIndex(...)
        end

    end
end)