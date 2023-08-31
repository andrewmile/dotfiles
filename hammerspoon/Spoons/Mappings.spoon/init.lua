local obj = {}
obj.__index = obj

hs.loadSpoon('Hyper')
hs.loadSpoon('Helpers')
hs.loadSpoon('Apps')

local modeMenuBar = hs.menubar.new():setTitle('Normal');

hyper:app(anybox)
    :action('open', {
        default = combo({'cmd'}, 'p'),
        a = function()
                hs.urlevent.openURL('anybox://show?id=all')
            end,
        g = function()
                hs.urlevent.openURL('anybox://show?id=inbox')
            end,
        t = function()
                hs.urlevent.openURL('anybox://show?id=today')
            end,
    })
    :action('toggle', {
        sidebar = combo({'control', 'cmd'}, 's'),
    })

hyper:app(bear)
    :action('open', {
        default = alfredWorkflow('com.drgrib.bear', 'search bear'),
        t = function()
                hs.urlevent.openURL('bear://x-callback-url/open-note?title=' .. os.date('%Y.%m.%d') ..'&show_window=yes&new_window=no') -- open today's work journal
            end,
    })
    :action('toggle', {
        sidebar = combo({'control'}, '1'),
    })
    :action('navigate', {
        back = combo({'cmd', 'option'}, 'left'),
        forward = combo({'cmd', 'option'}, 'right'),
    })
    :action('relocate', {
        down = combo({'cmd', 'option'}, 'down'),
        up = combo({'cmd', 'option'}, 'up'),
    })
    :action('copy', {
        default = copy(combo({'cmd', 'option', 'shift'}, 'l')),
    })

hyper:app(chrome)
    :action('open', {
        default = combo({'cmd', 'ctrl', 'option'}, 'o'), -- anybox quick find
        options = combo({'control', 'shift'}, 's'),
        a = combo({'cmd', 'shift'}, 'm'), -- profile
        b = launch(anybox),
        e = combo({'cmd', 'shift'}, 'c'), -- select element
        t = combo({'shift'}, 't'), -- search tabs with vimium
        x = combo({'cmd', 'option'}, 'j'), -- console
    })
    :action('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :action('insert', {
        c = combo({'ctrl', 'option', 'cmd'}, 'p'), -- credentials
    })
    :action('general', {
        delete = combo({'cmd'}, 'w'),
        save = combo({'cmd', 'ctrl', 'option'}, 's'), -- anybox quick save
    })
    :action('execute', {
        c = combo({'cmd'}, 's'), -- add to anybox collection
    })
    :action('debug', {
        j = combo({'cmd'}, '['), -- sources tabe
        k = combo({'cmd'}, ']'), -- network tab
    })
    :action('copy', {
        default = copy(keys('yy')),
        d = copyChromeUrlAsMarkdown(),
    })
    :action('find', {
        z = combo({'cmd', 'ctrl', 'shift'}, 'z'), -- amazon
    })

