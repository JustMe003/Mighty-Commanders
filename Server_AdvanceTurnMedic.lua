function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	--Called after Server_AdvanceTurn_Start
	if(order.proxyType == 'GameOrderAttackTransfer') then --Through attack, armies are lost, so we need to take a look at this case
		local from = order.From; -- returns the territory id, the attack/transfer comes from
		local to = order.To; --returns the territory id, the attack/transfer goes to
		local FromOwner = game.ServerGame.LatestTurnStanding.Territories[from].OwnerPlayerID;--returns the playerid, of the territory with the id from
		local ToOwner = game.ServerGame.LatestTurnStanding.Territories[to].OwnerPlayerID;--returns the playerid, of the territory with the id to
		if(FromOwner ~= ToOwner)then
			--Check if there is a commander in from
            if(tablelength(from.NumArmies.SpecialUnits)>0)then
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
