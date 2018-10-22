--Barkwhip, the Smasher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_BEAST_FOLK))
	--power up
	dm.EnableUpdatePower(c,2000,dm.SelfTappedCondition,DM_LOCATION_BATTLE,0,scard.powtg)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsDMRace(DM_RACE_BEAST_FOLK)
end
