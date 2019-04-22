--炎槍と水剣の裁
--Judgement of the Flame's Spear and the Water's Blade
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy & draw
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct==0 or not Duel.IsPlayerCanDraw(tp,1) or not Duel.SelectYesNo(tp,DM_QHINTMSG_DRAW) then return end
	Duel.BreakEffect()
	Duel.Draw(tp,ct,REASON_EFFECT)
end
