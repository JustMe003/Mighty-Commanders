function Server_AdvanceTurn_Start(game, addNewOrder)
	--Loop through all territories to see if there is a commander
	for _, Territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if(tablelength(Territory.NumArmies.SpecialUnits)>0)then
			for i = 1, tablelength(Territory.NumArmies.SpecialUnits) do
				local CA=Mod.Settings.CreateArmies;
				local Owner=Territory.OwnerPlayerID;
				local OwnerName=game.ServerGame.Game.Players[Owner].DisplayName(nil, false);
				local effect = WL.TerritoryModification.Create(Territory.ID);
				local newarmies = game.ServerGame.LatestTurnStanding.Territories[Territory.ID].NumArmies.NumArmies+CA;
				effect.SetArmiesTo = newarmies;
				addNewOrder(WL.GameOrderEvent.Create(Owner, OwnerName.."'s call to arms is heard", {}, {effect}),true);
			end
		end
	end
end

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	--Rates
	local RR=1-Mod.Settings.ReplenishmentRate/100;
	local FR=1-Mod.Settings.FleeRate/100;
	--Through attack, armies are lost, so we need to take a look at this case
	if(order.proxyType == 'GameOrderAttackTransfer') then 
		-- returns the territory id, the attack/transfer comes from
		local from = order.From; 
		--returns the territory id, the attack/transfer goes to
		local to = order.To; 
		--returns the playerid, of the territory with the id from
		local FromOwner = game.ServerGame.LatestTurnStanding.Territories[from].OwnerPlayerID;
		--returns the playerid, of the territory with the id to
		local ToOwner = game.ServerGame.LatestTurnStanding.Territories[to].OwnerPlayerID;
		local NameTo=game.ServerGame.Game.Players[ToOwner].DisplayName(nil, false);
		local NameFrom=game.ServerGame.Game.Players[FromOwner].DisplayName(nil, false);
		--make sure its not a transfer
		if(FromOwner ~= ToOwner)then 
			--Four cases: 
			--1.-No commanders involved - No effect 
			--2.-Commanders in both sides - No effect
			--3.- Commander in atacking army only - A fraction of the surviving defending troops flee, a fraction of atacking casualties are replenished
			if(tablelength(result.ActualArmies.SpecialUnits)>0 and tablelength(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.SpecialUnits)==0 )then 
				--If atack is succesfull only casualties are replenished
				if(result.IsSuccessful)then
					--Casualties are replenished
					local effect = WL.TerritoryModification.Create(to);
					local newarmies = result.ActualArmies.NumArmies-RR*result.AttackingArmiesKilled .NumArmies;
					effect.SetArmiesTo = newarmies;
					addNewOrder(WL.GameOrderEvent.Create(FromOwner, NameFrom.." heals injured atacking armies", {}, {effect}),true);
				--Otherwise enemies flee and casualties are replenished
				else
					--Enemies flee
					local effect = WL.TerritoryModification.Create(to);
					local newarmies = FR*(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.NumArmies-result.DefendingArmiesKilled.NumArmies);
					effect.SetArmiesTo = newarmies;
					addNewOrder(WL.GameOrderEvent.Create(ToOwner, "Defending survivors flee in fear of "..NameFrom, {}, {effect}),true);
					--Casualties are replenished
					local effect = WL.TerritoryModification.Create(from);
					local newarmies = game.ServerGame.LatestTurnStanding.Territories[from].NumArmies.NumArmies-RR*result.AttackingArmiesKilled.NumArmies;
					effect.SetArmiesTo = newarmies;
					addNewOrder(WL.GameOrderEvent.Create(FromOwner, NameFrom.." heals injured atacking armies", {}, {effect}),true);
				end
			end
			--3.- Commander in defending army only - A fraction of the surviving atacking troops flee, a fraction of defending casualties are replenished
			if(tablelength(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.SpecialUnits)>0 and tablelength(result.ActualArmies.SpecialUnits)==0 )then 
				--If atack is succesful game is over
				if(result.IsSuccessful==False)then
				--If atack fails defending armies are replenished and atacking enemies flee
				else
					--Enemies flee
					local effect = WL.TerritoryModification.Create(from);
					local newarmies = game.ServerGame.LatestTurnStanding.Territories[from].NumArmies.NumArmies-result.AttackingArmiesKilled.NumArmies-(1-FR)*(result.ActualArmies.NumArmies-result.AttackingArmiesKilled.NumArmies);
					if (newarmies<0)then
						newarmies=0;
					end
					effect.SetArmiesTo = newarmies;
					addNewOrder(WL.GameOrderEvent.Create(FromOwner, "Atacking survivors flee in fear of "..NameTo, {}, {effect}),true);
					--Casualties are replenished
					local effect = WL.TerritoryModification.Create(to);
					local newarmies = game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.NumArmies-result.DefendingArmiesKilled.NumArmies*RR;
					effect.SetArmiesTo = newarmies;
					addNewOrder(WL.GameOrderEvent.Create(ToOwner, NameTo.." heals injured defending armies", {}, {effect}),true);
				end
			end
			
		end
	end
end
function tablelength(T)
	local count = 0;
	for _, elem in pairs(T)do
		count = count + 1;
	end
	return count;
end

