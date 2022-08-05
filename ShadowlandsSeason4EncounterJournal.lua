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
                            e(self)
                            buttonHandler(self)
                        end)
                    end
                end
            end
        end 
        
        local o = EJ_GetEncounterInfoByIndex
        function EJ_GetEncounterInfoByIndex(index, ...)
            if selectedDungeon then
                if selectedDungeon == "Streets" then
                    if index > 5 then
                        return nil
                    end
                elseif selectedDungeon == "Gambit" then
                    if index < 4 then
                        index = index + 5
                    else
                        return nil
                    end
                elseif selectedDungeon == "Junkyard" then
                    if index > 4 then
                        return nil
                    end
                elseif selectedDungeon == "Workshop" then
                    if index < 5 then
                        index = index + 4
                    else
                        return nil
                    end
                elseif selectedDungeon == "Lower" then
                    if index > 4 then
                        return nil
                    end
                elseif selectedDungeon == "Upper" then
                    if index < 5 then
                        index = index + 4
                    else
                        return nil
                    end
                end
            end
            return o(index, ...)
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

    end
end)