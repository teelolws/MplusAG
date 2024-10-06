local addonName, addon = ...

-- from Blizzard_DelvesDashboardUI.lua
local function hasActiveSeason()
	local uiDisplaySeason = C_DelvesUI.GetCurrentDelvesSeasonNumber();
    return uiDisplaySeason and uiDisplaySeason > 0;
end

local function addTopDelveRunsToTooltip()
	local activities = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.World)
	local totalMaxCompleted = 0
	for _, activity in ipairs(activities) do
		if activity.level and (activity.level == 8) then
			totalMaxCompleted = activity.progress
		end
	end
    
    if totalMaxCompleted > 7 then return end
    
    GameTooltip_AddBlankLineToTooltip(GameTooltip);
    GameTooltip_AddHighlightLine(GameTooltip, "Delves needed at Tier 8: "..(8 - totalMaxCompleted))
    
    GameTooltip:Show()
end

function addon:initDelvesProgressTooltip()
    if not addon.db.profile.delvesProgressTooltip then return end
    if not hasActiveSeason() then return end
    
    for i, activity in ipairs(WeeklyRewardsFrame.Activities) do
        if activity ~= WeeklyRewardsFrame.ConcessionFrame then
            hooksecurefunc(activity, "ShowIncompleteTooltip", function(self, title, description, formatRemainingProgress, addProgressLineCallback)
                -- Check Blizzard_WeeklyRewards.lua for any important changes
                if (description == GREAT_VAULT_REWARDS_WORLD_INCOMPLETE) or (description == GREAT_VAULT_REWARDS_WORLD_COMPLETED_FIRST) or (description == GREAT_VAULT_REWARDS_WORLD_COMPLETED_SECOND) then
                    addTopDelveRunsToTooltip()
                end
            end)
            
            hooksecurefunc(activity, "HandlePreviewWorldRewardTooltip", function(self, itemLevel, upgradeItemLevel, nextLevel)
                if upgradeItemLevel then
                    addTopDelveRunsToTooltip()
                end
            end)
        end
    end
end