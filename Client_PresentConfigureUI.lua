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

