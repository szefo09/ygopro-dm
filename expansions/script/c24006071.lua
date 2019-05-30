--Armored Decimator Valkaizer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--destroy
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,true,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_HUMAN}
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(4000)
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
