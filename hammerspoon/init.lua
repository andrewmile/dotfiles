hs.loadSpoon('Private')
hs.loadSpoon('ModalMgr')

mode = 'normal'

activitymonitor = 'com.apple.ActivityMonitor'
bear = 'net.shinyfrog.bear'
chrome = 'com.google.Chrome'
dash = 'com.kapeli.dashdoc'
discord = 'com.hnc.Discord'
drafts = 'com.agiletortoise.Drafts-OSX'
fantastical = 'com.flexibits.fantastical'
finder = 'com.apple.finder'
githubDesktop = 'com.github.GitHubClient'
iterm = 'com.googlecode.iterm2'
keynote = 'com.apple.iWork.Keynote'
messages = 'com.apple.iChat'
mindnode = 'com.ideasoncanvas.mindnode.macos'
notion = 'notion.id'
omnifocus = 'com.omnigroup.OmniFocus3.MacAppStore'
preview = 'com.apple.Preview'
postman = 'com.postmanlabs.mac'
slack = 'com.tinyspeck.slackmacgap'
spotify = 'com.spotify.client'
sublime = 'com.sublimetext.3'
systempreferences = 'com.apple.systempreferences'
tableplus = 'com.tinyapp.TablePlus'
trello = 'com.fluidapp.FluidApp2.Trello'
vscode = 'com.microsoft.VSCode'

apps = {
    activitymonitor = 'com.apple.ActivityMonitor',
    bear = 'net.shinyfrog.bear',
    chrome = 'com.google.Chrome',
    dash = 'com.kapeli.dashdoc',
    discord = 'com.hnc.Discord',
    drafts = 'com.agiletortoise.Drafts-OSX',
    fantastical = 'com.flexibits.fantastical',
    finder = 'com.apple.finder',
    githubDesktop = 'com.github.GitHubClient',
    iterm = 'com.googlecode.iterm2',
    keynote = 'com.apple.iWork.Keynote',
    messages = 'com.apple.iChat',
    mindnode = 'com.ideasoncanvas.mindnode.macos',
    notion = 'notion.id',
    omnifocus = 'com.omnigroup.OmniFocus3.MacAppStore',
    preview = 'com.apple.Preview',
    postman = 'com.postmanlabs.mac',
    slack = 'com.tinyspeck.slackmacgap',
    spotify = 'com.spotify.client',
    sublime = 'com.sublimetext.3',
    systempreferences = 'com.apple.systempreferences',
    tableplus = 'com.tinyapp.TablePlus',
    trello = 'com.fluidapp.FluidApp2.Trello',
    vscode = 'com.microsoft.VSCode',
}

gokuWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/karabiner.edn/', function ()
    output = hs.execute('/usr/local/bin/goku')
    hs.notify.new({title = 'Karabiner Config', informativeText = output}):send()
end):start()

hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()
hs.notify.new({title = 'Hammerspoon', informativeText = 'Config loaded'}):send()

-- When the input device changes reconnect the Yeti
hs.audiodevice.watcher.setCallback(function(event)
    if (event == 'dIn ') then
        yeti = hs.audiodevice.findInputByName('Yeti Stereo Microphone')
        if (yeti and yeti:name() ~= hs.audiodevice.defaultInputDevice():name()) then
            yeti:setDefaultInputDevice()
            hs.notify.new({title = 'Input Connected', informativeText = yeti:name()}):send()
        end
    end
end)
hs.audiodevice.watcher.start()

local function matches_project_file(path, patterns)
    for projectKey, project in pairs(projects) do
        for patternKey, pattern in pairs(patterns) do
            if string.match(path, project .. pattern) then
                return true
            end
        end
    end

    return false
end

local function is_newly_created_file(flag)
    return flag.itemIsFile and flag.itemCreated and not flag.itemRemoved and not flag.itemRenamed
end

openFileWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/Code', function (paths, flagTables)
    patterns = {
        "/app/%a+.php",
        "/app/Http/Controllers/%a+.php",
        "/database/factories/%a+.php",
        "/tests/.+%a+.php",
    }

    for pathKey, path in pairs(paths) do
        if (is_newly_created_file(flagTables[pathKey]) and matches_project_file(path, patterns)) then
            hs.execute('/usr/local/bin/subl ' .. path)
            return;
        end
    end

end):start()

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function invertTable(source)
    local inverted = {}
    for key, value in pairs(source) do
        inverted[value] = key
    end
    return inverted
end

function frontApp()
    return invertTable(apps)[hs.application.frontmostApplication():bundleID()]
end

function appIs(bundle)
    return hs.application.frontmostApplication():bundleID() == bundle
end

function appIncludes(bundles)
    return has_value(bundles, hs.application.frontmostApplication():bundleID())
end

