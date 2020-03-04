bear = 'net.shinyfrog.bear'
chrome = 'com.google.Chrome'
discord = 'com.hnc.Discord'
drafts = 'com.agiletortoise.Drafts-OSX'
fantastical = 'com.flexibits.fantastical'
finder = 'com.apple.finder'
githubDesktop = 'com.github.GitHubClient'
iterm = 'com.googlecode.iterm2'
notion = 'notion.id'
omnifocus = 'com.omnigroup.OmniFocus3.MacAppStore'
preview = 'com.apple.Preview'
slack = 'com.tinyspeck.slackmacgap'
spotify = 'com.spotify.client'
sublime = 'com.sublimetext.3'
tableplus = 'com.tinyapp.TablePlus'
trello = 'com.fluidapp.FluidApp.Trello'
vscode = 'com.microsoft.VSCode'

gokuWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/karabiner.edn/', function ()
    output = hs.execute('/usr/local/bin/goku')
    hs.notify.new({title = 'Karabiner Config', informativeText = output}):send()
end):start()

hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()
hs.notify.new({title = 'Hammerspoon', informativeText = 'Config loaded'}):send()

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function appIs(bundle)
    return hs.application.frontmostApplication():bundleID() == bundle
end

function appIncludes(bundles)
    return has_value(bundles, hs.application.frontmostApplication():bundleID())
end

function focusedWindowIs(bundle)
    return hs.window:focusedWindow():application():bundleID() == bundle
end

function getSelectedText(copying)
    original = hs.pasteboard.getContents()
    hs.pasteboard.clearContents()
    hs.eventtap.keyStroke({'cmd'}, 'C')
    text = hs.pasteboard.getContents()
    finderFileSelected = false
    for k,v in pairs(hs.pasteboard.contentTypes()) do
        if v == 'public.file-url' then
            finderFileSelected = true
        end
    end

    if not copying and finderFileSelected then
        text = 'finderFileSelected'
    end

    if not copying then
        hs.pasteboard.setContents(original)
    end

    return text
end

function triggerAlfredSearch(search)
    hs.osascript.applescript('tell application id "com.runningwithcrayons.Alfred" to search "' .. search ..' "')
end

function triggerAlfredWorkflow(workflow, trigger)
    hs.osascript.applescript('tell application id "com.runningwithcrayons.Alfred" to run trigger "' .. trigger .. '" in workflow "' .. workflow .. '"')
end

wf = hs.window.filter
allwindows = wf.new(nil)
allwindows:subscribe(wf.windowDestroyed, function (window, appName, reason)
    app = hs.application.frontmostApplication()
    count = 0
    for k,v in pairs(app:visibleWindows()) do
        if (appIs(preview) or appIs(finder)) and v:title() == '' then
        else
            count = count + 1
        end
    end
    if count < 1 then
        if appIs(preview) then
            app:kill()
        else
            app:hide()
        end
    end
end)
hs.urlevent.bind('closeWindow', function()
    hs.eventtap.keyStroke({'cmd'}, 'W')
    if appIs(chrome) then
        hs.timer.doAfter(1, function()
            app = hs.application.frontmostApplication()
            if next(app:visibleWindows()) == nil then
                app:hide()
            end
        end)
    end
end)

hs.urlevent.bind('openAnything', function()
    if appIncludes({notion, sublime, tableplus}) then
        hs.eventtap.keyStroke({'cmd'}, 'p')
    elseif appIs(finder) then
        triggerAlfredSearch('o')
    elseif appIncludes({discord, slack}) then
        hs.eventtap.keyStroke({'cmd'}, 'k')
    elseif appIs(omnifocus) then
        hs.eventtap.keyStroke({'cmd'}, 'o')
    elseif appIs({trello}) then
        hs.eventtap.keyStrokes('b')
    elseif appIs(spotify) then
        triggerAlfredWorkflow('com.vdesabou.spotify.mini.player', 'spot_mini')
    elseif appIs(chrome) then
        triggerAlfredSearch('bm')
    elseif appIs(bear) then
        triggerAlfredWorkflow('com.drgrib.bear', 'bear_search')
    elseif appIs(githubDesktop) then
        hs.eventtap.keyStroke({'cmd'}, 't')
    end
end)

hs.urlevent.bind('toggleSidebar', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd'}, 'b')
    elseif appIncludes({finder, omnifocus}) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 's')
    elseif appIs(drafts) then
        hs.eventtap.keyStroke({'cmd'}, '1')
    elseif appIs(notion) then
        hs.eventtap.keyStroke({'cmd'}, '\\')
    elseif appIs(bear) then
        hs.eventtap.keyStroke({'control'}, '1')
    end
end)

hs.urlevent.bind('navigateBack', function()
    if focusedWindowIs(fantastical) then
        hs.eventtap.keyStroke({}, 'left')
    elseif appIncludes({bear, spotify}) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'left')
    elseif appIs(sublime) then
        hs.eventtap.keyStroke({'control'}, '-')
    elseif appIncludes({finder, chrome, trello, slack, notion}) then
        hs.eventtap.keyStroke({'cmd'}, '[')
    end
end)

hs.urlevent.bind('navigateForward', function()
    if focusedWindowIs(fantastical) then
        hs.eventtap.keyStroke({}, 'right')
    elseif appIncludes({bear, spotify}) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'right')
    elseif appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'down')
    elseif appIncludes({finder, chrome, trello, slack, notion}) then
        hs.eventtap.keyStroke({'cmd'}, ']')
    end
end)

hs.urlevent.bind('goToPreviousTab', function()
    if appIs(tableplus) then
        hs.eventtap.keyStroke({'cmd'}, '[')
    else
        hs.eventtap.keyStroke({'cmd', 'shift'}, '[')
    end
end)

hs.urlevent.bind('goToNextTab', function()
    if appIs(tableplus) then
        hs.eventtap.keyStroke({'cmd'}, ']')
    else
        hs.eventtap.keyStroke({'cmd', 'shift'}, ']')
    end
end)

hs.urlevent.bind('openCommandPalette', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'shift'}, 'p')
    else
        triggerAlfredWorkflow('com.tedwise.menubarsearch', 'menubarsearch')
    end
end)

hs.urlevent.bind('copyAnything', function()
    text = getSelectedText(true)
    if text then
        -- Already in clipboard, do not reset
    elseif appIs(spotify) then
        hs.osascript.applescript([[
            tell application "Spotify"
                set theTrack to name of the current track
                set theArtist to artist of the current track
                set theAlbum to album of the current track
                set track_id to id of current track
            end tell
            set AppleScript's text item delimiters to ":"
            set track_id to third text item of track_id
            set AppleScript's text item delimiters to {""}
            set realurl to ("https://open.spotify.com/track/" & track_id)
            set theString to theTrack & " by " & theArtist & ": " & realurl
            set the clipboard to theString
        ]])
    elseif appIs(bear) then
        hs.eventtap.keyStroke({'cmd', 'option', 'shift'}, 'l')
    elseif appIs(chrome) then
        hs.eventtap.keyStrokes('yy')
    elseif appIs(vscode) then
        hs.eventtap.keyStroke({'cmd', 'option', 'control'}, 'y')
    end
end)