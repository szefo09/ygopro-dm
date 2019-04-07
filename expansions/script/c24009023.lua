--Tekorax
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.ConfirmOperation(nil,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SHIELD))
end
scard.duel_masters_card=true
