--Armored Cannon Balbaro
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_HUMAN)
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,c)*2000
end
