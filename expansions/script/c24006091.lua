--Bliss Totem, Avatar of Luck
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to mana)
	dm.EnableTapAbility(c,0,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(dm.DMGraveFilter(Card.IsAbleToMana),DM_LOCATION_GRAVE,0)
scard.tmop=dm.SendtoManaOperation(PLAYER_SELF,dm.DMGraveFilter(Card.IsAbleToMana),DM_LOCATION_GRAVE,0,0,3)
