--Death Cruzer, the Annihilator
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DestroyOperation(nil,Card.IsFaceup,DM_LOCATION_BZONE,0,nil,nil,nil,c))
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
