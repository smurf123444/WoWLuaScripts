local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("MYTHIC_CLIENT", {})

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

-- Create a frame for the timer and loading bar
local frame = CreateFrame("Frame", "MyTimerFrame", UIParent)
frame:SetSize(200, 10)
frame:SetPoint("RIGHT", UIParent, "RIGHT", -130, 130)

-- Create a texture for the loading bar
local loadingBar = frame:CreateTexture(nil, "ARTWORK")

-- Create a font string for displaying the timer text
local timerText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
timerText:SetPoint("CENTER", frame, "CENTER", 0, 0)

-- Set the initial values for the timer
local elapsedTime = 0

-- Function to start the timer
function StartTimer(time)
    elapsedTime = time

    -- Set up the OnUpdate handler to update the loading bar and text
    frame:SetScript("OnUpdate", function(self, elapsed)
        elapsedTime = elapsedTime + elapsed
        loadingBar:SetPoint("CENTER")
        loadingBar:SetSize(64, 64)
        loadingBar:SetTexture(0, 1, 0)
        loadingBar:ClearAllPoints()             -- unsets any existing points
        loadingBar:SetPoint("CENTER")
        loadingBar:SetSize(elapsedTime, 64)     -- Adjusted this line
        timerText:SetText(string.format("%.1f", elapsedTime))
    end)
end

function MyHandlers.ShowTimer(player, text)
    frame:Show()
    StartTimer(text)
end

function MyHandlers.HideTimer()
    frame:Hide()
end

function MyHandlers.ShowMythicInfo()
    frameAttributes:Show()
end

function MyHandlers.SetText1(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Mythic Progress Summary|r")
    fontAttributesInfo1:SetText("|cFF000000" .. text .. "|r")
end

function MyHandlers.SetText2(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Mythic Progress Summary|r")
    fontAttributesInfo2:SetText("|cFF000000" .. text .. "|r")
end
