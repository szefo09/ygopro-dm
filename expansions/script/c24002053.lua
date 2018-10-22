--Silver Axe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.DecktopSendtoManaTarget(PLAYER_PLAYER)
scard.tmop=dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1)
