--Mihail, Celestial Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be destroyed
	dm.EnableCannotBeDestroyed(c,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,scard.indtg)
end
scard.duel_masters_card=true
function scard.indtg(e,c)
	return c~=e:GetHandler()
end
