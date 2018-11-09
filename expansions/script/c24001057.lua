--Gigargon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,0,2))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
