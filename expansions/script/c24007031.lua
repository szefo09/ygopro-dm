--Propeller Mutant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleDestroyedEffect(c,0,nil,nil,dm.DiscardOperation(PLAYER_OPPONENT,aux.TRUE,0,LOCATION_HAND,1,1,true))
end
scard.duel_masters_card=true