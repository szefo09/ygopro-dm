--Bronze-Arm Tribe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1))
end
scard.duel_masters_card=true