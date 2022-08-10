function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	
	UI.CreateLabel(vert).SetText("").SetColor("#AA3333");
	UI.CreateEmpty(vert).SetPreferredHeight(20);
	
	UI.CreateLabel(vert).SetText("Armies that commanders create: " .. Mod.Settings.CreateArmies).SetColor("#DDDDDD");
	UI.CreateLabel(vert).SetText("Casualty replenishment rate: " .. Mod.Settings.ReplenishmentRate).SetColor("#DDDDDD");
	UI.CreateLabel(vert).SetText("Fleeing rate: " .. Mod.Settings.FleeRate).SetColor("#DDDDDD");

end