--Infernal Command
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET)
	dm.AddShieldTriggerCastEffect(c,0,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.abtg=dm.TargetCardFunction(PLAYER_SELF,Card.IsFaceup,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local reset_count=1
	if Duel.GetTurnPlayer()==tp then reset_count=2 end
	--attack if able
	dm.RegisterEffectCustom(e:GetHandler(),tc,1,EFFECT_MUST_ATTACK,RESET_PHASE+PHASE_DRAW,reset_count)
end
