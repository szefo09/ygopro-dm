--怒璃流男 (Drill Man)
--Drill Mutant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,dm.DMGraveFilter(Card.IsEvolution),DM_LOCATION_GRAVE,0,1))
end
scard.duel_masters_card=true