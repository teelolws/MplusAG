local addonName, addon = ...

-- Restores the achievement UI back to the old expanded layout, moving the new Back and Search features to somewhere out of the way
function addon:initAchievementHeaderDetails()
    if not addon.db.profile.achievementHeaderDetailsRemoval then return end
    
    AchievementFrame.HeaderDetails.Back:ClearAllPoints()
    AchievementFrame.HeaderDetails.Back:SetPoint("BOTTOM", AchievementFrameCategories, "TOPRIGHT", 0, 10)
    
    ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS = 4
    AchievementFrameSummary:SetPoint("TOPLEFT", AchievementFrame, "TOPLEFT", 218, -20)
    AchievementFrameSummaryCategories:SetPoint("TOPLEFT", AchievementFrameSummaryAchievements, "BOTTOMLEFT", 0, 5)
    
    AchievementFrameAchievements:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPRIGHT", 22, 0)
    AchievementFrameStats:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPRIGHT", 22, 0)
    
    hooksecurefunc(AchievementFrame.HeaderDetails.Filters, "Layout", function()
        if AchievementFrame.HeaderDetails.Filters.FilterDropdown:IsVisible() then
            AchievementFrame.HeaderDetails.Filters.FilterDropdown:ClearAllPoints()
            AchievementFrame.HeaderDetails.Filters.FilterDropdown:SetPoint("LEFT", AchievementFrame.Header.PointBorder, "RIGHT", 76, 5)
            AchievementFrame.HeaderDetails.Filters.SearchBox:ClearAllPoints()
            AchievementFrame.HeaderDetails.Filters.SearchBox:SetPoint("BOTTOM", AchievementFrame.HeaderDetails.Filters.FilterDropdown, "TOP", 7, 10)
        else
            AchievementFrame.HeaderDetails.Filters.SearchBox:ClearAllPoints()
            AchievementFrame.HeaderDetails.Filters.SearchBox:SetPoint("LEFT", AchievementFrame.Header.PointBorder, "RIGHT", 77, 5)
        end
    end)
end
