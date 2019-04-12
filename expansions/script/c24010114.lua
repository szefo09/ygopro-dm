--Necrodragon Bryzenaga
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to hand
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.thop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SHIELD,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
	--raise event for "(You can use the "shield trigger" ability of that shield.)"
	for tc in aux.Next(g) do
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER,e,0,0,0,0)
	end
end