hyper:app(arc)
    :action('open', {
        default = function()
            success, space = hs.osascript.applescript([[
                tell application "Arc"
                    return title of active space of front window
                end tell
            ]])
            hs.urlevent.openURL('anybox://quick-find?filter=' .. space)


            escapeWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
                if (event:getKeyCode() == 53) then -- escape
                    closeQuickOpen()
                end
            end)

            escapeWatcher:start()

            function closeQuickOpen()
                escapeWatcher:stop()
                hs.eventtap.keyStroke({}, 'escape')
                hs.application.launchOrFocusByBundleID(arc)
            end
        end,
        options = combo({'control', 'shift'}, 's'),
        a = openArcSpace('admin'),
        b = launch(anybox),
        c = openArcSpace('client'),
        e = combo({'cmd', 'shift'}, 'c'), -- select element
        f = openArcSpace('play'),
        g = combo({'cmd'}, '1'),
        r = function()
            choices = {}
            success, spaces = hs.osascript.applescript([[
                tell application "Arc"
                    return title of every space of front window
                end tell
            ]])
            for _, space in pairs(spaces) do
                if space == "" then goto continue end
                table.insert(choices, {
                    ["text"] = space,
                })
                ::continue::
            end

            table.sort(choices, function(a, b) return a["text"] < b["text"] end)

            hs.chooser.new(function(choice)
                if (choice) then
                    openArcBrowserSpace(choice.text)
                end
            end):choices(choices):rows(4):width(30):show()
        end,
        t = alfredWorkflow('com.hellovietduc.alfred.arc-control', 'open tab'),
        w = openArcSpace('work'),
        x = combo({'cmd', 'option'}, 'j'), -- console
    })
    :action('navigate', {
        up = combo({'cmd', 'shift'}, '['),
        down = combo({'cmd', 'shift'}, ']'),
        back = combo({'cmd'}, '['),
        -- back = combo({'cmd', 'option'}, 'up'),
        forward = combo({'cmd'}, ']'),
    })
    :action('insert', {
        c = chain({
            combo({'shift', 'cmd'}, 'x'), -- credentials
            combo({}, 'tab'),
        }),
    })
    :action('general', {
        delete = combo({'cmd'}, 'w'),
        save = combo({'cmd', 'ctrl', 'option'}, 's'), -- anybox quick save
    })
    :action('execute', {
        default = chain({
            combo({'cmd'}, 't'),
            combo({}, 'tab'),
        }),
        c = combo({'cmd'}, 's'), -- add to anybox collection
    })
    :action('debug', {
        j = combo({'cmd'}, '['), -- sources tab
        k = combo({'cmd'}, ']'), -- network tab
    })
    :action('copy', {
        default = copy(combo({'cmd', 'shift'}, 'c')),
        d = combo({'cmd', 'shift', 'option'}, 'c'),
    })
    :action('find', {
        g = arcSiteSearch('GitHub'),
        s = arcSiteSearch('Metal'),
        v = arcSiteSearch('YouTube'),
        w = arcSiteSearch('Wikipedia'),
        z = arcSiteSearch('Amazon'),
    })
    :action('toggle', {
        default = combo({'cmd', 'option'}, 'j'), -- console
        sidebar = combo({'cmd'}, 's'),
    })

hyper:app(tinkerwell)
    :action('open', {
        default = combo({'cmd', 'shift'}, 'p'),
        c = combo({'cmd', 'shift'}, 'c'),
        r = function()
            valet = "~/.config/valet/Sites/";
            sites = {}
            for file in hs.fs.dir(valet) do
                if file == "." or file == ".." then goto continue end
                table.insert(sites, {
                    ["text"] = file,
                    ["subText"] = hs.fs.symlinkAttributes(valet .. file, "target"),
                })
                ::continue::
            end

            table.sort(sites, function(a, b) return a["text"] < b["text"] end)

            hs.chooser.new(function(choice)
                if (choice) then
                    hs.urlevent.openURL('tinkerwell://?cwd=' .. hs.base64.encode(choice.subText))
                end
            end):choices(sites):show()
        end,
        t = combo({'cmd', 'shift'}, 't'),
    })
    :action('toggle', {
        default = combo({'cmd'}, '/'),
        a = combo({'cmd', 'shift'}, 'a'),
    })

hyper:app(dash)
    :action('open', {
        default = combo({'cmd'}, 'f'),
    })
    :action('navigate', {
        up = combo({'option'}, 'up'),
        down = combo({'option'}, 'down'),
    })

hyper:app(discord)
    :action('open', {
        default = combo({'cmd'}, 'k'),
    })

hyper:app(drafts)
    :action('open', {
        default = combo({'cmd', 'shift'}, 'f'),
    })
    :action('toggle', {
        sidebar = combo({'cmd'}, '1'),
    })

hyper:app(finder)
    :action('open', {
        -- default = alfredSearch('open'),
        default = combo({'cmd', 'shift'}, 'g'),
    })
    :action('toggle', {
        default = combo({'cmd', 'shift'}, '.'), -- hidden files
        sidebar = combo({'cmd', 'option'}, 's'),
    })
    :action('make', {
        default = combo({'cmd', 'shift'}, 'n'),
    })
    :action('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :action('general', {
        delete = combo({'cmd'}, 'delete'),
    })

