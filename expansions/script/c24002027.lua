--General Dark Fiend
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
--scard.tgtg=dm.ChooseCardFunction(PLAYER_PLAYER,dm.ShieldZoneFilter(),DM_LOCATION_SHIELD,0,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_SHIELD) and chkc:IsControler(tp) end
	if chk==0 then return true end
	--changed to random because face-down cards can be viewed
	local g=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	Duel.SetTargetCard(g)
end
scard.tgop=dm.ChooseSendtoGraveOperation
