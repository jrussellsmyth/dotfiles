hs.grid.GRIDHEIGHT = 6
hs.grid.GRIDWIDTH = 4
hs.grid.MARGINX = 3
hs.grid.MARGINY = 5
coreLogger = hs.logger.new("core","debug")
local gridset = function(x, y, w, h)
    return function()
        local cur_window = hs.window.focusedWindow()
        if cur_window then
        	hs.grid.set(
            	cur_window,
            	{x=x, y=y, w=w, h=h},
            	cur_window:screen()
        	)
        else
        	hs.alert.show("no selected window")
        end
    end
end

local gridget = function()
	local cur_window = hs.window.focusedWindow()
    if cur_window then
    	return hs.grid.get(
        	cur_window
    	)
    else
    	hs.alert.show("no selected window")
    end
end

local captureCurrentWindowPos = function() 
	last_pos = gridget();
	last_window = hs.window.focusedWindow();
end



-- move size left
hs.hotkey.bind({"cmd","alt", "ctrl"}, "left" ,  function()
	local currCell = gridget();
	if currCell == nil then
	  -- do nothing
	elseif currCell.x == 3 then
		currCell.x = 2
		currCell.w = 2
	elseif currCell.x == 2 then
		currCell.x = 1
		currCell.w = 2
	elseif currCell.x == 1 then
		currCell.x = 0
	elseif currCell.x == 0 then
		currCell.w = 1
	end
		
	gridset(currCell.x, currCell.y, currCell.w, currCell.h)()
	captureCurrentWindowPos();

end)
-- move size right
hs.hotkey.bind({"cmd","alt", "ctrl"}, "right" , function()
	local currCell = gridget();
	if currCell == nil then
	  -- do nothing
	elseif currCell.x == 0 then
		if currCell.w == 1 then
			currCell.w = 2
		else
			currCell.x = 1
		end
	elseif currCell.x == 1 then
		currCell.x = 2
		currCell.w = 2
	elseif currCell.x == 2 then
		currCell.x = 3
		currCell.w = 1
	end
		
	gridset(currCell.x, currCell.y, currCell.w, currCell.h)()
	captureCurrentWindowPos();

end)
-- move size up
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "up",  function()
	local currCell = gridget();
	if currCell == nil then
	  -- do nothing
	elseif currCell.y == 4 then
		currCell.y = 3
		currCell.h = 3
		
	elseif currCell.y > 2 then
		currCell.y = 2
		currCell.h = 4
	elseif currCell.y == 2 then
		currCell.y = 0
		currCell.h = 6
	elseif currCell.y > 0 then
		currCell.y = 0
		currCell.h = 4
	else
		if currCell.h > 4 then
			currCell.y = 0
			currCell.h = 4
		elseif currCell.h == 4 then
			currCell.y = 0
			currCell.h = 3
		else	
			currCell.y = 0
			currCell.h = 2
		end
	end
		
	gridset(currCell.x, currCell.y, currCell.w, currCell.h)()
	captureCurrentWindowPos();

end)
-- move size down
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "down",  function()
	local currCell = gridget();
	if currCell.y == 0 then
		if currCell.h < 3 then
			currCell.h = 3
		elseif currCell.h == 3 then
			currCell.h = 4
		elseif currCell.h == 4 then
			currCell.h = 6
		else
			currCell.y = 2
			currCell.h = 4
		end
	elseif currCell.y == 2 then
		currCell.y = 3
		currCell.h = 3
	else
		currCell.y = 4
		currCell.h = 2
	end	
	gridset(currCell.x, currCell.y, currCell.w, currCell.h)()
	captureCurrentWindowPos();
end)

-- hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
-- 	--hs.alert.show('Focused: ' .. window:title())
-- 	if last_window then
-- 		hs.grid.set(
-- 				last_window,
-- 				last_pos,
-- 				last_window:screen()
-- 		)
-- 	end
-- 	last_pos = gridget();
-- 	last_window = window;
-- 	gridset(1,0,2,6)()
-- end)


local usbWatcher = nil
function usbDeviceCallback(data)
    -- this line will let you know the name of each usb device you connect, useful for the string match below
	coreLogger.f("you just %s productName:%s, vendorName:%s, vendorId:%s, productId:%s", data["eventType"], data["productName"],data["vendorName"], data["vendorId"],data["productId"])
    -- Replace "Yubikey" with the name of the usb device you want to use.
	if (data["eventType"] == "added" and string.find(data["productName"],"USB3.0 Hub") and string.find(data["vendorName"], "VIA Labs, Inc.")) then
		hs.notify.show("HooToo Hub", "Docked!",  "HooToo Hub has been added")
		hooTooAdded()
	end
	if (data["eventType"] == "removed" and string.find(data["productName"],"USB3.0 Hub") and string.find(data["vendorName"], "VIA Labs, Inc.")) then
		hs.notify.show("HooToo Hub", "Un Docked!",  "HooToo Hub has been removed")
		hooTooRemoved()
	end
end

function hooTooAdded() 
	coreLogger.f("hootoo-added")
	-- turn on bluetooth and make sure trackpad is connected
	hs.execute("/usr/local/bin/blueutil --power 1") 
	hs.execute("/usr/local/bin/blueutil --connect 84-38-35-39-11-81") 
end
function hooTooRemoved() 
	coreLogger.f("hootoo-removed")
	-- disconnect trackpad and turn off bluetooth
	hs.execute("/usr/local/bin/blueutil --disconnect 84-38-35-39-11-81 --wait-disconnect 84-38-35-39-11-81")
	hs.execute("/usr/local/bin/blueutil --power 0") 

end

function forceConnectTrackpad() 
	coreLogger.f("bt on")
	hs.execute("/usr/local/bin/blueutil --power 1") 
	hs.execute("/usr/local/bin/blueutil --connect 84-38-35-39-11-81") 
end

function forceDisconnectTrackpad() 
	coreLogger.f("bt off")
	hs.execute("/usr/local/bin/blueutil --disconnect 84-38-35-39-11-81 --wait-disconnect 84-38-35-39-11-81")
	hs.execute("/usr/local/bin/blueutil --power 0") 
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "p", forceConnectTrackpad)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "o", forceDisconnectTrackpad)
-- Start the usb watcher
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
