--Grinning Hunger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter1(c,e)
	return c:IsFaceup() and c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.tgfilter2(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(scard.tgfilter1,tp,0,DM_LOCATION_BATTLE,nil,e)
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(scard.tgfilter2),0,DM_LOCATION_SHIELD,nil,e)
	g1:Merge(g2)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local sg=g1:Select(1-tp,1,1,nil)
	Duel.SetTargetCard(sg)
end
scard.tgop=dm.TargetSendtoGraveOperation
