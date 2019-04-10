--Factory Shell Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (search) (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,dm.HintTarget,scard.thop)
	dm.AddStaticEffectSingleComeIntoPlay(c,0,nil,dm.HintTarget,scard.thop,LOCATION_ALL,0,scard.thtg)
end
scard.duel_masters_card=true
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.DMIsRace,LOCATION_DECK,0,0,1,true,nil,DM_RACE_SURVIVOR)
function scard.thtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end