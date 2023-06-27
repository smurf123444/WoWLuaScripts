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
local fontAttributesInfo = frameAttributes:CreateFontString("fontAttributesInfo")
fontAttributesInfo:SetFont("Fonts\\FRIZQT__.TTF", 15)
fontAttributesInfo:SetSize(300, 400)
fontAttributesInfo:SetPoint("TOPLEFT", -20, -45)

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

-- Call the function to display the 3D model viewer

local buttonAttributesIncreaseAttack = CreateFrame("Button", "buttonAttributesIncreaseAttack", frameAttributes, nil)
buttonAttributesIncreaseAttack:SetSize(20, 20)
buttonAttributesIncreaseAttack:SetPoint("TOPLEFT", 190, -70)
buttonAttributesIncreaseAttack:EnableMouse(true)
buttonAttributesIncreaseAttack:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseAttack:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseAttack:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
buttonAttributesIncreaseAttack:SetScript("OnMouseUp", function() ShowAttackInfo() end)
--buttonAttributesIncreaseAttack:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)
       
local buttonAttributesIncreaseStrength = CreateFrame("Button", "buttonAttributessIncreaseStrength", frameAttributes, nil)
buttonAttributesIncreaseStrength:SetSize(20, 20)
buttonAttributesIncreaseStrength:SetPoint("TOPLEFT", 190, -120)
buttonAttributesIncreaseStrength:EnableMouse(true)
buttonAttributesIncreaseStrength:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseStrength:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseStrength:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseStrength:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseDefence = CreateFrame("Button", "buttonAttributesIncreaseDefence", frameAttributes, nil)
buttonAttributesIncreaseDefence:SetSize(20, 20)
buttonAttributesIncreaseDefence:SetPoint("TOPLEFT", 190, -160)
buttonAttributesIncreaseDefence:EnableMouse(true)
buttonAttributesIncreaseDefence:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseDefence:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseDefence:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseDefence:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseMagic = CreateFrame("Button", "buttonAttributesIncreaseMagic", frameAttributes, nil)
buttonAttributesIncreaseMagic:SetSize(20, 20)
buttonAttributesIncreaseMagic:SetPoint("TOPLEFT", 190, -210)
buttonAttributesIncreaseMagic:EnableMouse(true)
buttonAttributesIncreaseMagic:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseMagic:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseMagic:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseMagic:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseRange = CreateFrame("Button", "buttonAttributesIncreaseRange", frameAttributes, nil)
buttonAttributesIncreaseRange:SetSize(20, 20)
buttonAttributesIncreaseRange:SetPoint("TOPLEFT", 190, -250)
buttonAttributesIncreaseRange:EnableMouse(true)
buttonAttributesIncreaseRange:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseRange:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseRange:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseHitpoints = CreateFrame("Button", "buttonAttributesIncreaseHitpoints", frameAttributes, nil)
buttonAttributesIncreaseHitpoints:SetSize(20, 20)
buttonAttributesIncreaseHitpoints:SetPoint("TOPLEFT", 190, -290)
buttonAttributesIncreaseHitpoints:EnableMouse(true)
buttonAttributesIncreaseHitpoints:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseHitpoints:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseHitpoints:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreasePrayer = CreateFrame("Button", "buttonAttributesIncreasePrayer", frameAttributes, nil)
buttonAttributesIncreasePrayer:SetSize(20, 20)
buttonAttributesIncreasePrayer:SetPoint("TOPLEFT", 190, -340)
buttonAttributesIncreasePrayer:EnableMouse(true)
buttonAttributesIncreasePrayer:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreasePrayer:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreasePrayer:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) end)

local buttonAttributesIncreaseWoodcutting = CreateFrame("Button", "buttonAttributesIncreaseWoodcutting", frameAttributes, nil)
buttonAttributesIncreaseWoodcutting:SetSize(20, 20)
buttonAttributesIncreaseWoodcutting:SetPoint("TOPLEFT", 190, -380)
buttonAttributesIncreaseWoodcutting:EnableMouse(true)
buttonAttributesIncreaseWoodcutting:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
buttonAttributesIncreaseWoodcutting:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
buttonAttributesIncreaseWoodcutting:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) Hitpoints
--buttonAttributesIncreaseRange:SetScript("OnMouseUp", function() AIO.Handle("Kaev", "AttributesIncrease", 1) Hitpoints

-- Handle incoming events
function MyHandlers.ShowAttributes()
    frameAttributes:Show()
  
end
function ShowAttackInfo()
    subFontAttributesTitleText:SetText("|cffFFC125Attack Skill Info|r")
    subFrameAttributes:Show()

     ShowModelViewer()
end


function MyHandlers.SetText(player, text)
    fontAttributesTitleText:SetText("|cffFFC125Skills Summary|r")

    fontAttributesInfo:SetText("|cFF000000" .. text .. "|r")
-- Create the dropdown menu frame
-- Create a frame for the widget
 
end
