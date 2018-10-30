--Baraga, Blade of Gloom
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
--scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,dm.ShieldZoneFilter(),DM_LOCATION_SHIELD,0,1,1,DM_HINTMSG_RTOHAND)
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_SHIELD) and chkc:IsControler(tp) end
	if chk==0 then return true end
	--changed to random because face-down cards can be viewed
	local g=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	Duel.SetTargetCard(g)
end
scard.retop=dm.ChooseSendtoHandOperation()
