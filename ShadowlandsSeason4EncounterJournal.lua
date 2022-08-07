if GetBuildInfo() ~= "9.2.5" then return end -- addon obsolete in Dragonflight!

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
                
                -- Iron Docks
                updateButton(595, EncounterJournalInstanceSelectScrollFrameinstance8)
                
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
                else
                    return oEJ_GetEncounterInfoByIndex(index, ...)
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
            wipe(loot)
            local r = oEJ_GetNumLoot()
            if not selectedDungeon then return r end
            if not ((selectedDungeon == STREETS) or (selectedDungeon == GAMBIT) or (selectedDungeon == JUNKYARD) or (selectedDungeon == WORKSHOP) or (selectedDungeon == LOWERKARA) or (selectedDungeon == UPPERKARA)) then
                return r
            end
            
            for i = 1, r do
                local itemInfo = oGetLootInfoByIndex(i)
                
                if (includedEncounterIDs[itemInfo.encounterID]) then
                    table.insert(loot, itemInfo)
                end
            end
            return #loot
        end
        
        function C_EncounterJournal.GetLootInfoByIndex(index, encounterIndex)
            if encounterIndex then
                return oGetLootInfoByIndex(index, encounterIndex)
            end
            
            if (not selectedDungeon) or (not ((selectedDungeon == STREETS) or (selectedDungeon == GAMBIT) or (selectedDungeon == JUNKYARD) or (selectedDungeon == WORKSHOP) or (selectedDungeon == LOWERKARA) or (selectedDungeon == UPPERKARA))) then
                return oGetLootInfoByIndex(index, encounterIndex)
            end
            
            return loot[index]
        end

    end
end)