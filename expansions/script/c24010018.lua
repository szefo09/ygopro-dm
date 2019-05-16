--Kaemira, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (to shield)
	dm.EnableSilentSkill(c,0,dm.DecktopSendtoShieldTarget(PLAYER_SELF),dm.DecktopSendtoShieldOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
