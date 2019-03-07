--Typhoon Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,dm.CannotBeAttackedCivValue(DM_CIVILIZATIONS_FN))
end
scard.duel_masters_card=true
