--サイバー・ブレイン
--Cyber Brain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,dm.DrawUpToOperation(PLAYER_PLAYER,3))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.DrawUpToOperation(PLAYER_PLAYER,3))
end
scard.duel_masters_card=true
