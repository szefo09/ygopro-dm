--聖霊龍騎アサイラム
--Asylum, the Dragon Paladin
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (angel command, armored dragon)
	dm.EnableSympathy(c,DM_RACE_ANGEL_COMMAND,DM_RACE_ARMORED_DRAGON)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy replace (to shield)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToSZone)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoSZone)
