--Saliva Worm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power up)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,0,dm.WaveStrikerCondition)
	dm.EnableUpdatePower(c,4000,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	--wave striker (stealth) (darkness)
	dm.EnableStealth(c,DM_CIVILIZATION_DARKNESS,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,2,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
