local _G = _G
local _, FH = ...
_G.FarmHonor = FH

local version = "v1.0.0"

local totalConquestCost = 0
local totalWeeklyHonorCost = 0
local totalHonorCost = 0

local highestWeeklyRating = FH:GetHighestWeeklyRating()
local highestWeeklyRank = FH:GetHighestWeeklyRank(highestWeeklyRating)

if IsAddOnLoaded('FarmHonor') then print("Farm PvP by Lyci, ", version) end

local frame = CreateFrame("Frame", "Farm PvP", UIParent, "BackdropTemplate")
frame:SetFrameStrata("BACKGROUND")
frame:SetPoint("CENTER")
frame:SetWidth(175)
frame:SetHeight(275)
frame:SetResizable(true)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

frame.titleBG = frame:CreateTexture(nil, "ARTWORK")
frame.titleBG:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
frame.titleBG:SetSize(250, 64)
frame.titleBG:SetPoint("TOP", 0, 15)

frame.title = frame:CreateFontString(nil,"ARTWORK") 
frame.title:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
frame.title:SetTextColor(1, 1, 1)
frame.title:SetPoint("CENTER", frame.titleBG, 0, 13)
frame.title:SetText("Farm PvP")

frame.version = frame:CreateFontString(nil, "ARTWORK") 
frame.version:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
frame.version:SetTextColor(1, 1, 1, 0.4)
frame.version:SetPoint("BOTTOMRIGHT", -10, 10)
frame.version:SetText(version)

-- DYNAMIC FACTION ICON
local playerFaction, _ = UnitFactionGroup("player")
local factionTexture;
if playerFaction == "Alliance" then
	factionTexture = "Interface\\PVPFrame\\PVP-Currency-Alliance"
else 
	factionTexture = "Interface\\PVPFrame\\PVP-Currency-Horde"
end
frame.faction = frame:CreateTexture(nil, "ARTWORK")
frame.faction:SetTexture(factionTexture)
frame.faction:SetAlpha(0.2)
frame.faction:SetPoint("CENTER")
frame.faction:SetScale(3)

frame.remaining = frame:CreateFontString(nil, "ARTWORK");
frame.remaining:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
frame.remaining:SetPoint("TOP", 0, -40)
frame.remaining:SetText("Remaining for")

-- TOTAL CONQUEST FOR FULL UNRANKED
frame.conquestRankTexture = frame:CreateTexture(nil, "ARTWORK")
frame.conquestRankTexture:SetTexture(FH.RanksIconMapping[1])
frame.conquestRankTexture:SetPoint("LEFT", frame, 45, 90)
frame.conquestRankTexture:SetScale(0.5)

frame.conquestRank = frame:CreateFontString(nil, "ARTWORK")
frame.conquestRank:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
frame.conquestRank:SetPoint("TOPLEFT", frame.conquestRankTexture, 45, 0)
frame.conquestRank:SetText("Full Unranked")

frame.conquest = frame:CreateFontString(nil, "ARTWORK");
frame.conquest:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
frame.conquest:SetPoint("BOTTOMLEFT", frame.conquestRankTexture, 45, 0)

frame.conquestTexture = frame:CreateTexture(nil, "ARTWORK")
frame.conquestTexture:SetTexture("Interface\\icons\\achievement_legionpvp2tier3")
frame.conquestTexture:SetScale(0.25)
frame.conquestTexture:SetPoint("RIGHT", frame.conquest, 75, 0)

-- TOTAL HONOR FOR HIGHEST WEEKLY RANK
frame.honorWeeklyTotalRankTexture = frame:CreateTexture(nil, "ARTWORK")
frame.honorWeeklyTotalRankTexture:SetTexture(FH.RanksIconMapping[highestWeeklyRank])
frame.honorWeeklyTotalRankTexture:SetPoint("LEFT", frame, 45, -25)
frame.honorWeeklyTotalRankTexture:SetScale(0.5)

frame.honorWeeklyTotalRank = frame:CreateFontString(nil, "ARTWORK")
frame.honorWeeklyTotalRank:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
frame.honorWeeklyTotalRank:SetPoint("TOPLEFT", frame.honorWeeklyTotalRankTexture, 45, 0)
frame.honorWeeklyTotalRank:SetText("Highest Weekly")

frame.honorWeeklyTotal = frame:CreateFontString(nil, "ARTWORK")
frame.honorWeeklyTotal:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
frame.honorWeeklyTotal:SetPoint("BOTTOMLEFT", frame.honorWeeklyTotalRankTexture,  44, 0)

frame.honorWeeklyTotalTexture = frame:CreateTexture(nil, "ARTWORK")
frame.honorWeeklyTotalTexture:SetTexture("interface\\icons\\achievement_legionpvptier4")
frame.honorWeeklyTotalTexture:SetScale(0.25)
frame.honorWeeklyTotalTexture:SetPoint("RIGHT", frame.honorWeeklyTotal, 75, 0)

