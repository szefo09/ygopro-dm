--Armored Cannon Balbaro
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,scard.evofilter)
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
end
scard.duel_masters_card=true
scard.evofilter=aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_HUMAN)
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.evofilter,c:GetControler(),DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,c)*2000
end
