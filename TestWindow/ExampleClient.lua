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

local fontAttributesInfo = frameAttributes:CreateFontString("fontAttributesInfo")
fontAttributesInfo:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesInfo:SetSize(300, 400)
fontAttributesInfo:SetPoint("TOPLEFT", -20, -45)
fontAttributesInfo:SetText("|cffFFC125Strength|r")


--[[  local fontAttributesStrengthValue = frameAttributes:CreateFontString("fontAttributesStrengthValue")
fontAttributesStrengthValue:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesStrengthValue:SetSize(50, 5)
fontAttributesStrengthValue:SetPoint("TOPLEFT", 107, -45)
 ]]
 local buttonAttributesIncreaseAttack = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseAttack:SetSize(20, 20)
buttonAttributesIncreaseAttack:SetPoint("TOPLEFT", 190, -70)
buttonAttributesIncreaseAttack:EnableMouse(true)
buttonAttributesIncreaseAttack:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseAttack:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseAttack:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseAttack:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)
       
local buttonAttributesIncreaseStrength = CreateFrame("Button", "buttonAttributessIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseStrength:SetSize(20, 20)
buttonAttributesIncreaseStrength:SetPoint("TOPLEFT", 190, -120)
buttonAttributesIncreaseStrength:EnableMouse(true)
buttonAttributesIncreaseStrength:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseStrength:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseStrength:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseStrength:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseDefence = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseDefence:SetSize(20, 20)
buttonAttributesIncreaseDefence:SetPoint("TOPLEFT", 190, -160)
buttonAttributesIncreaseDefence:EnableMouse(true)
buttonAttributesIncreaseDefence:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseDefence:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseDefence:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseDefence:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseMagic = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseMagic:SetSize(20, 20)
buttonAttributesIncreaseMagic:SetPoint("TOPLEFT", 190, -210)
buttonAttributesIncreaseMagic:EnableMouse(true)
buttonAttributesIncreaseMagic:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseMagic:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseMagic:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseMagic:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseRange = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseRange:SetSize(20, 20)
buttonAttributesIncreaseRange:SetPoint("TOPLEFT", 190, -250)
buttonAttributesIncreaseRange:EnableMouse(true)
buttonAttributesIncreaseRange:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseRange:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseRange:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseHitpoints = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseHitpoints:SetSize(20, 20)
buttonAttributesIncreaseHitpoints:SetPoint("TOPLEFT", 190, -290)
buttonAttributesIncreaseHitpoints:EnableMouse(true)
buttonAttributesIncreaseHitpoints:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseHitpoints:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseHitpoints:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreasePrayer = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreasePrayer:SetSize(20, 20)
buttonAttributesIncreasePrayer:SetPoint("TOPLEFT", 190, -340)
buttonAttributesIncreasePrayer:EnableMouse(true)
buttonAttributesIncreasePrayer:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreasePrayer:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreasePrayer:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseWoodcutting = CreateFrame("Button", "buttonAttributesIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseWoodcutting:SetSize(20, 20)
buttonAttributesIncreaseWoodcutting:SetPoint("TOPLEFT", 190, -380)
buttonAttributesIncreaseWoodcutting:EnableMouse(true)
buttonAttributesIncreaseWoodcutting:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseWoodcutting:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseWoodcutting:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) Hitpoints

function MyHandlers.ShowAttributes(player)
    frameAttributes:Show()
end

function MyHandlers.SetStats(player, left, p1, p2, p3, p4, p5)


end
function MyHandlers.SetText(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")
    fontAttributesInfo:SetText("|cFF000000" ..text.."|r")

end