function focusedWindowIs(bundle)
    return hs.window.focusedWindow():application():bundleID() == bundle
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

function combo(modifiers, key)
    return function()
        hs.eventtap.keyStroke(modifiers, key)
    end
end

function keys(keys)
    return function()
        hs.eventtap.keyStrokes(keys)
    end
end

function alfredWorkflow(workflow, trigger)
    return function()
        triggerAlfredWorkflow(workflow, trigger)
    end
end

function alfredSearch(keys)
    return function()
        triggerAlfredSearch(keys)
    end
end

function chain(commands)
    return function ()
        for _, command in pairs(commands) do
            command()
        end
    end
end

open = {
    primary = {
        bear = alfredWorkflow('com.drgrib.bear', 'search bear'),
        chrome = alfredSearch('bm'),
        dash = combo({'cmd'}, 'f'),
        discord = combo({'cmd'}, 'k'),
        drafts = combo({'cmd', 'shift'}, 'f'),
        finder = alfredSearch('o'),
        notion = combo({'cmd'}, 'p'),
        omnifocus = combo({'cmd'}, 'o'),
        githubDesktop = combo({'cmd'}, 't'),
        slack = chain({
            combo({'cmd'}, 'k'),
            combo({}, 'down'),
        }),
        spotify = alfredWorkflow('com.vdesabou.spotify.mini.player', 'spot_mini'),
        sublime = combo({'cmd'}, 'p'),
        tableplus = combo({'cmd'}, 'p'),
        trello = keys('b'),
    }
}

hs.urlevent.bind('openAnything', function()
    open.primary[frontApp()]()
end)

hs.urlevent.bind('reloadAnything', function()
    if appIs(omnifocus) then
        hs.eventtap.keyStroke({'cmd'}, 'k')
    else
        hs.eventtap.keyStroke({'cmd'}, 'r')
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
    elseif appIs(postman) then
        hs.eventtap.keyStroke({'cmd'}, '\\')
    elseif appIs(mindnode) then
        hs.eventtap.keyStroke({'cmd'}, '6')
        hs.eventtap.keyStroke({'cmd'}, '7')
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
    elseif appIs(dash) then
        hs.eventtap.keyStroke({'option'}, 'down')
    else
        hs.eventtap.keyStroke({'cmd', 'shift'}, '[')
    end
end)

hs.urlevent.bind('goToNextTab', function()
    if appIs(tableplus) then
        hs.eventtap.keyStroke({'cmd'}, ']')
    elseif appIs(dash) then
        hs.eventtap.keyStroke({'option'}, 'up')
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

hs.urlevent.bind('runCommand', function(listener, params)
    if appIs(sublime) then
        runCommandInSublime(params.key)
    elseif appIs(slack) then
        addEmojiReactionToLastMessage(params.key)
    elseif appIs(postman) then
        if (params.key == 'r') then
            -- send requeest
            hs.eventtap.keyStroke({'cmd'}, 'return')
        end
    end
end)

function runCommandInSublime(key)
    if (key == 'a') then
        hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'a') -- run all tests
    elseif (key == 'f') then
        hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'f') -- test current file
    elseif (key == 'r') then
        hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'p') -- rerun last test
    elseif (key == 't') then
        hs.eventtap.keyStroke({'cmd', 'ctrl'}, 't') -- test current method
    end
end

function addEmojiReactionToLastMessage(key)
    emoji = mapKeyToEmoji(key)

    hs.eventtap.keyStroke({'cmd', 'shift'}, '\\')
    hs.eventtap.keyStrokes(emoji)
    hs.timer.doAfter(1, function ()
        hs.eventtap.keyStroke({}, 'return')
    end)
end

function mapKeyToEmoji(key)
    if (key == 'g') then
        return ':thumbsup:'
    elseif (key == 's') then
        return ':smile:'
    elseif (key == 't') then
        return ':tada:'
    elseif (key == 'w') then
        return ':wave:'
    end
end

hs.urlevent.bind('copyMode', function(listener, params)
    if appIs(chrome) then
        isSuccess, pageTitle = hs.osascript.javascript([[
            Application('Google Chrome').windows[0].activeTab.name()
        ]])
        isSuccess, pageUrl = hs.osascript.javascript([[
            Application('Google Chrome').windows[0].activeTab.url()
        ]])
        hs.pasteboard.setContents('[' .. pageTitle .. '](' .. pageUrl .. ')')
    end
end)

hs.urlevent.bind('appendAnything', function(listener, params)
    if (appIs(sublime)) then
        if (params.key == 'comma') then
            -- append comma
            hs.eventtap.keyStroke({'cmd', 'option'}, ',')
        elseif (params.key == 'semicolon') then
            -- append semicolon
            hs.eventtap.keyStroke({'cmd'}, ';')
        end
    end
end)

