--Terradragon Gamiratar
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to battle
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tbtg,scard.tbop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.tbtg=dm.TargetSendtoBattleTarget(PLAYER_OPPO,nil,0,LOCATION_HAND,0,1)
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.SendtoBattle(tc,0,1-tp,1-tp,false,false,POS_FACEUP_UNTAPPED)
end
