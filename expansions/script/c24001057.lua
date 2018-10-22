--Gigargon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.retop)
end
scard.duel_masters_card=true
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,0,2)
