--Saucer-Head Shark
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,scard.retfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000) and c:IsAbleToHand()
end