hyper:app(iterm)
    :action('open', {
        default = keys(' f'), -- open nvim file
        f = keys(' s'), -- find nvim symbols
    })
    :action('execute', {
        default = keys(' c'), -- open nvim command
        a = keys(' ta'), -- run test suite
        f = keys(' tf'), -- run test file
        r = keys(' tr'), -- run last test
        t = keys(' tn'), -- run nearest test
    })
    :action('toggle', {
        default = keys('gcc'), -- nvim comment
        sidebar = keys(' n'), -- nvim tree
    })
    :action('copy', {
        default = chain ({
            keys('pwd | pbcopy'),
            combo({}, 'return'),
        }),
        b = chain({
            keys('git branch --show-current | tr -d \'\\n\' | pbcopy'),
            combo({}, 'return'),
        }),
    })
    :action('navigate', {
        back = combo({'ctrl'}, 'o'), -- nvim previous position
        forward = keys('gd'), -- nvim go to definition
    })
    :action('general', {
        delete = combo({'control'}, 'c'),
        -- nvim save
        save = chain({
            combo({}, 'escape'),
            keys(':w'),
            combo({}, 'return'),
            combo({}, 'escape'),
        }),
    })

hyper:app(mindnode)
    :action('toggle', {
        sidebar = chain({
            combo({'cmd'}, '6'),
            combo({'cmd'}, '7'),
        }),
    })

hyper:app(notion)
    :action('open', {
        default = combo({'cmd'}, 'p'),
    })
    :action('toggle', {
        sidebar = combo({'cmd'}, '\\'),
    })
    :action('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })

hyper:app(obsidian)
    :action('open', {
        default = combo({'cmd'}, 'o'),
        c = openObsidianNote('client'),
        f = combo({'cmd', 'shift'}, 's'),
        g = combo({'cmd', 'option'}, 'h'), -- open home page
        r = alfredWorkflow('de.chris-grieser.shimmering-obsidian', 'vault'), -- vault
        s = combo({'cmd', 'option'}, 's'), -- reveal in sidebar
        t = combo({'cmd', 'ctrl', 'option', 'shift'}, 't'), -- daily note
        w = combo({'cmd', 'option'}, 'w'), -- weekly note
    })
    :action('execute', {
        default = combo({'cmd'}, 'p'),
    })
    :action('insert', {
        a = chain({
            combo({'option'}, 'o'),
            combo({}, 'down'),
            combo({}, 'down'),
            combo({}, 'down'),
            combo({}, 'return'),
        }),
        e = combo({'cmd', 'ctrl'}, 'space'),
    })
    :action('change', {
        l = combo({'cmd', 'shift', 'option'}, 'l'), -- lowercase
        u = combo({'cmd', 'shift', 'option'}, 'u'), -- uppercase
    })
    :action('switch', {
        c = chain({ -- switch to multiline cursors
            combo({'option', 'shift'}, 'i'),
            combo({'shift'}, '6'),
        }),
    })
    :action('symbol', {
        next = chain({
            combo({'cmd', 'shift'}, 's'),
            combo({}, 'down'),
            combo({}, 'return'),
        }),
        previous = chain({
            combo({'cmd', 'shift'}, 's'),
            combo({}, 'up'),
            combo({}, 'return'),
        }),
    })
    :action('make', {
        c = combo({'cmd', 'ctrl', 'option'}, 'c'), -- meeting
        r = combo({'cmd', 'ctrl', 'option'}, 'r'), -- runbook
        t = combo({'cmd', 'ctrl', 'option'}, 't'), -- task
        w = combo({'cmd', 'ctrl', 'option'}, 'w'), -- project
        z = combo({'cmd', 'ctrl', 'option'}, 'z'), -- zettelkasten
    })
    :action('navigate', {
        back = combo({'cmd', 'option'}, 'left'),
        forward = combo({'option'}, 'return'),
        up = combo({'ctrl'}, 'tab'),
        down = combo({'ctrl', 'shift'}, 'tab'),
    })
    :action('toggle', {
        default = combo({'cmd'}, 'e'),
        sidebar = chain({
            combo({'cmd', 'option'}, 'l'),
            combo({'cmd', 'option'}, 'r'),
        }),
        f = combo({'cmd', 'ctrl'}, 'f'),
        m = combo({'cmd', 'ctrl'}, 'm'),
        t = combo({'cmd'}, 'l'), -- checklist
    })
    :action('relocate', {
        down = combo({'cmd', 'option'}, 'down'),
        up = combo({'cmd', 'option'}, 'up'),
    })
    :action('copy', {
        default = copy(combo({'cmd', 'option'}, 'c')) -- copy URL
    })
    :action('general', {
        v = combo({'ctrl', 'option'}, 'd'),
        delete = combo({'cmd', 'option'}, 'delete'),
    })

hyper:app(reminders)
    :action('toggle', {
        sidebar = combo({'cmd', 'option'}, 's'),
    })

hyper:app(omnifocus)
    :action('open', {
        default = combo({'cmd'}, 'o'),
        f = chain({
            combo({'cmd'}, '5'), -- flagged
            combo({'cmd', 'option'}, '2'), -- go to outline
        }),
        r = chain({
            combo({'cmd'}, '7'), -- routines
            combo({'cmd', 'option'}, '2'), -- go to outline
        }),
        t = chain({
            combo({'cmd'}, '4'), -- forecast
            combo({'cmd', 'option'}, '2'), -- go to outline
        }),
    })
    :action('toggle', {
        sidebar = combo({'cmd', 'option'}, 's'),
    })
    :action('general', {
        refresh = combo({'cmd'}, 'k'),
    })
    :action('find', {
        default = combo({'cmd', 'option'}, 'f'),
    })

hyper:app(onePassword)
    :action('open', {
        default = combo({'cmd'}, 'k'),
    })
    :action('copy', {
        c = combo({'cmd', 'shift'}, 'c'),
    })

hyper:app(postman)
    :action('toggle', {
        sidebar = combo({'cmd'}, '\\'),
    })
    :action('execute', {
        r = combo({'cmd'}, 'return'), -- send request
    })

hyper:app(githubDesktop)
    :action('open', {
        default = combo({'cmd'}, 't'),
        b = combo({'cmd'}, 'b'), -- branch
        c = combo({'cmd'}, '1'), -- changes
        v = combo({'cmd'}, '2'), -- history
    })

hyper:app(sketch)
    :action('toggle', {
        sidebar = chain({
            combo({'cmd', 'option'}, '1'),
            combo({'cmd', 'option'}, '2'),
        }),
    })

hyper:app(slab)
    :action('open', {
        default = combo({'cmd'}, 'k'),
    })

hyper:app(slack)
    :action('open', {
        default = combo({'cmd'}, 'k'),
        a = openSlackChannel('internal'),
        c = openSlackChannel('client'),
        e = openSlackChannel('external'),
        g = openSlackChannel('general'),
        t = combo({'cmd', 'shift'}, 't'), -- threads
    })
    :action('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :action('execute', {
        default = keys('r'), -- pick emoji for selected message
        options = combo({'cmd', 'shift'}, '\\'),
        a = slackReaction(':thanks:'),
        g = slackReaction(':thumbsup:'),
        s = slackReaction(':smile:'),
        t = slackReaction(':tada:'),
        w = slackReaction(':wave:'),
    })
    :action('insert', {
        g = keys(':thumbsup:'),
        s = keys(':smile:'),
        t = keys(':tada:'),
        w = keys(':wave:'),
    })
    :action('toggle', {
        sidebar = combo({'cmd', 'shift'}, 'd'),
        r = combo({'cmd'}, '.'),
    })

