--Ularus, Punishment Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.conftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=dm.ShieldZoneFilter(Card.IsFacedown)
	if chkc then return chkc:IsLocation(DM_LOCATION_SHIELD) and f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,DM_LOCATION_SHIELD,DM_LOCATION_SHIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CONFIRM)
	Duel.SelectTarget(tp,f,tp,DM_LOCATION_SHIELD,DM_LOCATION_SHIELD,ct,ct,nil)
end
scard.confop=dm.TargetConfirmOperation(true)
