--沈黙の使徒カザミラ
--Kazamira, Vizier of Silence
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--to shield
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DecktopSendtoShieldOperation(PLAYER_ALL,PLAYER_ALL,2))
end
scard.duel_masters_card=true