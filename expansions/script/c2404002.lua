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
	dm.AddDestroyedEffect(c,0,true,scard.abtg,scard.abop,EFFECT_FLAG_DAMAGE_CAL,scard.abcon)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,1,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
--get ability
function scard.cfilter(c,tp)
	return c:IsPreviousLocation(DM_LOCATION_SHIELD) and c:GetPreviousControler()==tp
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.abfilter(c,e,tp)
	return c:IsCreature() and c:IsCanBePutIntoBattleZone(e,0,tp,false,false,POS_FACEUP_UNTAPPED)
end
function scard.abtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(scard.abfilter,nil,e,tp)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	for tc in aux.Next(eg) do
		if tc:IsLocation(LOCATION_HAND) and not tc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) and tc:IsBrokenShield() then
			--shield trigger
			dm.GainEffectCustom(c,tc,2,DM_EFFECT_SHIELD_TRIGGER,-RESET_TOHAND)
			Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER,e,0,0,0,0)
		end
		if tc:IsCreature() then
			Duel.PutIntoBattleZone(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
		end
	end
end
--destroy replace (return)
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToHand)
scard.repop=dm.SelftoHandDestroyReplaceOperation
