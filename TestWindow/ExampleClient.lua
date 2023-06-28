local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("Kaev", {})

-- Attribute window
local frameAttributes = CreateFrame("Frame", "frameAttributes", UIParent)
frameAttributes:SetSize(300, 650)
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
fontAttributesInfo1:SetSize(250, 800)
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
-- Function to create and show the 3D model viewer
local frame = nil
local model = nil
local fired = false -- Flag variable to track if the function has already fired

local function CloseModelViewer()
    if frame then
        frame:Hide() -- Hide the frame if it exists
        fired = false -- Reset the fired flag
    end
end
local buttonSubAttributesClose = CreateFrame("Button", nil, subFrameAttributes, "UIPanelCloseButton")
buttonSubAttributesClose:SetPoint("TOPRIGHT", -5, -5)
buttonSubAttributesClose:EnableMouse(true)
buttonSubAttributesClose:SetSize(27, 27)
buttonSubAttributesClose:SetScript("OnClick", function()
    CloseModelViewer()
    subFrameAttributes:Hide()
end)

local function ShowModelViewer()
    if fired then
        frame:Show() -- If already fired, show the existing frame
        return
    end
    frame = CreateFrame("Frame", "MyModelViewerFrame", subFrameAttributes)
    frame:SetBackdrop({
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:SetBackdropBorderColor(1, 1, 1)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetSize(400, 400)
    frame:SetPoint("CENTER")
    frame:Hide()
    
    -- Create a model widget
    model = CreateFrame("PlayerModel", nil, frame)
    model:ClearModel()
    model:SetAllPoints(frame)
    model:SetModelScale(.5) -- Adjust the scale as needed
    
    -- Function to load a 3D model file into the viewer
    local function LoadModel(modelFile)
        model:ClearModel()
        model:SetModel(modelFile)
    end
    
    -- Load an example model file (replace with your desired model file)
    LoadModel("Item\\ObjectComponents\\Weapon\\Ashbringer02.m2")
    
    -- Enable frame movement
    frame:SetMovable(false)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self, button)
        if button == "LeftButton" and not IsControlKeyDown() then
            self:StartMoving()
        end
    end)
    frame:SetScript("OnDragStop", function(self, button)
        self:StopMovingOrSizing()
    end)
    frame:EnableMouse(true)
    
        -- Function to close the model viewer frame

    -- Function to handle rotation when Ctrl key is held
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            if IsControlKeyDown() then
                self.rotating = true
                self.rotationStartX, self.rotationStartY = GetCursorPosition()
            else
                self:StartMoving()
            end
        end
    end)
    
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            self:StopMovingOrSizing()
            if self.rotating then
                self.rotating = false
            end
        end
    end)
    
    frame:SetScript("OnUpdate", function(self)
        if self.rotating then
            local cursorX, cursorY = GetCursorPosition()
            local diffX = cursorX - self.rotationStartX
            local diffY = cursorY - self.rotationStartY
            local rotationSpeed = 0.01 -- Adjust the rotation speed as needed
            model:SetFacing(model:GetFacing() + (diffX * rotationSpeed))
            self.rotationStartX, self.rotationStartY = cursorX, cursorY
        end
    end)
    
    frame:Show() -- Show the model viewer frame
    fired = true
end


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

local attackFrame, attackInfoText = CreateAttributesFrame("attackFrameAttributes", "Attack Skill Info")
local strengthFrame, strengthInfoText = CreateAttributesFrame("strengthFrameAttributes", "Strength Skill Info")
local defenceFrame, defenceInfoText = CreateAttributesFrame("defenceFrameAttributes", "Defence Skill Info")
local rangedFrame, rangedInfoText = CreateAttributesFrame("rangedFrameAttributes", "Ranged Skill Info")
local magicFrame, magicInfoText = CreateAttributesFrame("magicFrameAttributes", "Magic Skill Info")
local prayerFrame, prayerInfoText = CreateAttributesFrame("prayerFrameAttributes", "Prayer Skill Info")

local runecraftingFrame, runecraftingInfoText = CreateAttributesFrame("runecraftingFrameAttributes", "Runecrafting Skill Info")
 local hitpointsFrame, hitpointsInfoText = CreateAttributesFrame("hitpointsFrameAttributes", "Hitpoints Skill Info")
