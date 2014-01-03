local flf = CreateFrame("frame",nil, UIParent); 
local Original_CancelLogout = CancelLogout
local Original_Logout = Logout
local OriginalStaticPopup_OnShow = StaticPopup_OnShow
local active_logout = nil

local timer_death = nil
local timer_logout = nil

flf:RegisterEvent("ADDON_LOADED");

FLF_Event = function()
	DEFAULT_CHAT_FRAME:AddMessage("_BG_POPUP_FIX by Ogrisch loaded")
	flf:UnregisterEvent("ADDON_LOADED");
	
	Logout = Fix_Logout
	CancelLogout = Fix_CancelLogout
	StaticPopup_OnShow = FixStaticPopup_OnShow
end

FLF_Update = function()
	local time = GetTime()
	
	if timer_death and time > timer_death then
		timer_death = nil
		StaticPopup_Hide("DEATH");
		
	elseif timer_logout and time > timer_logout then
		StaticPopup_Hide("CAMP");	
		timer_logout = nil
	end 
end

flf:SetScript("OnEvent",FLF_Event);
flf:SetScript("OnUpdate",FLF_Event);


FixStaticPopup_OnShow = function()
	if this.which == "CAMP" then --and (GetRealZoneText() == "Alterac Valley" or GetRealZoneText() == "Arathi Basin" or GetRealZoneText() == "Warsong Gulch") and not active_logout then
		DEFAULT_CHAT_FRAME:AddMessage(this.which)
		if not active_logout then
			DEFAULT_CHAT_FRAME:AddMessage("_BG Fix - Fake Logout Detected --------------------------------")
			--this:Hide()
			--StaticPopup_Hide("CAMP");
			timer_death = GetTime() + 0.25
			
		end	
	elseif this.which == "DEATH" and UnitHealth("player") > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("_BG Fix - Fake Release Spirit Detected ---------------------------")
		--this:Hide()
		--StaticPopup_Hide("DEATH"); 
		timer_logout = GetTime() + 0.25
	else
		OriginalStaticPopup_OnShow()
	end
end

ClosePopUp = function(popup)
	for i=1,STATICPOPUP_NUMDIALOGS do
		local frame = getglobal("StaticPopup"..i)
		if frame:IsShown() and frame.which == popup then
			frame:Hide()
		end
	end
end

Fix_Logout = function()
	active_logout = true
	Original_Logout()
end

Fix_CancelLogout = function()
	active_logout = nil
	Original_CancelLogout()
	ClosePopUp("CAMP")
end