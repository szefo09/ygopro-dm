--Three-Eyed Dragonfly
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy & get ability
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
scard.destg=dm.CheckCardFunction(nil,DM_LOCATION_BATTLE,0)
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,nil,tp,DM_LOCATION_BATTLE,0,1,1,c)
	if g1:GetCount()==0 then return end
	Duel.HintSelection(g1)
	if Duel.Destroy(g1,REASON_EFFECT)==0 then return end
	--power up
	dm.GainEffectUpdatePower(c,c,1,2000)
	--double breaker
	dm.GainEffectBreaker(c,c,2,DM_EFFECT_DOUBLE_BREAKER)
end
