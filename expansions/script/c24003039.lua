--Flametropus
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.tgtg,scard.tgop)
end
scard.duel_masters_card=true
scard.tgtg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_MANA,0)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.DMIsAbleToGrave),tp,DM_LOCATION_MANA,0,1,1,nil)
	if g:GetCount()==0 or Duel.DMSendtoGrave(g,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	--power attacker
	dm.GainEffectPowerAttacker(c,c,1,3000,0)
	--double breaker
	dm.GainEffectBreaker(c,c,2,DM_EFFECT_DOUBLE_BREAKER,0)
end