local agilityFrame, agilityInfoText = CreateAttributesFrame("agilityFrameAttributes", "Agility Skill Info")
local herbloreFrame, herbloreInfoText = CreateAttributesFrame("herbloreFrameAttributes", "Herblore Skill Info")
local thievingFrame, thievingInfoText = CreateAttributesFrame("thievingFrameAttributes", "Thieving Skill Info")
local craftingFrame, craftingInfoText = CreateAttributesFrame("craftingFrameAttributes", "Crafting Skill Info")
local fletchingFrame, fletchingInfoText = CreateAttributesFrame("fletchingFrameAttributes", "Fletching Skill Info")
local slayerFrame, slayerInfoText = CreateAttributesFrame("slayerFrameAttributes", "Slayer Skill Info")
local miningFrame, miningInfoText = CreateAttributesFrame("miningFrameAttributes", "Mining Skill Info")
local smithingFrame, smithingInfoText = CreateAttributesFrame("smithingFrameAttributes", "Smithing Skill Info")
local fishingFrame, fishingInfoText = CreateAttributesFrame("fishingFrameAttributes", "Fishing Skill Info")
local cookingFrame, cookingInfoText = CreateAttributesFrame("cookingFrameAttributes", "Cooking Skill Info")
local firemakingFrame, firemakingInfoText = CreateAttributesFrame("firemakingFrameAttributes", "Firemaking Skill Info")
local woodcuttingFrame, woodcuttingInfoText = CreateAttributesFrame("woodcuttingFrameAttributes", "Woodcutting Skill Info")
local farmingFrame, farmingInfoText = CreateAttributesFrame("farmingFrameAttributes", "Farming Skill Info")
local constructionFrame, constructionInfoText = CreateAttributesFrame("constructionFrameAttributes", "Construction Skill Info")
local hunterFrame, hunterInfoText = CreateAttributesFrame("hunterFrameAttributes", "Hunter Skill Info")




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

createButton("buttonAttributesIncreaseAttack", -70, function() ShowAttackInfo() end)
createButton("buttonAttributesIncreaseStrength", -120, function() ShowStrengthInfo() end)
createButton("buttonAttributesIncreaseDefence", -160, function() ShowDefenceInfo() end)
createButton("buttonAttributesIncreaseMagic", -210, function() ShowMagicInfo() end)
createButton("buttonAttributesIncreaseRange", -250, function() ShowRangedInfo() end)
createButton("buttonAttributesIncreaseHitpoints", -290, function() ShowHitpointsInfo() end)
createButton("buttonAttributesIncreasePrayer", -340, function() ShowPrayerInfo() end)
createButton("buttonAttributesIncreaseWoodcutting", -380, function() ShowWoodcuttingInfo() end)
createButton("buttonAttributesIncreaseFletching", -430, function() ShowFletchingInfo() end)
createButton("buttonAttributesIncreaseFishing", -470, function() ShowFishingInfo() end)
createButton("buttonAttributesIncreaseFiremaking", -510, function() ShowFiremakingInfo() end)


createButton2("buttonAttributesIncreaseCrafting", -70,  function() ShowCraftingInfo() end)
createButton2("buttonAttributesIncreaseSmithing", -120, function() ShowSmithingInfo() end)
createButton2("buttonAttributesIncreaseMining", -160, function() ShowMiningInfo() end)
createButton2("buttonAttributesIncreaseHerblore", -210, function() ShowHerbloreInfo() end)
createButton2("buttonAttributesIncreaseAgility", -250, function() ShowAgilityInfo() end)
createButton2("buttonAttributesIncreaseThieving", -290,  function() ShowThievingInfo() end)
createButton2("buttonAttributesIncreaseSlayer", -340, function() ShowSlayerInfo() end)
createButton2("buttonAttributesIncreaseFarming", -380, function() ShowFarmingInfo() end)
createButton2("buttonAttributesIncreaseRunecrafting", -430, function() ShowRunecraftingInfo() end)
createButton2("buttonAttributesIncreaseHunter", -470, function() ShowHunterInfo() end)
createButton2("buttonAttributesIncreaseConstruction", -510, function() ShowConstructionInfo() end)
 

-- Handle incoming events
function MyHandlers.ShowAttributes()
    frameAttributes:Show()
  
end
-- Attack skill
function ShowAttackInfo()
    attackInfoText:SetText("|cffFFC125Attack Skill Info|r")
    attackFrame:Show()

    -- ShowModelViewer()
end

-- Strength skill
function ShowStrengthInfo()
    strengthInfoText:SetText("|cffFFC125Strength Skill Info|r")
    strengthFrame:Show()

    -- ShowModelViewer()
end

-- Defence skill
function ShowDefenceInfo()
    defenceInfoText:SetText("|cffFFC125Defence Skill Info|r")
    defenceFrame:Show()

    -- ShowModelViewer()
end

-- Ranged skill
function ShowRangedInfo()
    rangedInfoText:SetText("|cffFFC125Ranged Skill Info|r")
    rangedFrame:Show()

    -- ShowModelViewer()