-- TOTAL HONOR FOR DUELIST GEAR
frame.honorTotalRankTexture = frame:CreateTexture(nil, "ARTWORK")
frame.honorTotalRankTexture:SetTexture("interface\\pvpframe\\icons\\ui_rankedpvp_05_small")
frame.honorTotalRankTexture:SetPoint("BOTTOMLEFT", frame, 45, 85)
frame.honorTotalRankTexture:SetScale(0.5)

frame.honorTotalRank = frame:CreateFontString(nil, "ARTWORK")
frame.honorTotalRank:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
frame.honorTotalRank:SetPoint("TOPLEFT", frame.honorTotalRankTexture, 45, 0)
frame.honorTotalRank:SetText("Full Duelist")

frame.honorTotal = frame:CreateFontString(nil, "ARTWORK")
frame.honorTotal:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
frame.honorTotal:SetPoint("BOTTOMLEFT", frame.honorTotalRankTexture,  44, 0)

frame.honorTotalTexture = frame:CreateTexture(nil, "ARTWORK")
frame.honorTotalTexture:SetTexture("interface\\icons\\achievement_legionpvptier4")
frame.honorTotalTexture:SetScale(0.25)
frame.honorTotalTexture:SetPoint("RIGHT", frame.honorTotal, 75, 0)

-- BACKGROUND TEXTURE AND BORDER
frame.backdropInfo = frame:SetBackdrop({
	bgFile = "Interface\\FrameGeneral\\UIFrameNecrolordBackground",
 	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 64,
 	edgeSize = 8,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
})

frame:SetPoint("CENTER",0,0)
frame:Show()

function frame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function frame:PLAYER_EQUIPMENT_CHANGED(event, equipmentSlot, hasCurrent)
	if hasCurrent == false then
		frame:TotalUpgradeCost()
	end
end

function frame:TotalUpgradeCost()
	local honorInfo = C_CurrencyInfo.GetCurrencyInfo(1792)

	totalConquestCost = 0
	totalWeeklyHonorCost = -honorInfo.quantity;
	totalHonorCost = -honorInfo.quantity;

	local highestWeeklyRating = FH:GetHighestWeeklyRating()
	local highestWeeklyRank = FH:GetHighestWeeklyRank(highestWeeklyRating)

	local slots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Waist", "Legs", "Feet", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}
	for index, slotName in ipairs(slots) do
		local slotID = GetInventorySlotInfo(slotName .. "Slot")
		local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then	
			local item = Item:CreateFromItemLink(itemLink)
			item:ContinueOnItemLoad(function()
				local itemName = item:GetItemName()
				local ilvl = item:GetCurrentItemLevel()
				local itemQuality = item:GetItemQuality()
				-- @todo: Refactor into a better way of extracting PvP items.
				if itemName:startswith("Unchained Gladiator's") then
					local itemRank = FH.RanksItemLevelTable[ilvl]
					local itemUpgradeCostTable = FH.ItemsUpgradeCostTable[slotName]
					if itemUpgradeCostTable then
						-- Total honor cost to full Duelist gear.
						for i = itemRank + 1, #(itemUpgradeCostTable), 1 do
							totalHonorCost = totalHonorCost + itemUpgradeCostTable[i]
						end
		
						if itemRank < highestWeeklyRank then
							-- Honor cost to highest possible rank the current week.
							for i = itemRank + 1, highestWeeklyRank, 1 do
								totalWeeklyHonorCost = totalWeeklyHonorCost + itemUpgradeCostTable[i]
							end
						end
					end
				-- We want to disregard legendaries and their slot(s).
				elseif itemQuality == 5 then
					slots[index] = nil
				
				else
					totalConquestCost = totalConquestCost + FH.ItemsUpgradeCostTable[slotName][1]
				end
			end)
		end
	end

	frame.conquest:SetText(string.commavalue(totalConquestCost))

	if totalWeeklyHonorCost <= 0 then
		frame.honorWeeklyTotal:SetText("-")
		frame.honorWeeklyTotalTexture:Hide()
	else
		frame.honorWeeklyTotal:SetText(string.commavalue(totalWeeklyHonorCost))
	end

	if totalHonorCost <= 0 then
		frame.honorTotal:SetText("-")
		frame.honorTotalTexture:Hide()
	else
		frame.honorTotal:SetText(string.commavalue(totalHonorCost))
	end
end

function frame:CURRENCY_DISPLAY_UPDATE(event, currencyType, ...)
	if currencyType == 1792 or currencyType == 1602 then
		frame:TotalUpgradeCost()
	end
end

frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
frame:SetScript("OnEvent", frame.OnEvent)

frame:TotalUpgradeCost()
