--Super Necrodragon Abzo Dolba
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DRAGON))
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCreature),c:GetControler(),DM_LOCATION_GRAVE,0,nil)*2000
end
