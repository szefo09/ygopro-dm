--蒼神龍ウォルフィース
--Wolfis, Blue Divine Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
	--get ability
	dm.AddBreakShieldEffect(c,0,true,nil,scard.abop,nil,scard.abcon)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,1,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
--get ability
function scard.cfilter(c,tp)
	return c:GetPreviousControler()==tp and not c:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER)
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	for tc in aux.Next(eg) do
		if tc:IsLocation(LOCATION_HAND) and tc:IsBrokenShield() then
			--shield trigger
			dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_SHIELD_TRIGGER)
			Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER,e,0,0,0,0)
			Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER,e,0,0,0,0)
			if tc:IsCreature() and tc:IsCanSendtoBattle(e,0,tp,false,false) then
				Duel.SendtoBattle(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
			end
		end
	end
end
--destroy replace (return)
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToHand)
scard.repop=dm.SingleDestroyReplaceOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
