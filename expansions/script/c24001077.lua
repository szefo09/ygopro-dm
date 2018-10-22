--Fatal Attacker Horvath
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,2000,scard.powcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsDMRace(DM_RACE_ARMORLOID)
end
function scard.powcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,nil)
		and Duel.GetAttacker()==e:GetHandler()
end
