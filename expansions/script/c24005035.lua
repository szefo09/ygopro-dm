--Wisp Howler, Shadow of Tears
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--slayer
	dm.EnableSlayer(c,nil,dm.CivilizationSlayerTarget(DM_CIVILIZATIONS_LN),DM_DESC_NATURE_LIGHT_SLAYER)
end
scard.duel_masters_card=true
