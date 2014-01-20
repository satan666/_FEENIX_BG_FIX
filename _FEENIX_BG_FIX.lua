local flf = CreateFrame("frame",nil, UIParent); 
local Original_CancelLogout = CancelLogout
local Original_Logout = Logout
local OriginalStaticPopup_OnShow = StaticPopup_OnShow

local player_logout = nil
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

flf:SetScript("OnEvent",FLF_Event);

Fix_Logout = function()
	player_logout = true
	Original_Logout()
end

Fix_CancelLogout = function()
	player_logout = nil
	Original_CancelLogout()
	StaticPopup_Hide("CAMP");
end

FixStaticPopup_OnShow = function()
	if this.which == "CAMP" then
		if not player_logout then
			--DEFAULT_CHAT_FRAME:AddMessage("_BG Fix - Fake Logout Detected")
			StaticPopup_Hide("CAMP");
		end	
	elseif this.which == "DEATH" and UnitHealth("player") > 0 then
		--DEFAULT_CHAT_FRAME:AddMessage("_BG Fix - Fake Release Spirit Detected")
		StaticPopup_Hide("DEATH");	
	end
	
	OriginalStaticPopup_OnShow()
end