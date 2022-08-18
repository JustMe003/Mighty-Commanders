
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
		--make sure its not a transfer
		if(FromOwner ~= ToOwner )then 	
			--Four cases: 
			--1.-No commanders involved - No effect 
			--2.-Commanders in both sides - No effect
			--3.- Commander in attacking army only - A fraction of the surviving defending troops flee, a fraction of attacking casualties are replenished
			if(tablelength(result.ActualArmies.SpecialUnits)>0 and tablelength(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.SpecialUnits)==0 )then 
				--If attack is succesfull only casualties are replenished
				if(result.IsSuccessful)then
					local NameFrom=game.ServerGame.Game.Players[FromOwner].DisplayName(nil, false);
					--Casualties are replenished
					if(Mod.Settings.ReplenishmentRate>0)
						local effect = WL.TerritoryModification.Create(to);
						local newarmies = result.ActualArmies.NumArmies-RR*result.AttackingArmiesKilled .NumArmies;
						local EffectSize=(1-RR)*result.AttackingArmiesKilled .NumArmies;
						effect.SetArmiesTo = newarmies;
						addNewOrder(WL.GameOrderEvent.Create(FromOwner, NameFrom.." heals " .. EffectSize .. " injured attacking armies", {}, {effect}),true);
					end
				--Otherwise enemies flee and casualties are replenished
				else
					--If commander died there is no effect
					if(tablelength(result.AttackingArmiesKilled.SpecialUnits)>0)then
					else
						local NameFrom=game.ServerGame.Game.Players[FromOwner].DisplayName(nil, false);
						--Enemies flee
						if(Mod.Settings.FleeRate>0)
							local effect = WL.TerritoryModification.Create(to);
							local newarmies = FR*(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.NumArmies-result.DefendingArmiesKilled.NumArmies);
							effect.SetArmiesTo = newarmies;
							local EffectSize=(1-FR)*(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.NumArmies-result.DefendingArmiesKilled.NumArmies);
							addNewOrder(WL.GameOrderEvent.Create(ToOwner, EffectSize .. " defending survivors flee in fear of "..NameFrom, {}, {effect}),true);
						end
						--Casualties are replenished
						if(Mod.Settings.ReplenishmentRate>0)
							local effect = WL.TerritoryModification.Create(from);
							local newarmies = game.ServerGame.LatestTurnStanding.Territories[from].NumArmies.NumArmies-RR*result.AttackingArmiesKilled.NumArmies;
							local EffectSize=(1-RR)*result.AttackingArmiesKilled .NumArmies;
							effect.SetArmiesTo = newarmies;
							addNewOrder(WL.GameOrderEvent.Create(FromOwner, NameFrom.." heals " .. EffectSize .. " injured atacking armies", {}, {effect}),true);
						end
					end
				end
			end
			--3.- Commander in defending army only - A fraction of the surviving attacking troops flee, a fraction of defending casualties are replenished
			if(tablelength(game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.SpecialUnits)>0 and tablelength(result.ActualArmies.SpecialUnits)==0 )then 
				--If attack is succesful game is over
				if(result.IsSuccessful)then
				else
					--If attack fails defending armies are replenished and attacking enemies flee
					--Enemies flee
					if(Mod.Settings.FleeRate>0)
						local NameTo=game.ServerGame.Game.Players[ToOwner].DisplayName(nil, false);
						local effect = WL.TerritoryModification.Create(from);
						local newarmies = game.ServerGame.LatestTurnStanding.Territories[from].NumArmies.NumArmies-result.AttackingArmiesKilled.NumArmies-(1-FR)*(result.ActualArmies.NumArmies-result.AttackingArmiesKilled.NumArmies);
						if (newarmies<0)then
							newarmies=0;
						end
						local EffectSize=(1-FR)*(result.ActualArmies.NumArmies-result.AttackingArmiesKilled.NumArmies);
						effect.SetArmiesTo = newarmies;
						addNewOrder(WL.GameOrderEvent.Create(FromOwner, EffectSize .. " attacking survivors flee in fear of "..NameTo, {}, {effect}),true);
					end
					--Casualties are replenished
					if(Mod.Settings.ReplenishmentRate>0)
						local effect = WL.TerritoryModification.Create(to);
						local newarmies = game.ServerGame.LatestTurnStanding.Territories[to].NumArmies.NumArmies-result.DefendingArmiesKilled.NumArmies*RR;
						effect.SetArmiesTo = newarmies;
						local EffectSize=result.DefendingArmiesKilled.NumArmies*(1-RR);
						addNewOrder(WL.GameOrderEvent.Create(ToOwner, NameTo.." heals " .. EffectSize .. " injured defending armies", {}, {effect}),true);				
					end
				end			
			end
		end
	end
end


function Server_AdvanceTurn_End(game, addNewOrder)
	local CA=Mod.Settings.CreateArmies;
	--Loop through all territories to see if there is a commander
	for _, Territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if(tablelength(Territory.NumArmies.SpecialUnits)>0)then
			local Owner=Territory.OwnerPlayerID;
			local TerritoryName=game.Map.Territories[Territory.ID].Name;
			local OwnerName=game.ServerGame.Game.Players[Owner].DisplayName(nil, false);
			local effect = WL.TerritoryModification.Create(Territory.ID);
			local newarmies = CA*tablelength(Territory.NumArmies.SpecialUnits);
			effect.AddArmies  = newarmies;
			addNewOrder(WL.GameOrderEvent.Create(Owner, newarmies .. " recruits join the army of "..OwnerName.. " in ".. TerritoryName , {}, {effect}),true);
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

