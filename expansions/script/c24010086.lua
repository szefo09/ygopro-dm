--Karate Potato
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(Card.IsAbleToMana,LOCATION_HAND,0)
scard.tmop=dm.SendtoManaOperation(PLAYER_SELF,nil,LOCATION_HAND,0,1,2)
