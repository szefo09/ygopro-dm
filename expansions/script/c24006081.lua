--Legionnaire Lizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--tap ability (get ability)
	dm.EnableTapAbility(c,0,scard.abtg,scard.abop)
end
scard.duel_masters_card=true
scard.abtg=dm.CheckCardFunction(Card.IsFaceup,DM_LOCATION_BATTLE,0)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CREATURE)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	--speed attacker
	dm.GainEffectCustom(e:GetHandler(),g:GetFirst(),1,DM_EFFECT_SPEED_ATTACKER)
end
