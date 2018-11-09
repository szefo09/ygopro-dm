--Gamil, Knight of Hatred
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.rettg,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCivilization(DM_CIVILIZATION_DARKNESS) and c:IsCreature() and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.DMGraveFilter(scard.retfilter1),DM_LOCATION_GRAVE,0)
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,1)
