--Aqua Strummer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sort
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,dm.SortDecktopOperation(PLAYER_SELF,PLAYER_SELF,5))
end
scard.duel_masters_card=true
