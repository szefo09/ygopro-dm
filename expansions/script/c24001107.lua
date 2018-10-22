--Thorny Mandra
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsCreature() and c:IsAbleToMana()
end
scard.tmtg=dm.CheckCardFunction(dm.DMGraveFilter(scard.tmfilter),DM_LOCATION_GRAVE,0)
scard.tmop=dm.SendtoManaOperation(PLAYER_PLAYER,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,1)
