--Aqua Agent
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--stealth (water)
	dm.EnableStealth(c,DM_CIVILIZATION_WATER)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget2(1,Card.IsAbleToHand)
scard.repop=dm.SingleDestroyReplaceOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
