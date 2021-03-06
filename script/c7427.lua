--魔界台本「魔王の降臨」
--Abyss Script - Rise of the Dark Ruler
--Scripted by Eerie Code
function c7427.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7427.target)
	e1:SetOperation(c7427.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7423,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c7427.thcon)
	e2:SetTarget(c7427.thtg)
	e2:SetOperation(c7427.thop)
	c:RegisterEffect(e2)
end

function c7427.aafil(c)
	return (c:IsSetCard(0x10ee) or c:IsSetCard(0x120e))
end
function c7427.asfil(c)
	return (c:IsSetCard(0x20ee) or c:IsSetCard(0x220e))
end

function c7427.cfil(c)
	return c:IsFaceup() and c7427.aafil(c) and c:IsPosition(POS_ATTACK)
end
function c7427.fil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c7427.limfil(c)
	return c:IsFaceup() and c7427.aafil(c) and c:IsLevelAbove(7)
end
function c7427.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c7427.cfil,tp,LOCATION_MZONE,0,nil)
	local mc=mg:GetClassCount(Card.GetCode)
	if chkc then return chkc:IsOnField() and c7427.fil(chkc) and chkc~=c end
	if chk==0 then return mc>0 and Duel.IsExistingTarget(c7427.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c7427.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mc,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if Duel.IsExistingMatchingCard(c7427.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c7427.chlimit)
	end
end
function c7427.chlimit(e,ep,tp)
	return tp==ep
end
function c7427.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c7427.thcfil(c)
	return c:IsFaceup() and c7427.aafil(c)
end
function c7427.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c7427.thcfil,tp,LOCATION_EXTRA,0,1,nil)
end
function c7427.thfil(c)
	return (c7427.aafil(c) or (c7427.asfil(c) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c7427.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c7427.thfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7427.thop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c7427.thfil,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=mg:Select(tp,1,1,nil)
	mg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(7427,0)) then
		local g2=mg:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
