--Nariel, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,aux.TargetBoolFunction(Card.IsPowerAbove,3000))
end
scard.duel_masters_card=true