hyper:app(spotify)
    :action('open', {
        default = alfredWorkflow('com.vdesabou.spotify.mini.player', 'spot_mini'),
        b = alfredWorkflow('com.vdesabou.spotify.mini.player', 'lookup_artist_online'),
        w = alfredWorkflow('com.vdesabou.spotify.mini.player', 'lyrics'),
    })
    :action('navigate', {
        back = combo({'cmd', 'option'}, 'left'),
        forward = combo({'cmd', 'option'}, 'right'),
    })
    :action('copy', {
        default = copy(copySpotifyCurrentTrack()),
    })
    :action('find', {
        default = combo({'cmd'}, 'l'),
    })

hyper:app(sublime)
    :action('open', {
        default = combo({'cmd'}, 'p'),
        options = combo({'cmd', 'shift', 'option'}, ';'),
        b = function()
                hs.eventtap.leftClick({ x=900, y=1000 }) -- focus bottom panel
            end,
        f = combo({'cmd'}, 'r'), -- symbol
        r = combo({'cmd', 'ctrl'}, 'o'), -- project / repo
        s = combo({'cmd', 'shift'}, 's'), -- reveal in sidebar
        t = combo({'shift', 'option'}, 'p'), -- tab
        w = combo({'cmd', 'shift'}, 'o'), -- window
    })
    :action('toggle', {
        default = combo({'cmd'}, '/'),
        sidebar = combo({'cmd'}, 'b'),
        q = combo({'ctrl', 'shift'}, "'"),
    })
    :action('symbol', {
        next = combo({'cmd', 'option', 'shift'}, 'down'),
        previous = combo({'cmd', 'option', 'shift'}, 'up'),
    })
    :action('switch', {
        c = chain({ -- switch to multiline cursors
            combo({'cmd', 'shift'}, 'l'),
            combo({}, 'escape'),
            combo({'shift'}, '6'),
        }),
        r = chain({
            combo({'cmd'}, 'c'),
            openCodeInTinkerwell(),
        }),
    })
    :action('make', {
        default = combo({'cmd', 'option'}, 'n'),
        c = combo({'shift', 'option', 'ctrl'}, 'c'), -- controller
        d = combo({'shift', 'option', 'ctrl'}, 'd'), -- migration
        e = combo({'shift', 'option', 'ctrl'}, 'm'), -- model
        t = combo({'shift', 'option', 'ctrl'}, 't') -- test
    })
    :action('navigate', {
        back = combo({'control'}, '-'),
        forward = combo({'cmd', 'option'}, 'down'),
    })
    :action('execute', {
        default = combo({'cmd', 'shift'}, 'p'),
        a = combo({'cmd', 'ctrl'}, 'a'), -- run all tests
        f = combo({'cmd', 'ctrl'}, 'f'), -- test current file
        r = combo({'cmd', 'ctrl'}, 'p'), -- rerun last test
        t = combo({'cmd', 'ctrl'}, 't'), -- test current method
    })
    :action('append', {
        comma = combo({'cmd', 'option'}, ','), -- append comma
        semicolon = combo({'cmd'}, ';'), -- append semicolon
    })
    :action('insert', {
        a = keys('->'),
        c = combo({}, 'f2'), -- constructor
        d = combo({}, 'f3'), -- import dependency
        e = combo({}, 'f4'), -- expand fully qualified name
        f = chain({
            keys('closure'),
            combo({}, 'tab'),
        }),
        s = combo({}, 'f1'), -- import namespace
        w = chain({
            keys('::factory'),
            combo({}, 'tab'),
        }),
        x = combo({'cmd', 'shift', 'option'}, 'x'), -- debug
    })
    :action('general', {
        save = chain({
            combo({'cmd'}, 's'),
            combo({}, 'escape'),
        }),
        v = combo({'cmd'}, 'd'),
        duplicate = combo({'cmd', 'shift'}, 'd'),
        delete = combo({'cmd', 'option'}, 'delete'),
    })
    :action('relocate', {
        down = combo({'cmd', 'control'}, 'down'),
        up = combo({'cmd', 'control'}, 'up'),
        semicolon = combo({'shift', 'option'}, 'm'), -- move file
    })
    :action('change', {
        k = combo({'cmd', 'shift', 'option'}, 'k'), -- snake case
        l = combo({'cmd', 'shift', 'option'}, 'l'), -- lowercase
        u = combo({'cmd', 'shift', 'option'}, 'u'), -- uppercase
    })
    :action('copy', {
        a = chain({
            combo({}, 'escape'),
            combo({'cmd'}, 'a'),
            keys('y'),
        }),
        w = copy(keys('yiw')),
    })

