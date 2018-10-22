--Chaos Strike
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.abtg=dm.ChooseCardFunction(PLAYER_PLAYER,Card.IsUntapped,0,DM_LOCATION_BATTLE,1)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	--make attackable
	dm.GainEffectCustom(e:GetHandler(),tc,1,DM_EFFECT_UNTAPPED_BE_ATTACKED)
end
