--カラミティ・ドラゴン
--Calamity Dragon
--Not fully implemented: DEF~=ATK
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--power attacker
	dm.EnablePowerAttacker(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,1,scard.tbcon)
end
scard.duel_masters_card=true
--power attacker
function scard.powval(c,e)
	local t={5000,6000,7000,8000,9000,10000,11000,12000,13000,14000}
	return math.randomchoice(t)
end
--double breaker
function scard.dbcon(e)
	local c=e:GetHandler()
	return c:IsPowerAbove(6000) and c:GetPower()<12000
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(12000)
end