hs.urlevent.bind('insertAnything', function(listener, params)
    if appIs(chrome) then
        if (params.key == 'c') then
            -- insert credentials
            hs.eventtap.keyStroke({'ctrl', 'option', 'cmd'}, 'p')
        end
    elseif appIs(slack) then
        emoji = mapKeyToEmoji(params.key)
        hs.eventtap.keyStrokes(emoji)
    elseif (appIs(sublime)) then
        if (params.key == 'a') then
            hs.eventtap.keyStrokes('->')
        elseif (params.key == 'c') then
            -- insert constructor
            hs.eventtap.keyStroke({}, 'f2')
        elseif (params.key == 'd') then
            -- import dependency
            hs.eventtap.keyStroke({}, 'f3')
        elseif (params.key == 'e') then
            -- expand fully qualified name
            hs.eventtap.keyStroke({}, 'f4')
        elseif (params.key == 'f') then
            -- insert function
            hs.eventtap.keyStrokes('closure')
            hs.eventtap.keyStroke({}, 'tab')
        elseif (params.key == 's') then
            -- import namespace
            hs.eventtap.keyStroke({}, 'f1')
        elseif (params.key == 'x') then
            -- insert debug
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'x')
        end
    elseif (appIs(trello)) then
        if (params.key == 'd') then
            -- edit description
            hs.eventtap.keyStrokes('e')
            hs.eventtap.keyStroke({}, 'right')
        elseif (params.key == 'c') then
            -- insert checklist
            hs.eventtap.keyStrokes('-')
        end
    end
end)

hs.urlevent.bind('openSomething', function(listener, params)
    if (appIs(bear)) then
        if (params.key == 't') then
            hs.execute('open -g bear://x-callback-url/open-note?title=' .. os.date('%Y.%m.%d') ..'&show_window=yes&new_window=no')
        end
    elseif (appIs(chrome)) then
        if (params.key == 'a') then
            hs.eventtap.keyStroke({'cmd', 'shift'}, 'm')
        elseif (params.key == 't') then
            hs.eventtap.keyStroke({'shift'}, 't')
        elseif (params.key == 'x') then
            hs.eventtap.keyStroke({'cmd', 'option'}, 'j')
        else
            -- search windows with witch
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'w')
        end
    elseif (appIs(slack)) then
        if (params.key == 'g') then
            -- open general
            hs.eventtap.keyStroke({'cmd'}, 'k')
            hs.eventtap.keyStrokes('general')
            hs.timer.doAfter(.2, function()
                hs.eventtap.keyStroke({}, 'return')
            end)
        end
    elseif (appIs(omnifocus)) then
        if (params.key == 'f') then
            -- open flagged
            hs.eventtap.keyStroke({'cmd'}, '5')
        elseif (params.key == 'r') then
            -- open routines
            hs.eventtap.keyStroke({'cmd'}, '7')
        elseif (params.key == 't') then
            -- open forecast
            hs.eventtap.keyStroke({'cmd'}, '4')
        end
    elseif (appIs(githubDesktop)) then
        if (params.key == 'b') then
            -- open branch
            hs.eventtap.keyStroke({'cmd'}, 'b')
        elseif (params.key == 'c') then
            -- show changes
            hs.eventtap.keyStroke({'cmd'}, '1')
        elseif (params.key == 'v') then
            -- show history
            hs.eventtap.keyStroke({'cmd'}, '2')
        end
    elseif (appIs(sublime)) then
        if (params.key == 'b') then
            hs.eventtap.leftClick({ x=900, y=1000 }) -- focus bottom panel
        elseif (params.key == 'f') then
            hs.eventtap.keyStroke({'cmd'}, 'r')
        elseif (params.key == 'r') then
            -- open project
            hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'o')
        elseif (params.key == 's') then
            -- reveal in sidebar
            hs.eventtap.keyStroke({'cmd', 'shift'}, 's')
        elseif (params.key == 't') then
            -- open tab
            hs.eventtap.keyStroke({'shift', 'option'}, 'p')
        elseif (params.key == 'w') then
            -- open window
            hs.eventtap.keyStroke({'cmd', 'shift'}, 'o')
        end
    elseif (appIs(tableplus)) then
        if (params.key == 'a') then
            hs.eventtap.keyStroke({'cmd', 'shift'}, 'k')
        elseif (params.key == 'e') then
            -- open editor
            hs.eventtap.keyStroke({'cmd'}, 'e')
        end
    elseif (appIs(trello)) then
        if (params.key == 'c') then
            -- open card
            hs.eventtap.keyStroke({}, 'f')
        end
    else
        if (params.key == 't)') then
            -- search tabs with witch
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 't')
        elseif (params.key == 'w') then
            -- search windows with witch
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'w')
        end
    end
