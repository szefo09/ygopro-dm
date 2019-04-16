--Ripple Lotus Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (tap)
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.postg1,scard.posop,EFFECT_FLAG_CARD_TARGET)
	dm.AddStaticEffectSingleComeIntoPlay(c,0,true,scard.postg1,scard.posop,LOCATION_ALL,0,scard.postg2,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
function scard.postg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_BATTLE) and chkc:IsControler(1-tp) and scard.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.posfilter,0,DM_LOCATION_BATTLE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	Duel.SelectTarget(tp,scard.posfilter,tp,0,DM_LOCATION_BATTLE,1,1,nil)
end
scard.posop=dm.TargetTapOperation
function scard.postg2(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
