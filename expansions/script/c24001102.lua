--Poisonous Mushroom
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(Card.IsAbleToMana,LOCATION_HAND,0)
scard.tmop=dm.SendtoManaOperation(PLAYER_PLAYER,Card.IsAbleToMana,LOCATION_HAND,0,1)
