local function fOnLoad(self)
	print("OnLoad ran")
end

local function create()
	local frame = CreateFrame("Frame", "Poker_TableBrowserX", UIParent, "BackdropTemplate")
	frame.backdropInfo = BACKDROP_DIALOG_32_32
	frame:ApplyBackdrop()

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)

	frame:SetSize(384, 350)

	frame:SetPoint("LEFT", nil, "CENTER", -200, 0)

	frame:SetScript("OnLoad", fOnLoad)
end

--local frame = create()
