--Megaria, Empress of Dread
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (slayer)
	dm.AddStaticEffectSlayer(c,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
end
scard.duel_masters_card=true
