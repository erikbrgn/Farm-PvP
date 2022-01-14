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