--Skeleton Thief, the Revealer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsDMRace(DM_RACE_LIVING_DEAD) and c:IsAbleToHand()
end
function scard.retfilter2(c)
	return c:IsDMRace(DM_RACE_LIVING_DEAD)
end
scard.rettg=dm.CheckCardFunction(dm.DMGraveFilter(scard.retfilter1),DM_LOCATION_GRAVE,0)
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter2),DM_LOCATION_GRAVE,0,1)
