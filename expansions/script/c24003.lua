--煉獄の影トワイライト・テラー
--Twilight Terror, Shadow of Purgatory
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wins all battles (guardian)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_GUARDIAN))
	--discard
	dm.AddSingleComeIntoPlayEffect(c,1,nil,nil,dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,LOCATION_HAND,0,1))
end
scard.duel_masters_card=true
