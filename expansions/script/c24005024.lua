--Split-Head Hydroturtle Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (draw)
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.drtg1,scard.drop)
	dm.AddStaticEffectAttackTrigger(c,0,true,scard.drtg1,scard.drop,LOCATION_ALL,0,scard.drtg2)
end
scard.duel_masters_card=true
function scard.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.drop=dm.DrawOperation(PLAYER_SELF,1)
function scard.drtg2(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
