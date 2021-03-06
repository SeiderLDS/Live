--魔界劇団－プリティ・ヒロイン
--Abyss Actor - Pretty Heroine
--Scripted by Eerie Code
function c7421.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c7421.pcon)
	e1:SetTarget(c7421.ptg)
	e1:SetOperation(c7421.pop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7421,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetTarget(c7421.atktg)
	e2:SetOperation(c7421.atkop)
	c:RegisterEffect(e2)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7421,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c7421.setcon)
	e5:SetTarget(c7421.settg)
	e5:SetOperation(c7421.setop)
	c:RegisterEffect(e5)
end

function c7421.aafil(c)
	return (c:IsSetCard(0x10ee) or c:IsSetCard(0x120e))
end
function c7421.asfil(c)
	return (c:IsSetCard(0x20ee) or c:IsSetCard(0x220e))
end

function c7421.pcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return ep==tp and a:IsControler(1-tp)
end
function c7421.thfil(c,dam)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c7421.aafil(c) and c:IsAttackBelow(dam) and c:IsAbleToHand()
end
function c7421.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local dam=ev
	local b1=a:IsRelateToBattle()
	local b2=Duel.IsExistingMatchingCard(c7421.thfil,tp,LOCATION_EXTRA,0,1,nil,dam)
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(7421,0),aux.Stringid(7421,1))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(7421,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(7421,1))+1
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	end
end
function c7421.pop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if opt==0 then
		local a=Duel.GetAttacker()
		if a:IsRelateToBattle() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-ev)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			a:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c7421.thfil,tp,LOCATION_EXTRA,0,1,1,nil,ev)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c7421.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c7421.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c7421.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)) or c:IsReason(REASON_BATTLE)
end
function c7421.setfil(c)
	return c7421.asfil(c) and c:IsType(TYPE_SPELL) and c:IsSSetable(false)
end
function c7421.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c7421.setfil,tp,LOCATION_DECK,0,1,nil) end
end
function c7421.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c7421.setfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