end

function MyHandlers.SetText(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")

    fontAttributesInfo:SetText("|cFF000000" .. text .. "|r")
-- Create the dropdown menu frame
-- Create a frame for the widget
 
end


-- Prayer skill
function ShowPrayerInfo()
    prayerInfoText:SetText("|cffFFC125Prayer Skill Info|r")
    prayerFrame:Show()

    -- ShowModelViewer()
end

-- Magic skill
function ShowMagicInfo()
    magicInfoText:SetText("|cffFFC125Magic Skill Info|r")
    magicFrame:Show()

    -- ShowModelViewer()
end



-- Runecrafting skill
function ShowRunecraftingInfo()
    runecraftingInfoText:SetText("|cffFFC125Runecrafting Skill Info|r")
    runecraftingFrame:Show()

    -- ShowModelViewer()
end

-- Hitpoints skill
function ShowHitpointsInfo()
    hitpointsInfoText:SetText("|cffFFC125Hitpoints Skill Info|r")
    hitpointsFrame:Show()

    -- ShowModelViewer()
end

-- Agility skill
function ShowAgilityInfo()
    agilityInfoText:SetText("|cffFFC125Agility Skill Info|r")
    agilityFrame:Show()

    -- ShowModelViewer()
end

-- Herblore skill
function ShowHerbloreInfo()
    herbloreInfoText:SetText("|cffFFC125Herblore Skill Info|r")
    herbloreFrame:Show()

    -- ShowModelViewer()
end

-- Thieving skill
function ShowThievingInfo()
    thievingInfoText:SetText("|cffFFC125Thieving Skill Info|r")
    thievingFrame:Show()

    -- ShowModelViewer()
end

-- Crafting skill
function ShowCraftingInfo()
    craftingInfoText:SetText("|cffFFC125Crafting Skill Info|r")
    craftingFrame:Show()

    -- ShowModelViewer()
end

-- Fletching skill
function ShowFletchingInfo()
    fletchingInfoText:SetText("|cffFFC125Fletching Skill Info|r")
    fletchingFrame:Show()

    -- ShowModelViewer()
end

-- Slayer skill
function ShowSlayerInfo()
    slayerInfoText:SetText("|cffFFC125Slayer Skill Info|r")
    slayerFrame:Show()

    -- ShowModelViewer()
end

-- Hunter skill
function ShowHunterInfo()
    hunterInfoText:SetText("|cffFFC125Hunter Skill Info|r")
    hunterFrame:Show()

    -- ShowModelViewer()
end

-- Mining skill
function ShowMiningInfo()
    miningInfoText:SetText("|cffFFC125Mining Skill Info|r")
    miningFrame:Show()

    -- ShowModelViewer()
end

-- Smithing skill
function ShowSmithingInfo()
    smithingInfoText:SetText("|cffFFC125Smithing Skill Info|r")
    smithingFrame:Show()

    -- ShowModelViewer()
end

-- Fishing skill
function ShowFishingInfo()
    fishingInfoText:SetText("|cffFFC125Fishing Skill Info|r")
    fishingFrame:Show()

    -- ShowModelViewer()
end

-- Cooking skill
function ShowCookingInfo()
    cookingInfoText:SetText("|cffFFC125Cooking Skill Info|r")
    cookingFrame:Show()

    -- ShowModelViewer()
end

-- Firemaking skill
function ShowFiremakingInfo()
    firemakingInfoText:SetText("|cffFFC125Firemaking Skill Info|r")
    firemakingFrame:Show()

    -- ShowModelViewer()
end

-- Woodcutting skill
function ShowWoodcuttingInfo()
    woodcuttingInfoText:SetText("|cffFFC125Woodcutting Skill Info|r")
    woodcuttingFrame:Show()

    -- ShowModelViewer()
end

-- Farming skill
function ShowFarmingInfo()
    farmingInfoText:SetText("|cffFFC125Farming Skill Info|r")
    farmingFrame:Show()

    -- ShowModelViewer()
end

-- Construction skill
function ShowConstructionInfo()
    constructionInfoText:SetText("|cffFFC125Construction Skill Info|r")
    constructionFrame:Show()

    -- ShowModelViewer()
end 


function MyHandlers.SetText1(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")

    fontAttributesInfo1:SetText("|cFF000000" .. text .. "|r")
-- Create the dropdown menu frame
-- Create a frame for the widget
 
end

function MyHandlers.SetText2(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")

    fontAttributesInfo2:SetText("|cFF000000" .. text .. "|r")
-- Create the dropdown menu frame
-- Create a frame for the widget
 
end

