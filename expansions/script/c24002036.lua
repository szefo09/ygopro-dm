--Bombersaur
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleDestroyedEffect(c,0,nil,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(tp,dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(1-tp,dm.ManaZoneFilter(),1-tp,DM_LOCATION_MANA,0,2,2,nil)
end
scard.tgop=dm.ChooseSendtoGraveOperation
