--悪魔聖霊バルホルス
--Balforce, the Demonic Holy Spirit
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--must attack
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK,nil,0,DM_LOCATION_BATTLE)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--untap
	dm.AddSingleBlockEffect(c,0,nil,nil,dm.SelfUntapOperation())
end
scard.duel_masters_card=true
