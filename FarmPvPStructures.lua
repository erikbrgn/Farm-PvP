local _G = _G
local _, FP = ...

FP.ItemsUpgradeCostTable = {
	--First index is always conquest cost.
	["Head"] = {875, 775, 925, 1075, 1225, 1375, 1525, 1825},
	["Neck"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Shoulder"] = {700, 600, 725, 850, 975, 1100, 1225, 1475},
	["Back"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Chest"] = {875, 775, 925, 1075, 1225, 1375, 1525, 1825},
	["Wrist"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Hands"] = {700, 600, 725, 850, 975, 1100, 1225, 1475},
	["Waist"] = {700, 600, 725, 850, 975, 1100, 1225, 1475},
	["Legs"] = {875, 775, 925, 1075, 1225, 1375, 1525, 1825},
	["Feet"] = {700, 600, 725, 850, 975, 1100, 1225, 1475},
	["Finger0"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Finger1"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Trinket0"] = {525, 450, 550, 650, 725, 825, 925, 1100},
	["Trinket1"] = {700, 600, 725, 850, 975, 1100, 1225, 1475},
	["MainHand"] = {900, 775, 925, 1075, 1225, 1375, 1525, 1825},
	["SecondaryHand"] = {900, 775, 925, 1075, 1225, 1375, 1525, 1825}
}

FP.RanksItemLevelTable = {
	[220] = 1,
	[226] = 2,
	[229] = 3,
	[233] = 4,
	[236] = 5,
	[239] = 6,
	[242] = 7,
	[246] = 8,
	[249] = 9,
}

FP.RanksRatingIntervals = {
	[1] = 0,
	[2] = 1000,
	[3] = 1200,
	[4] = 1400,
	[5] = 1600,
	[6] = 1800,
	[7] = 1950,
	[8] = 2100,
	[9] = 2400,
}

FP.RanksIconMapping = {
	[1] = "interface\\pvpframe\\icons\\ui_rankedpvp_01_small",
	[2] = "interface\\pvpframe\\icons\\ui_rankedpvp_02_small",
	[3] = "interface\\pvpframe\\icons\\ui_rankedpvp_02_small",
	[4] = "interface\\pvpframe\\icons\\ui_rankedpvp_03_small",
	[5] = "interface\\pvpframe\\icons\\ui_rankedpvp_03_small",
	[6] = "interface\\pvpframe\\icons\\ui_rankedpvp_04_small",
	[7] = "interface\\pvpframe\\icons\\ui_rankedpvp_04_small",
	[8] = "interface\\pvpframe\\icons\\ui_rankedpvp_05_small",
	[9] = "interface\\pvpframe\\icons\\ui_rankedpvp_06_small",
}

FP.FactionTextures = {
	["Alliance"] = "Interface\\PVPFrame\\PVP-Currency-Alliance",
	["Horde"] = "Interface\\PVPFrame\\PVP-Currency-Horde"
}