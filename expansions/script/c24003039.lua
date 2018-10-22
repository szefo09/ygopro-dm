--Flametropus
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.tgtg,scard.tgop)
end
scard.duel_masters_card=true
scard.tgtg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.IsAbleToDMGrave),DM_LOCATION_MANA,0)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,1,1,nil)
	if g1:GetCount()==0 then return end
	if Duel.SendtoDMGrave(g1,REASON_EFFECT)==0 then return end
	--power attacker
	dm.GainEffectPowerAttacker(c,c,1,3000,0)
	--double breaker
	dm.GainEffectBreaker(c,c,2,DM_EFFECT_DOUBLE_BREAKER,0)
end