hyper:app(sublimemerge)
    :action('open', {
        default = combo({'cmd'}, 'b'), -- branch
        r = combo({'cmd', 'shift'}, 'o'), -- repo
        sidebar = combo({'cmd'}, 'k'),
    })
    :action('make', {
        r = combo({'cmd', 'shift'}, 'n'), -- repo
        b = chain({
            combo({'cmd', 'shift'}, 'b'), -- branch
            keys('ajm/'),
        }),
    })
    :action('execute', {
        default = combo({'cmd', 'shift'}, 'p'),
        c = combo({'cmd'}, 'return'), -- commit
        f = combo({'cmd', 'option'}, 'down'), -- pull
        s = combo({'cmd', 'option'}, 'up'), -- push
    })
    :action('general', {
        save = combo({'cmd', 'shift', 'option', 'ctrl'}, 's'), -- stage
    })
    :action('toggle', {
        sidebar = combo({'cmd'}, 'k'),
    })
    :action('copy', {
        default = combo({'cmd', 'shift'}, 'b'), -- branch
    })

hyper:app(tableplus)
    :action('open', {
        default = combo({'cmd'}, 'p'),
        a = combo({'cmd', 'shift'}, 'k'), -- connection
        d = combo({'cmd', 'control'}, '['), -- data
        e = combo({'cmd'}, 'e'), -- editor
        s = combo({'cmd', 'control'}, ']'), -- structure
    })
    :action('make', {
        default = combo({'cmd'}, 'i'),
    })
    :action('navigate', {
        up = combo({'cmd'}, ']'),
        down = combo({'cmd'}, '['),
    })
    :action('general', {
        duplicate = combo({'cmd'}, 'd'),
    })
    :action('toggle', {
        sidebar = combo({'cmd'}, '0'),
    })

