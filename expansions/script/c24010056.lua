--Spark Chemist, Shadow of Whim
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(),DM_LOCATION_MANA,0))
end
scard.duel_masters_card=true
