--Psyshroom
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter1(c)
	return c:IsCivilization(DM_CIVILIZATION_NATURE) and c:IsAbleToMana()
end
function scard.tmfilter2(c)
	return c:IsCivilization(DM_CIVILIZATION_NATURE)
end
scard.tmtg=dm.CheckCardFunction(dm.DMGraveFilter(scard.tmfilter1),DM_LOCATION_GRAVE,0)
scard.tmop=dm.SendtoManaOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.tmfilter2),DM_LOCATION_GRAVE,0,1)
