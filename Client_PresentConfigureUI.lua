function Client_PresentConfigureUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	
	local ReplenishmentRate = Mod.Settings.ReplenishmentRate;
	if ReplenishmentRate == nil then ReplenishmentRate = 0; end
	if ReplenishmentRate >100  then ReplenishmentRate = 100; end
    if ReplenishmentRate <0  then ReplenishmentRate = 0; end

    local FleeRate = Mod.Settings.FleeRate;
	if FleeRate == nil then FleeRate = 0; end
	if FleeRate >100  then FleeRate = 100; end
    if FleeRate <0  then FleeRate = 0; end

	local CreateArmies = Mod.Settings.CreateArmies;
	if CreateArmies == nil then CreateArmies = 0; end
	if CreateArmies < 0 then CreateArmies=0; end

	
	textColor = "#DDDDDD";
	grayedOutColor = "#CCCCCC";
		
	UI.CreateLabel(vert).SetText("This mod makes commanders do three things: 1.- Commanders will spawn armies at the end of each round (this way the AI is better at predicting defending armies). 2.-Whenever a commander is part of a defending or attacking army a percentage of casualties will be replenished. 3.-Whenever a commander is part of a defending or attacking army a percentage of the surviving enemy armies will flee (die for practical purposes). Note: This effect only applies to armies that were actually involved in the fight and not to all armies in the attacking territory. Note 2: The replenishment and flee effects happen after the fight is resolved, if the commander does not survive the fight the player looses the game.").SetColor(textColor)
	UI.CreateEmpty(vert).SetPreferredHeight(20);

	UI.CreateLabel(vert).SetText("Number of armies commanders create").SetColor(textColor);
	CreateArmiesInput = UI.CreateNumberInputField(vert).SetSliderMinValue(0).SetSliderMaxValue(100).SetValue(CreateArmies);

	UI.CreateLabel(vert).SetText("Flee rate  (percent)").SetColor(textColor);
	FleeRateInput = UI.CreateNumberInputField(vert).SetSliderMinValue(0).SetSliderMaxValue(100).SetValue(FleeRate);
	
	UI.CreateLabel(vert).SetText("Casualty replenishment rate (percent)").SetColor(textColor);
	ReplenishmentRateInput = UI.CreateNumberInputField(vert).SetSliderMinValue(0).SetSliderMaxValue(100).SetValue(ReplenishmentRate);

end

function setColor(input)
	if input.GetIsChecked() then
		return textColor;
	else
		return grayedOutColor;
	end
end

