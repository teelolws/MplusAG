 if not ((GetBuildInfo() == "9.2.5") or (GetBuildInfo() == "9.2.7")) then return end -- addon obsolete in Dragonflight!

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

-- loot table from https://www.wowhead.com/news/list-of-currently-confirmed-loot-drops-from-season-4-mythic-grimrail-depot-iron-328237
local lootTable = {
    Grimrail = {
        [109866] = true,
        [109846] = true,
    	[109972] = true,
    	[109932] = true,
    	[109901] = true,
    	[109869] = true,
    	[109978] = true,
    	[109937] = true,
    	[109897] = true,
    	[109934] = true,
    	[109983] = true,
    	[109890] = true,
    	[109942] = true,
    	[109895] = true,
    	[109988] = true,
    	[109840] = true,
    	[109821] = true,
    	[109946] = true,
    	[110052] = true,
    	[110053] = true,
    	[110054] = true,
    	[110051] = true,
    	[109996] = true,
    	[110001] = true,
    },
    IronDocks = {
        [109881] = true,
        [109903] = true,
        [109948] = true,
        [109979] = true,
        [109885] = true,
        [109875] = true,
        [109887] = true,
        [109980] = true,
        [109939] = true,
        [109879] = true,
        [109859] = true,
        [109802] = true,
        [109822] = true,
        [110058] = true,
        [110056] = true,
        [110055] = true,
        [110057] = true,
        [110059] = true,
        [110060] = true,
        [110017] = true,
        [110002] = true,
        [109997] = true,
    },
}


-- red text detection code from: https://authors.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/224910-detect-wether-a-class-can-use-an-item#c1
local scanningTooltip = CreateFrame('GameTooltip', 'Season4EncounterJournalScanningTooltip')
scanningTooltip:AddFontStrings(
    scanningTooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
    scanningTooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
)
scanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
local function IsTextRed(text)
  if text and text:GetText() then
    local r,g,b = text:GetTextColor()
    return math.floor(r*256) == 255 and math.floor(g*256) == 32 and math.floor(b*256) == 32
  end
end
local function SetItemHandler(self)
  local tooltipName = self:GetName()
  local name, link = self:GetItem()
  self.usable = true
  for i = 1, self:NumLines() do
    if IsTextRed(_G[tooltipName..'TextLeft'..i]) or IsTextRed(_G[tooltipName..'TextRight'..i]) then
      self.usable = false
      break
    end
  end
  self:Hide()