end)

hs.urlevent.bind('saveAnything', function()
    if appIs(trello) then
        hs.eventtap.keyStroke({'cmd'}, 'return')
    else
        hs.eventtap.keyStroke({'cmd'}, 's')
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

hs.urlevent.bind('makeAnything', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'n')
    elseif appIs(finder) then
        hs.eventtap.keyStroke({'cmd', 'shift'}, 'n')
    elseif appIs(tableplus) then
        hs.eventtap.keyStroke({'cmd'}, 'i')
    end
end)

hs.urlevent.bind('duplicateAnything', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'shift'}, 'd')
    elseif appIs(tableplus) then
        hs.eventtap.keyStroke({'cmd'}, 'd')
    end
end)

hs.urlevent.bind('relocateDown', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'control'}, 'down')
    elseif appIs(bear) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'down')
    end
end)

hs.urlevent.bind('relocateUp', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'control'}, 'up')
    elseif appIs(bear) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'up')
    end
end)

hs.urlevent.bind('openMode', function(listener, params)
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, ';')
    elseif appIs(chrome) then
        hs.eventtap.keyStroke({'control', 'shift'}, 's')
    else
        -- search selections with vimac
        hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 's')
    end
end)

hs.urlevent.bind('togglePrimary', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd'}, '/')
    end
end)

hs.urlevent.bind('changeSomething', function(listener, params)
    if appIs(sublime) then
        if (params.key == 'k') then
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'k')
        elseif (params.key == 'l') then
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'l')
        elseif (params.key == 'u') then
            hs.eventtap.keyStroke({'cmd', 'shift', 'option'}, 'u')
        end
    end
end)

hs.urlevent.bind('deleteAnything', function()
    if appIs(sublime) then
        hs.eventtap.keyStroke({'cmd', 'option'}, 'delete')
    elseif appIs(iterm) then
        hs.eventtap.keyStroke({'control'}, 'c')
    elseif appIs(finder) then
        hs.eventtap.keyStroke({'cmd'}, 'delete')
    elseif appIs(chrome) then
        hs.eventtap.keyStroke({'cmd'}, 'w')
    end
end)

hs.urlevent.bind('debugSomething', function(listener, params)
    if appIs(chrome) then
        if (params.key == 'j') then
            hs.eventtap.keyStroke({'cmd'}, '[')
        elseif (params.key == 'k') then
            hs.eventtap.keyStroke({'cmd'}, ']')
        end
    end
end)

hs.grid.setGrid('10x4')
hs.grid.setMargins({x=0, y=0})
hs.window.animationDuration = 0

windowPositions = {
  full = '0,0 10x4',
  left = '0,0 5x4',
  right = '5,0 5x4',
  top = '0,0 10x2',
  bottom = '0,2 10x2',
  center = '2,0 6x4',
  topLeft = '0,0 5x2',
  topRight = '5,0 5x2',
  bottomLeft = '0,2 5x2',
  bottomRight = '5,2 5x2',
}

hs.urlevent.bind('moveWindow', function(listener, params)
    if (params.key == 'display') then
        hs.grid.set(hs.window.focusedWindow(), windowPositions.full)
        hs.window.focusedWindow():moveToScreen(hs.screen.mainScreen():next())
    else
        hs.grid.set(hs.window.focusedWindow(), windowPositions[params.key])
    end
end)

local modeMenuBar = hs.menubar.new():setTitle('Normal');

spoon.ModalMgr:new('app')
local modal = spoon.ModalMgr.modal_list['app']
modal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({'app'}) end)

local modeText = hs.styledtext.new('App', {
    color = {hex = '#FFFFFF', alpha = 1},
    backgroundColor = {hex = '#0000FF', alpha = 1},
})
modal.entered = function()
  mode = 'app'
    modeMenuBar:setTitle(modeText)
end
modal.exited = function()
  mode = 'normal'
  modeMenuBar:setTitle('Normal')
end


hsapp_list = {
    {key = 'a', app = activitymonitor},
    {key = 'k', app = keynote},
    {key = 'm', app = messages},
    {key = 'n', app = notion},
    {key = 'p', app = postman},
    {key = 's', app = systempreferences},
}

for _, v in ipairs(hsapp_list) do
    local located_name = hs.application.nameForBundleID(v.app)
    if located_name then
        modal:bind('', v.key, located_name, function()
            hs.application.launchOrFocusByBundleID(v.app)
            spoon.ModalMgr:deactivate({'app'})
        end)
    end
end

hs.urlevent.bind('appMode', function()
    spoon.ModalMgr:deactivateAll()
    spoon.ModalMgr:activate({'app'}, '#0000FF', false)
end)
