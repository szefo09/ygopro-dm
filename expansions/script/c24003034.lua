--Armored Warrior Quelos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.tgfilter1(c)
	return not c:IsCivilization(DM_CIVILIZATION_FIRE)
end
function scard.tgfilter2(c,e)
	return not c:IsCivilization(DM_CIVILIZATION_FIRE) and c:IsCanBeEffectTarget(e)
end
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.tgfilter1),tp,DM_LOCATION_MANA,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoDMGrave(g1,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(scard.tgfilter2),1-tp,DM_LOCATION_MANA,0,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoDMGrave(g2,REASON_EFFECT)
end
