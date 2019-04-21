--再生の使徒ノルカ・ソルカ
--Nolka Solka, Vizier of Regeneration
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost down
	dm.EnableUpdateManaCost(c,-3,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsSpell))
	--tap ability (return)
	dm.EnableTapAbility(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsSpell() and c:IsAbleToHand()
end
function scard.retfilter2(c,e)
	return scard.retfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_MANA) and chkc:IsControler(tp) and dm.ManaZoneFilter(scard.retfilter1)(chkc) end
	if chk==0 then return Duel.IsExistingTarget(dm.ManaZoneFilter(scard.retfilter1),DM_LOCATION_MANA,0,1,nil) end
	local g=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.retfilter2),tp,DM_LOCATION_MANA,0,nil,e):RandomSelect(tp,1)
	Duel.SetTargetCard(g)
end
scard.retop=dm.TargetSendtoHandOperation()
