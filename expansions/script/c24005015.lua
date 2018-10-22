--Thunder Net
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_WATER)
end
function scard.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_BATTLE) and chkc:IsControler(1-tp) and chkc:IsUntapped() end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	Duel.SelectTarget(tp,Card.IsUntapped,tp,0,DM_LOCATION_BATTLE,0,ct,nil)
end
scard.posop=dm.ChooseTapUntapOperation(POS_FACEUP_TAPPED)
