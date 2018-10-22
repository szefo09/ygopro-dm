--ストームジャベリン・ワイバーン
--Storm Javelin Wyvern
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--attack untapped
	dm.EnableAttackUntapped(c,DM_EFFECT_ATTACK_UNTAPPED_LIGHT,DM_EFFECT_ATTACK_UNTAPPED_WATER)
end
scard.duel_masters_card=true
