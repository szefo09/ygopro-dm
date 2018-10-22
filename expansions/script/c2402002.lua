--Gor, Primal Hunter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tgtg=dm.ChooseCardFunction(PLAYER_OPPONENT,dm.ManaZoneFilter(Card.IsTapped),0,DM_LOCATION_MANA,2,2,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.ChooseSendtoGraveOperation
