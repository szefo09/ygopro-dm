--Emergency Typhoon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--draw & discard
	dm.AddSpellCastEffect(c,0,nil,scard.drop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DrawUpTo(tp,2,REASON_EFFECT)>0 then Duel.ShuffleHand(tp) end
	Duel.BreakEffect()
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT,e:GetHandler())
end
