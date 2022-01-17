local _G = _G
local _, FP = ...

function FP:GetHighestWeeklyRating()
	-- 2v2 is 1, 3v3 is 2, 5v5 is 3 (doesn't exist in retail), rbg is 4.
	local _, _, weeklyBest2v2 = GetPersonalRatedInfo(1)
	local _, _, weeklyBest3v3 = GetPersonalRatedInfo(2)
	local _, _, weeklyBestRBG = GetPersonalRatedInfo(4)
	return math.max(weeklyBest2v2, weeklyBest3v3, weeklyBestRBG)
end

function FP:GetHighestWeeklyRank(highestRating)
	for i = 1, #(FP.RanksRatingIntervals), 1 do
		if highestRating >= FP.RanksRatingIntervals[i] and FP.RanksRatingIntervals[i + 1] ~= nil and highestRating < FP.RanksRatingIntervals[i + 1] then
			return i
		end
	end
end

function FP:SetSectionText(target, textureTarget, value)
	if value <= 0 then
		target:SetText("-")
		if textureTarget then
			textureTarget:Hide()
		end
	else
		target:SetText(string.commavalue(value))
		if textureTarget then
			textureTarget:Show()
		end
	end
end

function FP:SetPlayerFactionTexture()
	local playerFaction, _ = UnitFactionGroup("player")
	_G.FarmPvPFrame_Faction:SetTexture(self.FactionTextures[playerFaction])
end

function FP:SetHighestWeeklyRankTexture()
	local highestWeeklyRating = self:GetHighestWeeklyRating()
	local highestWeeklyRank = self:GetHighestWeeklyRank(highestWeeklyRating)
	_G.FarmPvPFrame_honorWeeklyTotalRankTexture:SetTexture(self.RanksIconMapping[highestWeeklyRank])
end

function FP:SetTitle(title)
	_G.FarmPvPFrame_Title:SetText(title)
end

function FP:SetVersion(version)
	_G.FarmPvPFrame_Version:SetText(version)
end