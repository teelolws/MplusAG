local addonName, addon = ...

function addon:initThreeAffixFix()
    if not addon.db.profile.threeAffixFix then return end
    
    hooksecurefunc(ChallengesFrame.WeeklyInfo, "SetUp", function()
    	local affixes = C_MythicPlus.GetCurrentAffixes()
    	if affixes and (#affixes == 3) then
    		ChallengesFrame.WeeklyInfo.Child.Affixes[1]:SetPoint("CENTER", ChallengesFrame.WeeklyInfo.Child.ThisWeekLabel, "CENTER", -64, -45)
    	end
    end)
end
