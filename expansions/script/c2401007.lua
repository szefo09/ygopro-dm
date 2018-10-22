--神楽妖精パルティア
--Parthia, Dancing Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to deck
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tdtg,scard.tdop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tdtg=dm.ChooseCardFunction(PLAYER_PLAYER,dm.DMGraveFilter(),DM_LOCATION_GRAVE,0,0,3,DM_HINTMSG_TODECK)
scard.tdop=dm.ChooseSendtoDeckOperation(DECK_SEQUENCE_SHUFFLE)
