--Faerie Life
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1))
end
scard.duel_masters_card=true
