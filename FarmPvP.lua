local _G = _G
local _, FP = ...
_G.FarmPvP = FP

local title = "Farm |cFFC41F3BP|rv|cFF0070DEP|r"
local version = "v1.2.3"

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
	local conquestInfo = C_CurrencyInfo.GetCurrencyInfo(1602)

	totalConquestCost = -conquestInfo.quantity
	totalWeeklyHonorCost = -honorInfo.quantity
	totalHonorCost = -honorInfo.quantity

	local highestWeeklyRating = FP:GetHighestWeeklyRating()
	local highestWeeklyRank = FP:GetHighestWeeklyRank(highestWeeklyRating)

	
	FP:SetHighestWeeklyRankTexture()
	FP:ShowCompleteSection()

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
				if itemName:startswith("Cosmic Gladiator's") then
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

						if itemRank < 8 then
							FP:HideCompleteSection()
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

	if UnitLevel("player") ~= 60 then
		_G.FarmPvPFrame_CompleteText:Hide()
	end

	-- fixme: remove this
	FP:HideCompleteSection()
end

function FP:OnEvent(event, ...)
	self[event](self, event, ...)
end

function FP:ADDON_LOADED(event, name, ...)
	if name == 'FarmPvP' then
		print(title, version, "/fp or /farmpvp for commands")

		if not _G.FarmPvPSettings then
			_G.FarmPvPSettings = FP.DefaultConfig
		end

		FP.Settings = _G.FarmPvPSettings
	end
end

function FP:PLAYER_LOGOUT()
	_G.FarmPvPSettings = FP.Settings
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
	if FP.Settings.Mode == 'compact' then
		FP:Minimize()
		_G.FarmPvPFrame_MaximizeMinimizeButton.MaximizeButton:Show()
		_G.FarmPvPFrame_MaximizeMinimizeButton.MinimizeButton:Hide()
	end
end

function FP:PLAYER_LEVEL_CHANGED(event, ...)
	FP:ShowHideSections()
end

function FP:PLAYER_LOGIN(event, ...)
	FP:SetPlayerFactionTexture()
	-- We can rely on this request to trigger PVP_RATED_STATS_UPDATE
	-- which in turn will update the total upgrade cost.
	RequestRatedInfo()

	FP:ShowHideSections()
	FP:SetLocation()
end

function FP:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterForDrag("LeftButton")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:RegisterEvent("PVP_RATED_STATS_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_CHANGED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")

	FP:SetTitle(title)
	FP:SetVersion(version)
	FP:HookButtons()
	FP:SetMode()
	
	_G.FarmPvPFrame:Show()

end

function FP:SetMode()
	_G.FarmPvPFrame_MaximizeMinimizeButton.MinimizeButton:HookScript("OnClick", function ()
		FP.Settings.Mode = 'compact'
		FP:Minimize()
		FP:TotalUpgradeCost()
	end)

	_G.FarmPvPFrame_MaximizeMinimizeButton.MaximizeButton:HookScript("OnClick", function ()
		FP.Settings.Mode = 'default'
		FP:Maximize()
		FP:TotalUpgradeCost()
		FP:ShowHideSections()
	end)
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
