--Cosmic Wing
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.abtg=dm.TargetCardFunction(PLAYER_SELF,Card.IsFaceup,DM_LOCATION_BZONE,0,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	--cannot be blocked
	dm.RegisterEffectCannotBeBlocked(e:GetHandler(),tc,1)
end
