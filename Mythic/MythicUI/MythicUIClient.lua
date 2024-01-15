local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("MythicUI", {})

-- Attribute window
local frameAttributes = CreateFrame("Frame", "frameAttributes", UIParent)
frameAttributes:SetSize(350, 350)
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

-- Main Close button
local buttonAttributesClose = CreateFrame("Button", "buttonAttributesClose", frameAttributes, "UIPanelCloseButton")
buttonAttributesClose:SetPoint("TOPRIGHT", -5, -5)
buttonAttributesClose:EnableMouse(true)
buttonAttributesClose:SetSize(27, 27)

-- Main Title bar
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

-- Main Text
local fontAttributesInfo1 = frameAttributes:CreateFontString("fontAttributesInfo1")
fontAttributesInfo1:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesInfo1:SetSize(450, 500)
fontAttributesInfo1:SetPoint("TOPLEFT", -50, 85)
local fontAttributesInfo2 = frameAttributes:CreateFontString("fontAttributesInfo2")
fontAttributesInfo2:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesInfo2:SetSize(250, 800)
fontAttributesInfo2:SetPoint("TOPRIGHT", 30, 85)

--------
-------

--SubAttribute Window
local subFrameAttributes = CreateFrame("Frame", "subFrameAttributes", UIParent)
subFrameAttributes:SetSize(250, 500)
subFrameAttributes:SetMovable(true)
subFrameAttributes:EnableMouse(true)
subFrameAttributes:RegisterForDrag("LeftButton")
subFrameAttributes:SetPoint("CENTER")
subFrameAttributes:SetBackdrop(
    {
        bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        edgeSize = 20,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
-- Drag & Drop
subFrameAttributes:SetScript("OnDragStart", subFrameAttributes.StartMoving)
subFrameAttributes:SetScript("OnHide", subFrameAttributes.StopMovingOrSizing)
subFrameAttributes:SetScript("OnDragStop", subFrameAttributes.StopMovingOrSizing)
subFrameAttributes:Hide()



-- Create a close button for the window

-- Sub Close button

-- Sub Title bar
local subFontAttributesTitleBar = CreateFrame("Frame", "subFontAttributesTitleBar", subFrameAttributes, nil)
subFontAttributesTitleBar:SetSize(135, 25)
subFontAttributesTitleBar:SetBackdrop(
    {
        bgFile = "Interface/CHARACTERFRAME/UI-Party-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
subFontAttributesTitleBar:SetPoint("TOP", 0, 9)

local subFontAttributesTitleText = subFontAttributesTitleBar:CreateFontString("subFontAttributesTitleText")
subFontAttributesTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
subFontAttributesTitleText:SetSize(190, 5)
subFontAttributesTitleText:SetPoint("CENTER", 0, 0)
subFontAttributesTitleText:SetText("|cffFFC125Attribute Points|r")

-- Sub Text
local subFontAttributesInfo = frameAttributes:CreateFontString("subFontAttributesInfo")
subFontAttributesInfo:SetFont("Fonts\\FRIZQT__.TTF", 15)
subFontAttributesInfo:SetSize(300, 400)
subFontAttributesInfo:SetPoint("TOPLEFT", -20, -45)



local function CreateAttributesFrame(name, titleText)
    local frame = CreateFrame("Frame", name, UIParent)
    frame:SetSize(250, 300)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface/AchievementFrame/UI-Achievement-Parchment-Horizontal",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        edgeSize = 20,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnHide", frame.StopMovingOrSizing)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    local titleBar = CreateFrame("Frame", name .. "TitleBar", frame, nil)
    titleBar:SetSize(135, 25)
    titleBar:SetBackdrop({
        bgFile = "Interface/CHARACTERFRAME/UI-Party-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    titleBar:SetPoint("TOP", 0, 9)

    local titleText1 = titleBar:CreateFontString(name .. "TitleText")
    titleText1:SetFont("Fonts\\FRIZQT__.TTF", 13)
    titleText1:SetSize(190, 5)
    titleText1:SetPoint("CENTER", 0, 0)
    titleText1:SetText("|cffFFC125" .. titleText .. "|r")

    local infoText = frame:CreateFontString(name .. "Info")
    infoText:SetFont("Fonts\\FRIZQT__.TTF", 15)
    infoText:SetSize(300, 400)
    infoText:SetPoint("TOPLEFT", -20, -45)

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    closeButton:EnableMouse(true)
    closeButton:SetSize(27, 27)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    return frame, infoText
end

local frame1, frame1InfoText = CreateAttributesFrame("frame1InfoText", "frame1InfoText Info")
local frame2, frame2InfoText = CreateAttributesFrame("frame2InfoText", "frame2InfoText Info")
local frame3, frame3InfoText = CreateAttributesFrame("frame3InfoText", "frame3InfoText Info")
local frame4, frame4InfoText = CreateAttributesFrame("frame4InfoText", "frame4InfoText Info")
local frame5, frame5InfoText = CreateAttributesFrame("frame5InfoText", "frame5InfoText Info")
local frame6, frame6InfoText = CreateAttributesFrame("frame6InfoText", "frame6InfoText Info")





local function createButton(name, yOffset, onClick)
    local button = CreateFrame("Button", name, frameAttributes, nil)
    button:SetSize(20, 20)
    button:SetPoint("TOPLEFT", 130, yOffset)
    button:EnableMouse(true)
    button:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
    button:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
    button:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
    button:SetScript("OnMouseUp", onClick)
end
local function createButton2(name, yOffset, onClick)
    local button = CreateFrame("Button", name, frameAttributes, nil)
    button:SetSize(20, 20)
    button:SetPoint("TOPLEFT", 260, yOffset)
    button:EnableMouse(true)
    button:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
    button:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
    button:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
    button:SetScript("OnMouseUp", onClick)
end

--[[ createButton("buttonAttributesIncreaseAttack", -70, function() ShowItem1() end)
createButton("buttonAttributesIncreaseStrength", -120, function() ShowItem2() end)
createButton("buttonAttributesIncreaseDefence", -160, function() ShowItem3() end)


createButton2("buttonAttributesIncreaseCrafting", -70,  function() ShowItem4() end)
createButton2("buttonAttributesIncreaseSmithing", -120, function() ShowItem5() end)
createButton2("buttonAttributesIncreaseMining", -160, function() ShowItem6() end) ]]

-- Ranged skill
function ShowItem1()
    frame1InfoText:SetText("|cffFFC125frame1InfoText Skill Info|r")
    frame1:Show()

end

function ShowItem2()
    frame2InfoText:SetText("|cffFFC125frame2InfoText Skill Info|r")
    frame2:Show()

end

function ShowItem3()
    frame3InfoText:SetText("|cffFFC125frame3InfoText Skill Info|r")
    frame3:Show()
end

function MyHandlers.ShowAttributes()
    frameAttributes:Show()
end

function ShowItem4()
    frame4InfoText:SetText("|cffFFC125frame4InfoText Skill Info|r")
    frame4:Show()
end

function ShowItem5()
    frame5InfoText:SetText("|cffFFC125frame5InfoText Skill Info|r")
    frame5:Show()
end

function ShowItem6()
    frame6InfoText:SetText("|cffFFC125frame6InfoText Skill Info|r")
    frame6:Show()
end

function MyHandlers.SetText1(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Mythic Progress Summary|r")
    fontAttributesInfo1:SetText("|cFF000000" .. text .. "|r")
end

function MyHandlers.SetText2(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Mythic Progress Summary|r")
    fontAttributesInfo2:SetText("|cFF000000" .. text .. "|r")
end