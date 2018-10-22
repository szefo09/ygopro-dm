--Dogarn, the Marauder
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsTapped,c:GetControler(),DM_LOCATION_BATTLE,0,c)*2000
end
