--Eviscerating Warrior Lumez
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (destroy)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.desop,nil,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000)
end
scard.desop=dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)