local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("Kaev", {})

-- Attribute window
local frameAttributes = CreateFrame("Frame", "frameAttributes", UIParent)
frameAttributes:SetSize(250, 500)
frameAttributes:SetMovable(true)
frameAttributes:EnableMouse(true)
frameAttributes:RegisterForDrag("LeftButton")
frameAttributes:SetPoint("CENTER")
frameAttributes:SetBackdrop(
{
    bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
-- Drag & Drop
frameAttributes:SetScript("OnDragStart", frameAttributes.StartMoving)
frameAttributes:SetScript("OnHide", frameAttributes.StopMovingOrSizing)
frameAttributes:SetScript("OnDragStop", frameAttributes.StopMovingOrSizing)
frameAttributes:Hide()

-- Close button
local buttonAttributesClose = CreateFrame("Button", "buttonAttributesClose", frameAttributes, "UIPanelCloseButton")
buttonAttributesClose:SetPoint("TOPRIGHT", -5, -5)
buttonAttributesClose:EnableMouse(true)
buttonAttributesClose:SetSize(27, 27)

-- Title bar
local frameAttributesTitleBar = CreateFrame("Frame", "frameAttributesTitleBar", frameAttributes, nil)
frameAttributesTitleBar:SetSize(135, 25)
frameAttributesTitleBar:SetBackdrop(
{
    bgFile = "Interface/CHARACTERFRAME/UI-Party-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameAttributesTitleBar:SetPoint("TOP", 0, 9)

local fontAttributesTitleText = frameAttributesTitleBar:CreateFontString("fontAttributesTitleText")
fontAttributesTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontAttributesTitleText:SetSize(190, 5)
fontAttributesTitleText:SetPoint("CENTER", 0, 0)
fontAttributesTitleText:SetText("|cffFFC125Attribute Points|r")


-- Strength
local fontAttributesStrength = frameAttributes:CreateFontString("fontAttributesStrength")
fontAttributesStrength:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesStrength:SetSize(300, 400)
fontAttributesStrength:SetPoint("TOPLEFT", -20, -45)
fontAttributesStrength:SetText("|cFF000000Strength|r")

--[[ local fontAttributesStrengthValue = frameAttributes:CreateFontString("fontAttributesStrengthValue")
fontAttributesStrengthValue:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesStrengthValue:SetSize(50, 5)
fontAttributesStrengthValue:SetPoint("TOPLEFT", 107, -45) ]]

--[[ local buttonAttributesIncreaseStrength = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseStrength:SetSize(20, 20)
buttonAttributesIncreaseStrength:SetPoint("TOPLEFT", 144, -39)
buttonAttributesIncreaseStrength:EnableMouse(true)
buttonAttributesIncreaseStrength:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseStrength:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseStrength:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
buttonAttributesIncreaseStrength:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)
       
local buttonAttributesDecreaseStrength = CreateFrame("Button", "buttonAttributesDecreaseStrength", frameAttributes, nil)
buttonAttributesDecreaseStrength:SetSize(20, 20)
buttonAttributesDecreaseStrength:SetPoint("TOPLEFT", 104, -39)
buttonAttributesDecreaseStrength:EnableMouse(true)
buttonAttributesDecreaseStrength:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Up")
buttonAttributesDecreaseStrength:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesDecreaseStrength:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Down")
buttonAttributesDecreaseStrength:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesDecrease", 1) end) ]]



function MyHandlers.ShowAttributes(player)
    frameAttributes:Show()
end

function MyHandlers.SetStats(player, left, p1, p2, p3, p4, p5)
    fontAttributesStrengthValue:SetText("|cFF000000"..p1.."|r")

end
function MyHandlers.SetText(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")
    fontAttributesStrength:SetText("|cffFFC125" ..text.."|r")
end