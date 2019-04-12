--Bulgluf, the Spydroid
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (to shield)
	dm.EnableSilentSkill(c,0,scard.tstg,scard.tsop)
end
scard.duel_masters_card=true
scard.tstg=dm.CheckDeckFunction(PLAYER_SELF)
scard.tsop=dm.DecktopSendtoShieldOperation(PLAYER_SELF,1)
