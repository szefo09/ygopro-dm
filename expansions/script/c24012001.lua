--Kilstine, Nebula Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power up)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,0,dm.WaveStrikerCondition)
	dm.EnableUpdatePower(c,5000,dm.WaveStrikerCondition,DM_LOCATION_BATTLE,0)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	--wave striker (blocker)
	dm.AddStaticEffectBlocker(c,DM_LOCATION_BATTLE,0,nil,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,2,dm.WaveStrikerCondition)
	--wave striker (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.WaveStrikerCondition,DM_LOCATION_BATTLE,0)
	dm.AddEffectDescription(c,3,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
