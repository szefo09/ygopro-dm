--Explosive Fighter Ucarn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoGraveOperation(PLAYER_PLAYER,dm.ManaZoneFilter(),DM_LOCATION_MANA,0,2))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
