--Cataclysmic Eruption
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_NATURE)
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_MANA) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(tp,dm.ManaZoneFilter(),tp,0,DM_LOCATION_MANA,0,ct,nil)
end
scard.tgop=dm.ChooseSendtoGraveOperation
