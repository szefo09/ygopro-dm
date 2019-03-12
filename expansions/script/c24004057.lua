--King Aquakamui
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,scard.powtg)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c:DMIsRace(DM_RACE_ANGEL_COMMAND) or c:DMIsRace(DM_RACE_DEMON_COMMAND)
end
function scard.retfilter(c)
	return scard.powfilter(c) and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0)
scard.retop=dm.SendtoHandOperation(nil,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0)
