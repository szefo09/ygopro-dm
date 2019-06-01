--Dimension Splitter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffectCustom(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.rettg,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:DMIsRace(DM_RACE_DRAGON) and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0)
scard.retop=dm.SendtoHandOperation(nil,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0)
