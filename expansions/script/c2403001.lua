--再生の使徒ノルカ・ソルカ
--Nolka Solka, Vizier of Regeneration
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost down
	dm.EnableUpdateManaCost(c,LOCATION_HAND,0,scard.mccon,scard.mctg,-3)
	--tap ability (to hand)
	dm.EnableTapAbility(c,0,scard.thtg,scard.thop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.mctg=aux.TargetBoolFunction(Card.IsSpell)
--mana cost down
function scard.mcfilter(c)
	return c:IsSpell() and c:IsManaCostAbove(2)
end
function scard.mccon(e)
	return Duel.IsExistingMatchingCard(scard.mcfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
--tap ability (to hand)
function scard.thfilter(c,e)
	return c:IsSpell() and c:IsCanBeEffectTarget(e)
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_MANA) and chkc:IsControler(tp) end
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.thfilter),tp,DM_LOCATION_MANA,0,nil,e):RandomSelect(tp,1)
	Duel.SetTargetCard(g)
end
scard.thop=dm.ChooseSendtoHandOperation()