end
scanningTooltip:SetScript('OnTooltipSetItem', SetItemHandler)


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
            UIDropDownMenu_SetText(EncounterJournal.instanceSelect.tierDropDown, SL_SEASON_NUMBER:format(4))
            
            if EncounterJournal.selectedTab == 2 then -- dungeons
                function updateButton(mapID, instanceButton)
                    if not instanceButton then return end
                    local instanceID = EJ_GetInstanceForMap(mapID)
                    
                    local name, description, _, buttonImage, _, _, _, link, _, mapID = EJ_GetInstanceInfo(instanceID)
                    
                    instanceButton.name:SetText(name);
            		instanceButton.bgImage:SetTexture(buttonImage);
            		instanceButton.instanceID = instanceID;
            		instanceButton.tooltipTitle = name;
            		instanceButton.tooltipText = description;
            		instanceButton.link = link;
            		instanceButton.mapID = mapID; 
            		instanceButton:Show();
            		instanceButton.ModifiedInstanceIcon:Hide();
                end
                
                -- Tazavesh
                updateButton(1989, EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1)
                EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1.name:SetText(STREETS)

                updateButton(1989, EncounterJournalInstanceSelectScrollFrameinstance2)
                EncounterJournalInstanceSelectScrollFrameinstance2.name:SetText(GAMBIT)
                
                -- Mechagon
                updateButton(1490, EncounterJournalInstanceSelectScrollFrameinstance3)
                EncounterJournalInstanceSelectScrollFrameinstance3.name:SetText(JUNKYARD)
                
                updateButton(1490, EncounterJournalInstanceSelectScrollFrameinstance4)
                EncounterJournalInstanceSelectScrollFrameinstance4.name:SetText(WORKSHOP)
                
                -- Karazhan
                updateButton(809, EncounterJournalInstanceSelectScrollFrameinstance5)
                EncounterJournalInstanceSelectScrollFrameinstance5.name:SetText(LOWERKARA)
                
                updateButton(809, EncounterJournalInstanceSelectScrollFrameinstance6)
                EncounterJournalInstanceSelectScrollFrameinstance6.name:SetText(UPPERKARA)
                
                -- Grimrail Depot
                updateButton(606, EncounterJournalInstanceSelectScrollFrameinstance7)
                GRIMRAIL = EncounterJournalInstanceSelectScrollFrameinstance7.name:GetText()
                
                -- Iron Docks
                updateButton(595, EncounterJournalInstanceSelectScrollFrameinstance8)
                IRONDOCKS = EncounterJournalInstanceSelectScrollFrameinstance8.name:GetText()
                
                for i = 9, 20 do
                    local button = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i]
                    if button then
                        button:Hide()
                    end
                end
                
                if doOnce then
                    doOnce = false
                    local function buttonHandler(self)
                        if not dropDownOptionSelected then return end
                        local name = self.name:GetText()
                        EncounterJournalEncounterFrameInfoInstanceTitle:SetText(SL_SEASON_NUMBER:format(4).." - "..name)
                        EncounterJournalNavBarButton2:SetText(SL_SEASON_NUMBER:format(4).." - "..name)
                        
                        -- make it wider
                        EncounterJournalNavBarButton2:SetWidth(EncounterJournalNavBarButton2:GetWidth() + 200)
                    end
                    
                    for i = 1, 8 do
                        local button = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i]
                        if i == 1 then
                            button = EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1
                        end
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
        end 
        
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
        	if not (EncounterJournal.selectedTab == 2) then return end -- dungeons only, for raids just click the one marked Fated
            
            local info = UIDropDownMenu_CreateInfo();
        
        	info.text = SL_SEASON_NUMBER:format(4)
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
            if EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle then EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:Show() end
            if EncounterJournalEncounterFrameInfoDifficulty then EncounterJournalEncounterFrameInfoDifficulty:Show() end
            
            wipe(loot)
            local r = oEJ_GetNumLoot()
            if not selectedDungeon then return r end
            
            if (selectedDungeon == GRIMRAIL) or (selectedDungeon == IRONDOCKS) then
                EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Hide()
                EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:Hide()
                EncounterJournalEncounterFrameInfoDifficulty:Hide()
                C_Timer.After(0.1, function() EncounterJournalEncounterFrameInfoDifficulty:Hide() end)
                
                local dungeonTable = lootTable.Grimrail
                if selectedDungeon == IRONDOCKS then dungeonTable = lootTable.IronDocks end
                
                local itemInfo = oGetLootInfoByIndex(1)
                if itemInfo.link then
                    for itemID in pairs(lootTable.Grimrail) do
                        scanningTooltip:SetHyperlink("item:"..itemID)
                        if scanningTooltip.usable then
                            
                            local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID) 
                            itemInfo.link = "|cffa335ee|Hitem:"..itemID.."::::::::60:64::16:8:7359:8266:8765:8136:8117:6652:3170:6646:1:28:1279:::::|h[Thunderlord Flamestaff]|h|r"
                            itemInfo.name = itemName
                            for enumName, localisedName in pairs(SlotFilterToSlotName) do
                                if _G[itemEquipLoc] == localisedName then
                                    itemInfo.filterType = enumName
                                end
                            end
                            itemInfo.icon = itemTexture
                            itemInfo.armorType = itemType
                            itemInfo.slot = itemSubType
                            table.insert(loot, itemInfo)
                        end
                        itemInfo = oGetLootInfoByIndex(1)
                    end
                    return #loot
                end
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
        EncounterJournal:HookScript("OnShow", function()
            if restore then
                dropDownOptionSelected = restore
                selectedDungeon = restore2
                EncounterJournal_TierDropDown_Select()
            end
        end)

    end
end)