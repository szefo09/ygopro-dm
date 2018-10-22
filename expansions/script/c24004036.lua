--Shadow Moon, Cursed Shade
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,scard.powtg)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
