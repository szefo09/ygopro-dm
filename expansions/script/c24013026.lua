--妖魔賢者メルカプ
--Melcap, the Mutant Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddSingleUnblockedAttackEffect(c,0,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
scard.poscon=dm.AttackPlayerCondition
scard.posop=dm.TapOperation(nil,Card.IsFaceup,0,DM_LOCATION_BATTLE)
