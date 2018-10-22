--Laser Wing
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.abtg=dm.ChooseCardFunction(PLAYER_PLAYER,Card.IsFaceup,DM_LOCATION_BATTLE,0,0,2)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--cannot be blocked
		dm.GainEffectCannotBeBlocked(e:GetHandler(),tc,1)
	end
end
