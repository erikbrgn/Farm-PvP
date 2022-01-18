local _G = _G
local _, FP = ...
_G.FarmPvP = FP

local title = "Farm |cFFC41F3BP|rv|cFF0070DEP|r"
local version = "v1.0.0"

local totalConquestCost = 0
local totalWeeklyHonorCost = 0
local totalHonorCost = 0

FP.Backdrop = {
	bgFile = "Interface\\FrameGeneral\\UIFrameNecrolordBackground",
 	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 64,
 	edgeSize = 8,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

function FP:TotalUpgradeCost()
	local honorInfo = C_CurrencyInfo.GetCurrencyInfo(1792)

	totalConquestCost = 0
	totalWeeklyHonorCost = -honorInfo.quantity;
	totalHonorCost = -honorInfo.quantity;

	local highestWeeklyRating = FP:GetHighestWeeklyRating()
	local highestWeeklyRank = FP:GetHighestWeeklyRank(highestWeeklyRating)

	FP:SetHighestWeeklyRankTexture()

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
					local itemRank = FP.RanksItemLevelTable[ilvl]
					local itemUpgradeCostTable = FP.ItemsUpgradeCostTable[slotName]
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
					totalConquestCost = totalConquestCost + FP.ItemsUpgradeCostTable[slotName][1]
				end
			end)
		end
	end

	FP:SetSectionText(_G.FarmPvPFrame_conquest, _G.FarmPvPFrame_conquestTexture, totalConquestCost)
	FP:SetSectionText(_G.FarmPvPFrame_honorWeeklyTotal, _G.FarmPvPFrame_honorWeeklyTotalTexture, totalWeeklyHonorCost)
	FP:SetSectionText(_G.FarmPvPFrame_honorTotal, _G.FarmPvPFrame_honorTotalTexture, totalHonorCost)
end

function FP:OnEvent(event, ...)
	self[event](self, event, ...)
end

function FP:ADDON_LOADED(event, name, ...)
	if name == 'FarmPvP' then
		print(title, version, "/fp or /farmpvp for commands")
	end
end

function FP:PLAYER_EQUIPMENT_CHANGED(event, equipmentSlot, hasCurrent)
	if hasCurrent == false then
		self:TotalUpgradeCost()
	end
end

function FP:CURRENCY_DISPLAY_UPDATE(event, currencyType, ...)
	if currencyType == 1792 or currencyType == 1602 then
		self:TotalUpgradeCost()
	end
end

function FP:PVP_RATED_STATS_UPDATE(event, ...)
	self:TotalUpgradeCost()
end

function FP:PLAYER_LEVEL_CHANGED(event, ...)
	FP:ShowHideSections()
end

function FP:PLAYER_LOGIN(event, ...)
	FP:SetPlayerFactionTexture()
	FP:ShowHideSections()
	-- We can rely on this request to trigger PVP_RATED_STATS_UPDATE
	-- which in turn will update the total upgrade cost.
	RequestRatedInfo()
end

function FP:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterForDrag("LeftButton")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:RegisterEvent("PVP_RATED_STATS_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_CHANGED")
	self:RegisterEvent("PLAYER_LOGIN")

	FP:SetTitle(title)
	FP:SetVersion(version)

	_G.FarmPvPFrame:Show()
end


SLASH_FARMPVP1, SLASH_FARMPVP2 = '/fp', '/farmpvp';
local function handler(msg, editBox)
    if msg == 'show' then
		_G.FarmPvPFrame:Show()
	elseif msg == 'hide' then
		_G.FarmPvPFrame:Hide()
	elseif msg == 'calc' or msg == 'calculate' then
		FP:TotalUpgradeCost()
	elseif msg == 'lock' then
		if (_G.FarmPvPFrame:IsMovable()) then
			_G.FarmPvPFrame:SetMovable(false)
			_G.FarmPvPFrame:EnableMouse(false)
			print(title, " is now locked. Type /fp lock again to unlock it.")
		else
			_G.FarmPvPFrame:SetMovable(true)
			_G.FarmPvPFrame:EnableMouse(true)
			print(title, " is now unlocked. Type /fp lock again to lock it.")
		end
	else 
		print(title)
		print("A list of commands. Start with /fp or /farmpvp and then \n- show \n- hide \n- calc or calculate \n- lock")
    end
end

SlashCmdList["FARMPVP"] = handler;
