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

function FP:ShowHideSections()
	local playerLevel = UnitLevel("player")
	if playerLevel ~= 60 then
		_G.FarmPvPFrame_conquest:Hide()
		_G.FarmPvPFrame_conquestTexture:Hide()
		_G.FarmPvPFrame_conquestRankTexture:Hide()
		_G.FarmPvPFrame_conquestRank:Hide()

		_G.FarmPvPFrame_honorWeeklyTotal:Hide()
		_G.FarmPvPFrame_honorWeeklyTotalTexture:Hide()
		_G.FarmPvPFrame_honorWeeklyTotalRankTexture:Hide()
		_G.FarmPvPFrame_honorWeeklyTotalRank:Hide()

		_G.FarmPvPFrame_honorTotal:Hide()
		_G.FarmPvPFrame_honorTotalTexture:Hide()
		_G.FarmPvPFrame_honorTotalRankTexture:Hide()
		_G.FarmPvPFrame_honorTotalRank:Hide()

		_G.FarmPvPFrame_Remaining:Hide()

		_G.FarmPvPFrame_LevelPrefixText:Show()
		_G.FarmPvPFrame_LevelSuffixText:Show()
		_G.FarmPvPFrame_numberSix:Show()
		_G.FarmPvPFrame_numberZero:Show()
	else
		_G.FarmPvPFrame_conquest:Show()
		_G.FarmPvPFrame_conquestTexture:Show()
		_G.FarmPvPFrame_conquestRankTexture:Show()
		_G.FarmPvPFrame_conquestRank:Show()

		_G.FarmPvPFrame_honorWeeklyTotal:Show()
		_G.FarmPvPFrame_honorWeeklyTotalTexture:Show()
		_G.FarmPvPFrame_honorWeeklyTotalRankTexture:Show()
		_G.FarmPvPFrame_honorWeeklyTotalRank:Show()

		_G.FarmPvPFrame_honorTotal:Show()
		_G.FarmPvPFrame_honorTotalTexture:Show()
		_G.FarmPvPFrame_honorTotalRankTexture:Show()
		_G.FarmPvPFrame_honorTotalRank:Show()

		_G.FarmPvPFrame_Remaining:Show()

		_G.FarmPvPFrame_LevelPrefixText:Hide()
		_G.FarmPvPFrame_LevelSuffixText:Hide()
		_G.FarmPvPFrame_numberSix:Hide()
		_G.FarmPvPFrame_numberZero:Hide()
	end
end

function FP:HookButtons()
	_G.FarmPvPFrame_CloseButton:SetAlpha(0)
	_G.FarmPvPFrame_MaximizeMinimizeButton:SetAlpha(0)

	_G.FarmPvPFrame:HookScript("OnEnter", function ()
		_G.FarmPvPFrame_CloseButton:SetAlpha(1)
		_G.FarmPvPFrame_MaximizeMinimizeButton:SetAlpha(1)
	end)

	_G.FarmPvPFrame:HookScript("OnLeave", function (self)
		if _G.FarmPvPFrame_CloseButton:IsMouseOver() == false and _G.FarmPvPFrame_MaximizeMinimizeButton:IsMouseOver() == false then
			_G.FarmPvPFrame_CloseButton:SetAlpha(0)
			_G.FarmPvPFrame_MaximizeMinimizeButton:SetAlpha(0)
		end
	end)

	_G.FarmPvPFrame_CloseButton:SetScript("OnLeave", function (self)
		self:SetAlpha(0)
		_G.FarmPvPFrame_MaximizeMinimizeButton:SetAlpha(0)
	end)

	_G.FarmPvPFrame_CloseButton:SetScript("OnEnter", function (self)
		self:SetAlpha(1)
		_G.FarmPvPFrame_MaximizeMinimizeButton:SetAlpha(1)
	end)

	_G.FarmPvPFrame_MaximizeMinimizeButton:HookScript("OnLeave", function (self)
		self:SetAlpha(0)
		_G.FarmPvPFrame_CloseButton:SetAlpha(0)
	end)

	_G.FarmPvPFrame_MaximizeMinimizeButton:HookScript("OnEnter", function (self)
		self:SetAlpha(1)
		_G.FarmPvPFrame_CloseButton:SetAlpha(1)
	end)
end

function FP:Minimize()
	-- Start by making the main frame smaller.
	_G.FarmPvPFrame:SetHeight(50)

	-- Hide unimportant frames.
	_G.FarmPvPFrame_Header:Hide()
	_G.FarmPvPFrame_Title:Hide()
	_G.FarmPvPFrame_Faction:Hide()
	_G.FarmPvPFrame_Version:Hide()
	_G.FarmPvPFrame_Remaining:Hide()

	-- Reposition and alter sections.
	FP:RepositionSection('conquest', {"LEFT", 45, 0})
	FP:RepositionSection('honorWeeklyTotal', {"CENTER"})
	FP:RepositionSection('honorTotal', {"RIGHT", -45, 0})
end

function FP:Maximize()
	-- Start by making the main frame bigger.
	_G.FarmPvPFrame:SetHeight(275)

	_G.FarmPvPFrame_Header:Show()
	_G.FarmPvPFrame_Title:Show()
	_G.FarmPvPFrame_Faction:Show()
	_G.FarmPvPFrame_Version:Show()
	_G.FarmPvPFrame_Remaining:Show()

	_G.FarmPvPFrame_CloseButton:Show()
	_G.FarmPvPFrame_MaximizeMinimizeButton:Show()

	-- Reposition and alter sections.
	FP:RepositionSection('conquest', {"LEFT", 45, 90})
	FP:RepositionSection('honorWeeklyTotal', {"LEFT", 45, -25})
	FP:RepositionSection('honorTotal', {"BOTTOMLEFT", 45, 85})

end

function FP:RepositionSection(id, position)
	local rankTexture = _G["FarmPvPFrame_" .. id .. "RankTexture"]

	rankTexture:ClearAllPoints()
	rankTexture:SetPoint(unpack(position))
	
	local main = _G["FarmPvPFrame_" .. id]
	main:ClearAllPoints()

	if FP.Settings.Mode == "compact" then
		rankTexture:SetAlpha(0.5)
		
		main:SetPoint("CENTER", rankTexture)
		if main:GetText() == '-' then
			main:Hide()
		end
	
		_G["FarmPvPFrame_" .. id .. "Texture"]:Hide()
		_G["FarmPvPFrame_" .. id .. "Rank"]:Hide()

	else
		-- We want to reset the position.
		rankTexture:SetAlpha(1)
		main:SetPoint("BOTTOMLEFT", rankTexture, 45, 0)
		main:Show()

		if main:GetText() ~= '-' then
			_G["FarmPvPFrame_" .. id .. "Texture"]:Show()
		end
		_G["FarmPvPFrame_" .. id .. "Rank"]:Show()
	end

end
