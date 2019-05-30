--Steamroller Mutant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (destroy)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.desop,nil,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
scard.desop=dm.DestroyOperation(nil,Card.IsFaceup,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
