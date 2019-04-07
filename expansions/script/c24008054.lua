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
scard.tbtg=dm.TargetCardFunction(PLAYER_OPPO,nil,0,LOCATION_HAND,0,1,DM_HINTMSG_TOBATTLE)
scard.tbop=dm.TargetSendtoBattleOperation(PLAYER_OPPO,PLAYER_OPPO,POS_FACEUP_UNTAPPED)
