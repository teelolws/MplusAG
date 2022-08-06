if GetBuildInfo() ~= "9.2.5" then return end -- addon obsolete in Dragonflight!

local doOnce = true

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "Blizzard_EncounterJournal" then

        
        
        local dropDownOptionSelected = false
        local selectedDungeon = nil
        
        hooksecurefunc("EncounterJournal_TierDropDown_Select", function()
            dropDownOptionSelected = false
            selectedDungeon = nil
        end)
        
        local includedEncounterIDs = {}
        
        local function EncounterJournal_TierDropDown_Select(self, tier)
            dropDownOptionSelected = true
            UIDropDownMenu_SetText(EncounterJournal.instanceSelect.tierDropDown, "Season 4")
            
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
                EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton1.name:SetText("Streets")
                
                updateButton(1989, EncounterJournalInstanceSelectScrollFrameinstance2)
                EncounterJournalInstanceSelectScrollFrameinstance2.name:SetText("Gambit")
                
                -- Mechagon
                updateButton(1490, EncounterJournalInstanceSelectScrollFrameinstance3)
                EncounterJournalInstanceSelectScrollFrameinstance3.name:SetText("Junkyard")
                
                updateButton(1490, EncounterJournalInstanceSelectScrollFrameinstance4)
                EncounterJournalInstanceSelectScrollFrameinstance4.name:SetText("Workshop")
                
                -- Karazhan
                updateButton(809, EncounterJournalInstanceSelectScrollFrameinstance5)
                EncounterJournalInstanceSelectScrollFrameinstance5.name:SetText("Lower")
                
                updateButton(809, EncounterJournalInstanceSelectScrollFrameinstance6)
                EncounterJournalInstanceSelectScrollFrameinstance6.name:SetText("Upper")
                
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
                        EncounterJournalEncounterFrameInfoInstanceTitle:SetText("Season 4 - "..name)
                        EncounterJournalNavBarButton2:SetText("Season 4 - "..name)
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
                if selectedDungeon == "Streets" then
                    if index > 5 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == "Gambit" then
                    if index < 4 then
                        index = index + 5
                    else
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == "Junkyard" then
                    if index > 4 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == "Workshop" then
                    if index < 5 then
                        index = index + 4
                    else
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == "Lower" then
                    if index > 6 then
                        includedEncounterIDs[encounterID] = nil
                        return nil
                    end
                elseif selectedDungeon == "Upper" then
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
        
        	info.text = "Season 4"
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
            if not ((selectedDungeon == "Streets") or (selectedDungeon == "Gambit") or (selectedDungeon == "Junkyard") or (selectedDungeon == "Workshop") or (selectedDungeon == "Lower") or (selectedDungeon == "Upper")) then
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
            
            if (not selectedDungeon) or (not ((selectedDungeon == "Streets") or (selectedDungeon == "Gambit") or (selectedDungeon == "Junkyard") or (selectedDungeon == "Workshop") or (selectedDungeon == "Lower") or (selectedDungeon == "Upper"))) then
                return oGetLootInfoByIndex(index, encounterIndex)
            end
            
            return loot[index]
        end

    end
end)