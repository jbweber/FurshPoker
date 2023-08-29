local MAX_TABLES = 8 -- maximum number of entries that can be displayed

do
    local entry = CreateFrame("BUtton", "$parentEntry1", Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
    entry:SetID(1)
    entry:SetPoint("TOPLEFT", 4, -28)
    for i = 2, MAX_TABLES do
        local entry = CreateFrame("Button", "$parentEntry" .. i, Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
        entry:SetID(i)
        entry:SetPoint("TOP", "$parentEntry" .. (i - 1), "BOTTOM")
    end
end

--Poker_TableBrowser = {}
Poker_TableBrowser.Tables = {}

function Poker_TableBrowser.Update()
    FauxScrollFrame_Update(
        Poker_TableBrowserTableListScrollFrame,
        #Poker_TableBrowser.Tables,
        MAX_TABLES,
        24,
        "Poker_TableBrowserTableListEntry", 328, 344,
        Poker_TableBrowserTableListHeaderBlinds, 60, 76
    )
    for i = 1, MAX_TABLES do
        local entry = Poker_TableBrowser.Tables[i + Poker_TableBrowserTableListScrollFrame.offset]
        local frame = getglobal("Poker_TableBrowserTableListEntry" .. i)
        if entry then
            frame:Show()
            getglobal(frame:GetName() .. "Name"):SetText(entry[1])
            getglobal(frame:GetName() .. "Host"):SetText(entry[2])
            getglobal(frame:GetName() .. "Players"):SetText(entry[3] .. "/" .. entry[4])
            getglobal(frame:GetName() .. "Blinds"):SetText(entry[5] .. "-" .. entry[6])
            if entry.isSelected then
                getglobal(frame:GetName() .. "BG"):Show()
            else
                getglobal(frame:GetName() .. "BG"):Hide()
            end
        else
            frame:Hide()
        end
    end
end

for i = 1, 2 * MAX_TABLES do
    table.insert(Poker_TableBrowser.Tables, {
        "Test Table" .. i,
        "Host " .. (MAX_TABLES - i),
        i % 3 + 1,
        10,
        i * 10,
        i * 20
    })
end

Poker_TableBrowser.Update()

do
    local currSort = 1
    local currOrder = "asc"

    function Poker_TableBrowser.SortTables(id)
        if currSort == id then
            if currOrder == "desc" then
                currOrder = "asc"
            else
                currOrder = "desc"
            end
        elseif id then
            currSort = id
            currOrder = "asc"
        end
        table.sort(Poker_TableBrowser.Tables, function(v1, v2)
            if currOrder == "desc" then
                return v1[currSort] > v2[currSort]
            else
                return v1[currSort] < v2[currSort]
            end
        end)
        Poker_TableBrowser.Update()
    end
end

do
    local selection = nil
    function Poker_TableBrowser.SelectEntry(id)
        if selection then
            for i = 1, MAX_TABLES do
                getglobal("Poker_TableBrowserTableListEntry" .. i .. "BG"):Hide()
            end
            selection.isSelected = nil
        end
        selection = Poker_TableBrowser.Tables[id + Poker_TableBrowserTableListScrollFrame.offset]
        selection.isSelected = true
    end

    function Poker_TableBrowser.IsSelected(id)
        return Poker_TableBrowser.Tables[id + Poker_TableBrowserTableListScrollFrame.offset] == selection
    end

    function Poker_TableBrowser.JoinSelectedTable()
        if not selection then
            return
        end
        print(string.format("Joining %s's table %s", selection[2], selection[1]))
    end
end

StaticPopupDialogs["POKER_JOIN_TABLE"] = {
    text = POKER_ENTER_NAME_DIALOG,
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = 1,
    maxLetters = 12,
    OnAccept = function(self)
        Poker_TableBrowser.JoinTableByName(self.editBox.GetText())
    end,
    OnShow = function(self)
        if (ChatFrameEditBox:IsShown()) then
            ChatFrameEditBox:SetFocus()
        end
        self.editBox:SetText("")
    end,
    EditBoxOnEnterPressed = function(self)
        Poker_TableBrowser.JoinTableByName(self.GetText())
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
}

function Poker_TableBrowser.ShowEnterNameDialog()
    StaticPopup_Show("POKER_JOIN_TABLE")
end

function Poker_TableBrowser.JoinTableByName(name)
    print(string.format("Trying to join %s's table.", name))
end