hyper:app(trello)
    :action('open', {
        default = keys('b'),
        c = combo({}, 'f'), -- card
    })
    :action('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :action('insert', {
        c = keys('-'), -- checklist
        d = chain({
            -- edit description
            keys('e'),
            combo({}, 'right'),
        }),
    })
    :action('general', {
        save = combo({'cmd'}, 'return'), -- description
    })

hyper:app(vscode)
    :action('copy', {
        default = copy(combo({'cmd', 'option', 'control'}, 'y')),
    })
    :action('open', {
        default = combo({'cmd'}, 'p'),
        r = combo({'cmd', 'ctrl'}, 'o'), -- project / repo
    })
    :action('execute', {
        default = combo({'cmd', 'shift'}, 'p'),
        a = chain({
            combo({'cmd', 'ctrl'}, 'a'), -- run all tests
            combo({'control'}, '`'), -- focus terminal
        }),
        f = chain({
            combo({'cmd', 'ctrl'}, 'f'), -- test current file
            combo({'control'}, '`'), -- focus terminal
        }),
        r = chain({
            combo({'cmd', 'ctrl'}, 'p'), -- rerun last test
            combo({'control'}, '`'), -- focus terminal
        }),
        t = chain({
            combo({'cmd', 'ctrl'}, 't'), -- test current method
            combo({'control'}, '`'), -- focus terminal
        }),
    })
    :action('make', {
        default = combo({'cmd', 'option'}, 'n'),
    })
    :action('toggle', {
        default = combo({'cmd'}, '/'),
        sidebar = combo({'cmd', 'shift'}, 'e'),
        t = combo({'control'}, '`'),
    })
    :action('general', {
        save = chain({
            combo({'cmd'}, 's'),
            combo({}, 'escape'),
        }),
        v = combo({'cmd'}, 'd'),
        duplicate = combo({'cmd', 'shift'}, 'd'),
        delete = combo({'cmd', 'option'}, 'delete'),
    })

hyper:app(zoom)
    :action('toggle', {
        default = combo({'cmd', 'shift'}, 'a'), -- mute
        r = combo({'cmd', 'shift'}, 'h'), -- chat
    })

hyper:app('fallback')
    :action('open', {
        alfred = combo({'cmd', 'shift', 'option', 'control'}, ';'),
        options = combo({'cmd', 'shift', 'option'}, 's'), -- search selections with vimac
        t = combo({'cmd', 'shift', 'option'}, 't'), -- search tabs with witch
        w = combo({'cmd', 'shift', 'option'}, 'w'), -- search windows with witch
    })
    :action('copy', {
        default = copy(),
    })
    :action('paste', {
        default = combo({'cmd'}, 'v'),
    })
    :action('insert', {
        default = combo({'cmd', 'shift', 'option', 'control'}, 'i'), -- Alfred clipboard
    })
    :action('toggle', {
        display = moveWindowToNextDisplay()
    })
    :action('navigate', {
        up = combo({'cmd', 'shift'}, ']'),
        down = combo({'cmd', 'shift'}, '['),
    })
    :action('execute', {
        default = alfredWorkflow('com.tedwise.menubarsearch', 'menubarsearch'),
    })
    :action('general', {
        save = combo({'cmd'}, 's'),
        refresh = combo({'cmd'}, 'r'),
    })
    :action('find', {
        default = combo({'cmd'}, 'f'),
    })
    :action('launch', {
        bunch = alfredWorkflow('com.kjaymiller.bunch', 'launch'),
    })
    :action('modal', {
        app = modal('app', {
            a = launch(activitymonitor),
            k = launch(keynote),
            m = launch(messages),
            n = launch(notion),
            p = launch(postman),
            s = launch(systempreferences),
        },
        function()
            modeMenuBar:setTitle('App')
        end,
        function()
            modeMenuBar:setTitle('Normal')
        end),
    })

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

return obj
