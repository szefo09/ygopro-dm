--Schuka, Duke of Amnesia
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleDestroyedEffect(c,0,nil,nil,scard.dhop)
end
scard.duel_masters_card=true
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.DMSendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
