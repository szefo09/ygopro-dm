--Forbos, Sanctum Guardian Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (search) (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,dm.HintTarget,scard.thop)
	dm.AddStaticEffectComeIntoPlay(c,0,nil,dm.HintTarget,scard.thop,LOCATION_ALL,0,scard.thtg)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
scard.thop=dm.SendtoHandOperation(PLAYER_PLAYER,scard.thfilter,LOCATION_DECK,0,0,1,true)
function scard.thtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
