IsDocked = function()
    return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
        return device.productName == "CalDigit USB-C Pro Audio"
    end)
end

MeetIsRunning = function()
    sourceFile = os.getenv("HOME") .. "/repos-personal/dotfiles/scripts/meetIsOpen.js"
    ran, meetIsOpen, _ = hs.osascript.javascriptFromFile(sourceFile)
    if ran == false then
        return false
    end

    return meetIsOpen
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.alert.show("Hello World!")
    if IsDocked() then
        hs.alert.show("You are docked!")
    end
    if MeetIsRunning() then
        hs.alert.show("Meet is running!")
    end
    hs.spotify.playpause()
end)
