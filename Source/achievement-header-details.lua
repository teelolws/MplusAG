local addonName, addon = ...

-- Restores the achievement UI back to the old expanded layout, moving the new Back and Search features to somewhere out of the way
function addon:initAchievementHeaderDetails()
    if not addon.db.profile.achievementHeaderDetailsRemoval then return end
    
    AchievementFrame.HeaderDetails.Back:ClearAllPoints()
    AchievementFrame.HeaderDetails.Back:SetPoint("BOTTOM", AchievementFrameCategories, "TOPRIGHT", 0, 10)
    
    AchievementFrame.HeaderDetails.Filters:ClearAllPoints()
    AchievementFrame.HeaderDetails.Filters:SetPoint("TOPRIGHT", AchievementFrame, "BOTTOMRIGHT", -20, 6)
    
    ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS = 4
    AchievementFrameSummary:SetPoint("TOPLEFT", AchievementFrame, "TOPLEFT", 218, -20)
    AchievementFrameSummaryCategories:SetPoint("TOPLEFT", AchievementFrameSummaryAchievements, "BOTTOMLEFT", 0, 5)
    
    AchievementFrameAchievements:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPRIGHT", 22, 0)
    AchievementFrameStats:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPRIGHT", 22, 0)
end
