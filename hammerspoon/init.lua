hs.grid.GRIDHEIGHT = 6
hs.grid.GRIDWIDTH = 4
hs.grid.MARGINX = 3
hs.grid.MARGINY = 5

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



