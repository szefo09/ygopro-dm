--聖神龍アルティメス
--Altimeth, Holy Divine Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability
	dm.AddTurnStartEffect(c,0,nil,true,nil,scard.abop)
	--to shield
	dm.AddSingleLeaveBattleEffect(c,1,nil,nil,dm.DecktopSendtoShieldOperation(PLAYER_SELF,1))
	--tap
	dm.AddSingleComeIntoPlayEffect(c,2,true,scard.postg,scard.posop)
end
scard.duel_masters_card=true
--get ability
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--blocker
		dm.RegisterEffectBlocker(c,tc,3,RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
end
--tap
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,0,DM_LOCATION_BATTLE)
scard.posop=dm.TapOperation(nil,scard.posfilter,0,DM_LOCATION_BATTLE)
