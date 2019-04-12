--Stained Glass
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATIONS_FN) and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,scard.retfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
