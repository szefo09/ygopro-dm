--Crisis Boulder
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(scard.tgfilter,tp,0,DM_LOCATION_BATTLE,nil,e)
	local g2=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsCanBeEffectTarget),0,DM_LOCATION_MANA,nil,e)
	g1:Merge(g2)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local sg=g1:Select(1-tp,1,1,nil)
	Duel.SetTargetCard(sg)
end
scard.tgop=dm.TargetSendtoGraveOperation
