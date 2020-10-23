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
sketch = 'com.bohemiancoding.sketch3'
slack = 'com.tinyspeck.slackmacgap'
spotify = 'com.spotify.client'
sublime = 'com.sublimetext.3'
sublimemerge = 'com.sublimemerge'
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
    sketch = 'com.bohemiancoding.sketch3',
    slack = 'com.tinyspeck.slackmacgap',
    spotify = 'com.spotify.client',
    sublime = 'com.sublimetext.3',
    sublimemerge = 'com.sublimemerge',
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

function openSlackChannel(channel)
    return function()
        hs.urlevent.openURL('slack://channel?' .. slackChannels[channel])
    end
end

function slackReaction(emoji)
    return function()
        hs.eventtap.keyStroke({'cmd', 'shift'}, '\\')
        hs.eventtap.keyStrokes(emoji)
        hs.timer.doAfter(1, function ()
            hs.eventtap.keyStroke({}, 'return')
        end)
    end
end

hyperKeys = {
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
            slack = combo({'cmd'}, 'k'),
            spotify = alfredWorkflow('com.vdesabou.spotify.mini.player', 'spot_mini'),
            sublime = combo({'cmd'}, 'p'),
            sublimemerge = combo({'cmd', 'shift'}, 'o'),
            tableplus = combo({'cmd'}, 'p'),
            trello = keys('b'),
        },
        options = {
            default = combo({'cmd', 'shift', 'option'}, 's'), -- search selections with vimac
            sublime = combo({'cmd', 'shift', 'option'}, ';'),
            chrome = combo({'control', 'shift'}, 's'),
        },
        a = {
            chrome = combo({'cmd', 'shift'}, 'm'), -- profile
            tableplus = combo({'cmd', 'shift'}, 'k'), -- connection
        },
        b = {
            sublime = function()
                hs.eventtap.leftClick({ x=900, y=1000 }) -- focus bottom panel
            end,
            githubDesktop = combo({'cmd'}, 'b'), -- branch
            sublimemerge = combo({'cmd'}, 'b'), -- branch
        },
        c = {
            githubDesktop = combo({'cmd'}, '1'), -- changes
            slack = openSlackChannel('client'),
            trello = combo({}, 'f'), -- card
        },
        e = {
            slack = openSlackChannel('external'),
            tableplus = combo({'cmd'}, 'e'), -- editor
        },
        f = {
            omnifocus = combo({'cmd'}, '5'), -- flagged
            sublime = combo({'cmd'}, 'r'), -- symbol
        },
        g = {
            slack = openSlackChannel('general'),
        },
        r = {
            omnifocus = combo({'cmd'}, '7'), -- routines
            sublime = combo({'cmd', 'ctrl'}, 'o'), -- project / repo
        },
        s = {
            slack = openSlackChannel('internal'),
            sublime = combo({'cmd', 'shift'}, 's'), -- reveal in sidebar
        },
        t = {
            default = combo({'cmd', 'shift', 'option'}, 't'), -- search tabs with witch
            bear = function()
                hs.urlevent.openURL('bear://x-callback-url/open-note?title=' .. os.date('%Y.%m.%d') ..'&show_window=yes&new_window=no') -- open today's work journal
            end,
            chrome = combo({'shift'}, 't'), -- search tabs with vimium
            omnifocus = combo({'cmd'}, '4'), -- forecast
            slack = combo({'cmd', 'shift'}, 't'), -- threads
            sublime = combo({'shift', 'option'}, 'p'), -- tab
        },
        v = {
            githubDesktop = combo({'cmd'}, '2'), -- history
        },
        x = {
            chrome = combo({'cmd', 'option'}, 'j'), -- console
        },
        w = {
            default = combo({'cmd', 'shift', 'option'}, 'w'), -- search windows with witch
            spotify = alfredWorkflow('com.vdesabou.spotify.mini.player', 'lyrics'),
            sublime = combo({'cmd', 'shift'}, 'o'), -- window
        },
    },
    toggle = {
        primary = {
            sublime = combo({'cmd'}, '/'),
        },
        sidebar = {
            sublime = combo({'cmd'}, 'b'),
            sublimemerge = combo({'cmd'}, 'k'),
            finder = combo({'cmd', 'option'}, 's'),
            omnifocus = combo({'cmd', 'option'}, 's'),
            drafts = combo({'cmd'}, '1'),
            notion = combo({'cmd'}, '\\'),
            bear = combo({'control'}, '1'),
            postman = combo({'cmd'}, '\\'),
            mindnode = chain({
                combo({'cmd'}, '6'),
                combo({'cmd'}, '7'),
            }),
            sketch = chain({
                combo({'cmd', 'option'}, '1'),
                combo({'cmd', 'option'}, '2'),
            }),
        },
    },
    make = {
        primary = {
            sublime = combo({'cmd', 'option'}, 'n'),
            finder = combo({'cmd', 'shift'}, 'n'),
            tableplus = combo({'cmd'}, 'i'),
        },
        r = {
            sublimemerge = combo({'cmd', 'shift'}, 'n') -- repo
        },
    },
    navigate = {
        back = {
            bear = combo({'cmd', 'option'}, 'left'),
            spotify = combo({'cmd', 'option'}, 'left'),
            sublime = combo({'control'}, '-'),
            finder = combo({'cmd'}, '['),
            chrome = combo({'cmd'}, '['),
            trello = combo({'cmd'}, '['),
            slack = combo({'cmd'}, '['),
            notion = combo({'cmd'}, '['),
        },
        forward = {
            bear = combo({'cmd', 'option'}, 'right'),
            spotify = combo({'cmd', 'option'}, 'right'),
            sublime = combo({'cmd', 'option'}, 'down'),
            finder =  combo({'cmd'}, ']'),
            chrome = combo({'cmd'}, ']'),
            trello = combo({'cmd'}, ']'),
            slack = combo({'cmd'}, ']'),
            notion = combo({'cmd'}, ']'),
        },
        up = {
            default = combo({'cmd', 'shift'}, ']'),
            tableplus = combo({'cmd'}, ']'),
            dash = combo({'option'}, 'up'),
        },
        down = {
            default = combo({'cmd', 'shift'}, '['),
            tableplus = combo({'cmd'}, '['),
            dash = combo({'option'}, 'down'),
        },
    },
    execute = {
        primary = {
            sublime = combo({'cmd', 'shift'}, 'p'),
            sublimemerge = combo({'cmd', 'shift'}, 'p'),
            default = alfredWorkflow('com.tedwise.menubarsearch', 'menubarsearch'),
        },
        a = {
            sublime = combo({'cmd', 'ctrl'}, 'a'), -- run all tests
        },
        c = {
            sublimemerge = combo({'cmd'}, 'return'), -- commit
        },
        f = {
            sublime = combo({'cmd', 'ctrl'}, 'f'), -- test current file
            sublimemerge = combo({'cmd', 'option'}, 'down'), -- pull
        },
        g = {
            slack = slackReaction(':thumbsup:'),
        },
        r = {
            sublime = combo({'cmd', 'ctrl'}, 'p'), -- rerun last test
            postman = combo({'cmd'}, 'return'), -- send request
        },
        s = {
            slack = slackReaction(':smile:'),
            sublimemerge = chain({
                combo({'cmd', 'option'}, 'up'), -- push
                combo({}, 'return'),
            }),
        },
        t = {
            slack = slackReaction(':tada:'),
            sublime = combo({'cmd', 'ctrl'}, 't'), -- test current method
        },
        w = {
            slack = slackReaction(':wave:'),
        },
    },
    append = {
        comma = {
            sublime = combo({'cmd', 'option'}, ','), -- append comma
        },
        semicolon = {
            sublime = combo({'cmd'}, ';'), -- append semicolon
        },
    },
    insert = {
        a = {
            sublime = keys('->'),
        },
        c = {
            chrome = combo({'ctrl', 'option', 'cmd'}, 'p'), -- credentials
            sublime = combo({}, 'f2'), -- constructor
            trello = keys('-'), -- checklist
        },
        d = {
            sublime = combo({}, 'f3'), -- import dependency
            trello = chain({
                -- edit description
                keys('e'),
                combo({}, 'right'),
            }),
        },
        e = {
            sublime = combo({}, 'f4'), -- expand fully qualified name
        },
        f = {
            sublime = chain({
                keys('closure'),
                combo({}, 'tab'),
            }),
        },
        g = {
            slack = keys(':thumbsup:'),
        },
        s = {
            slack = keys(':smile:'),
            sublime = combo({}, 'f1') -- import namespace
        },
        t = {
            slack = keys(':tada:'),
        },
        w = {
            slack = keys(':wave:'),
        },
        x = {
            sublime = combo({'cmd', 'shift', 'option'}, 'x') -- debug
        },
    },
    common = {
        save = {
            default = combo({'cmd'}, 's'),
            trello = combo({'cmd'}, 'return'), -- description
            sublimemerge = combo({'cmd', 'shift', 'option', 'ctrl'}, 's'), -- push
            sublime = chain({
                combo({'cmd'}, 's'),
                combo({}, 'escape'),
            }),
        },
        duplicate = {
            sublime = combo({'cmd', 'shift'}, 'd'),
            tableplus = combo({'cmd'}, 'd'),
        },
        refresh = {
            omnifocus = combo({'cmd'}, 'k'),
            default = combo({'cmd'}, 'r'),
        },
        delete = {
            sublime = combo({'cmd', 'option'}, 'delete'),
            iterm = combo({'control'}, 'c'),
            finder = combo({'cmd'}, 'delete'),
            chrome = combo({'cmd'}, 'w'),
        },
    },
    relocate = {
        down = {
            bear = combo({'cmd', 'option'}, 'down'),
            sublime = combo({'cmd', 'control'}, 'down'),
        },
        up = {
            bear = combo({'cmd', 'option'}, 'up'),
            sublime = combo({'cmd', 'control'}, 'up'),
        },
    },
}

hs.urlevent.bind('navigateForward', function()
    -- @todo
    if focusedWindowIs(fantastical) then
        hs.eventtap.keyStroke({}, 'right')
    end
end)

hs.urlevent.bind('navigateBack', function()
    -- @todo
    if focusedWindowIs(fantastical) then
        hs.eventtap.keyStroke({}, 'left')
    end
end)

hs.urlevent.bind('hyper', function(_, params)
    command = hyperKeys[params.method][params.target][frontApp()]
    if (command == nil) then
        command = hyperKeys[params.method][params.target]['default']
    end

    if (command ~= nil) then
        command()
    end
end)

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
    hs.grid.set(hs.window.focusedWindow(), windowPositions[params.key])
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

hs.urlevent.bind('toggle', function(listener, params)
    if (params.key == 'd') then
        hs.grid.set(hs.window.focusedWindow(), windowPositions.full)
        hs.window.focusedWindow():moveToScreen(hs.screen.mainScreen():next())
    end
end)
