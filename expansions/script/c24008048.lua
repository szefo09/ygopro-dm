--Coliseum Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleTriggerEffectCustom(c,0,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.DecktopSendtoManaTarget(PLAYER_SELF)
scard.tmop=dm.DecktopSendtoManaOperation(PLAYER_SELF,1)
