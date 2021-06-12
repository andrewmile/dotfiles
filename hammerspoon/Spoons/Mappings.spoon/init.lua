local obj = {}
obj.__index = obj

hs.loadSpoon('Hyper')
hs.loadSpoon('Helpers')
hs.loadSpoon('Apps')

local modeMenuBar = hs.menubar.new():setTitle('Normal');

hyper:app(bear)
    :mode('open', {
        primary = alfredWorkflow('com.drgrib.bear', 'search bear'),
        t = function()
                hs.urlevent.openURL('bear://x-callback-url/open-note?title=' .. os.date('%Y.%m.%d') ..'&show_window=yes&new_window=no') -- open today's work journal
            end,
    })
    :mode('toggle', {
        sidebar = combo({'control'}, '1'),
    })
    :mode('navigate', {
        back = combo({'cmd', 'option'}, 'left'),
        forward = combo({'cmd', 'option'}, 'right'),
    })
    :mode('relocate', {
        down = combo({'cmd', 'option'}, 'down'),
        up = combo({'cmd', 'option'}, 'up'),
    })
    :mode('copy', {
        primary = copy(combo({'cmd', 'option', 'shift'}, 'l')),
    })

hyper:app(chrome)
    :mode('open', {
        primary = alfredSearch('bm'),
        options = combo({'control', 'shift'}, 's'),
        a = combo({'cmd', 'shift'}, 'm'), -- profile
        e = combo({'cmd', 'shift'}, 'c'), -- select element
        t = combo({'shift'}, 't'), -- search tabs with vimium
        x = combo({'cmd', 'option'}, 'j'), -- console
    })
    :mode('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :mode('insert', {
        c = combo({'ctrl', 'option', 'cmd'}, 'p'), -- credentials
    })
    :mode('common', {
        delete = combo({'cmd'}, 'w'),
    })
    :mode('debug', {
        j = combo({'cmd'}, '['), -- sources tabe
        k = combo({'cmd'}, ']'), -- network tab
    })
    :mode('copy', {
        primary = copy(keys('yy')),
        d = copyChromeUrlAsMarkdown(),
    })
    :mode('find', {
        z = combo({'cmd', 'ctrl', 'shift'}, 'z'), -- amazon
    })

hyper:app(dash)
    :mode('open', {
        primary = combo({'cmd'}, 'f'),
    })
    :mode('navigate', {
        up = combo({'option'}, 'up'),
        down = combo({'option'}, 'down'),
    })

hyper:app(discord)
    :mode('open', {
        primary = combo({'cmd'}, 'k'),
    })

hyper:app(drafts)
    :mode('open', {
        primary = combo({'cmd', 'shift'}, 'f'),
    })
    :mode('toggle', {
        sidebar = combo({'cmd'}, '1'),
    })

hyper:app(finder)
    :mode('open', {
        primary = alfredSearch('open'),
    })
    :mode('toggle', {
        sidebar = combo({'cmd', 'option'}, 's'),
    })
    :mode('make', {
        primary = combo({'cmd', 'shift'}, 'n'),
    })
    :mode('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :mode('common', {
        delete = combo({'cmd'}, 'delete'),
    })

hyper:app(iterm)
    :mode('copy', {
        b = chain({
            keys('git branch --show-current | tr -d \'\\n\' | pbcopy'),
            combo({}, 'return'),
        }),
    })
    :mode('common', {
        delete = combo({'control'}, 'c'),
    })

hyper:app(mindnode)
    :mode('toggle', {
        sidebar = chain({
            combo({'cmd'}, '6'),
            combo({'cmd'}, '7'),
        }),
    })

hyper:app(notion)
    :mode('open', {
        primary = combo({'cmd'}, 'p'),
    })
    :mode('toggle', {
        sidebar = combo({'cmd'}, '\\'),
    })
    :mode('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })

hyper:app(omnifocus)
    :mode('open', {
        primary = combo({'cmd'}, 'o'),
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
    :mode('toggle', {
        sidebar = combo({'cmd', 'option'}, 's'),
    })
    :mode('common', {
        refresh = combo({'cmd'}, 'k'),
    })

hyper:app(onePassword)
    :mode('copy', {
        c = combo({'cmd', 'shift'}, 'c'),
    })

hyper:app(postman)
    :mode('toggle', {
        sidebar = combo({'cmd'}, '\\'),
    })
    :mode('execute', {
        r = combo({'cmd'}, 'return'), -- send request
    })

hyper:app(githubDesktop)
    :mode('open', {
        primary = combo({'cmd'}, 't'),
        b = combo({'cmd'}, 'b'), -- branch
        c = combo({'cmd'}, '1'), -- changes
        v = combo({'cmd'}, '2'), -- history
    })

hyper:app(sketch)
    :mode('toggle', {
        sidebar = chain({
            combo({'cmd', 'option'}, '1'),
            combo({'cmd', 'option'}, '2'),
        }),
    })

hyper:app(slack)
    :mode('open', {
        primary = combo({'cmd'}, 'k'),
        a = openSlackChannel('internal'),
        c = openSlackChannel('client'),
        e = openSlackChannel('external'),
        g = openSlackChannel('general'),
        t = combo({'cmd', 'shift'}, 't'), -- threads
    })
    :mode('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :mode('execute', {
        primary = keys('r'), -- pick emoji for selected message
        options = combo({'cmd', 'shift'}, '\\'),
        a = slackReaction(':thanks'),
        g = slackReaction(':thumbsup:'),
        s = slackReaction(':smile:'),
        t = slackReaction(':tada:'),
        w = slackReaction(':wave:'),
    })
    :mode('insert', {
        g = keys(':thumbsup:'),
        s = keys(':smile:'),
        t = keys(':tada:'),
        w = keys(':wave:'),
    })
    :mode('toggle', {
        sidebar = combo({'cmd', 'shift'}, 'd'),
        r = combo({'cmd'}, '.'),
    })

hyper:app(spotify)
    :mode('open', {
        primary = alfredWorkflow('com.vdesabou.spotify.mini.player', 'spot_mini'),
        w = alfredWorkflow('com.vdesabou.spotify.mini.player', 'lyrics'),
    })
    :mode('navigate', {
        back = combo({'cmd', 'option'}, 'left'),
        forward = combo({'cmd', 'option'}, 'right'),
    })
    :mode('copy', {
        primary = copy(copySpotifyCurrentTrack()),
    })
    :mode('find', {
        primary = combo({'cmd'}, 'l'),
    })

hyper:app(sublime)
    :mode('open', {
        primary = combo({'cmd'}, 'p'),
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
    :mode('toggle', {
        primary = combo({'cmd'}, '/'),
        sidebar = combo({'cmd'}, 'b'),
    })
    :mode('make', {
        primary = combo({'cmd', 'option'}, 'n'),
    })
    :mode('navigate', {
        back = combo({'control'}, '-'),
        forward = combo({'cmd', 'option'}, 'down'),
    })
    :mode('execute', {
        primary = combo({'cmd', 'shift'}, 'p'),
        a = combo({'cmd', 'ctrl'}, 'a'), -- run all tests
        f = combo({'cmd', 'ctrl'}, 'f'), -- test current file
        r = combo({'cmd', 'ctrl'}, 'p'), -- rerun last test
        t = combo({'cmd', 'ctrl'}, 't'), -- test current method
    })
    :mode('append', {
        comma = combo({'cmd', 'option'}, ','), -- append comma
        semicolon = combo({'cmd'}, ';'), -- append semicolon
    })
    :mode('insert', {
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
    :mode('common', {
        save = chain({
            combo({'cmd'}, 's'),
            combo({}, 'escape'),
        }),
        duplicate = combo({'cmd', 'shift'}, 'd'),
        delete = combo({'cmd', 'option'}, 'delete'),
    })
    :mode('relocate', {
        down = combo({'cmd', 'control'}, 'down'),
        up = combo({'cmd', 'control'}, 'up'),
    })
    :mode('change', {
        k = combo({'cmd', 'shift', 'option'}, 'k'), -- snake case
        l = combo({'cmd', 'shift', 'option'}, 'l'), -- lowercase
        u = combo({'cmd', 'shift', 'option'}, 'u'), -- uppercase
    })

hyper:app(sublimemerge)
    :mode('open', {
        primary = combo({'cmd', 'shift'}, 'o'),
        b = combo({'cmd'}, 'b'), -- branch
        sidebar = combo({'cmd'}, 'k'),
    })
    :mode('make', {
        r = combo({'cmd', 'shift'}, 'n'), -- repo
        b = combo({'cmd', 'shift'}, 'b'), -- branch
    })
    :mode('execute', {
        primary = combo({'cmd', 'shift'}, 'p'),
        c = combo({'cmd'}, 'return'), -- commit
        f = combo({'cmd', 'option'}, 'down'), -- pull
        s = combo({'cmd', 'option'}, 'up'), -- push
    })
    :mode('common', {
        save = combo({'cmd', 'shift', 'option', 'ctrl'}, 's'), -- stage
    })
    :mode('toggle', {
        sidebar = combo({'cmd'}, 'k'),
    })

hyper:app(tableplus)
    :mode('open', {
        primary = combo({'cmd'}, 'p'),
        a = combo({'cmd', 'shift'}, 'k'), -- connection
        d = combo({'cmd', 'control'}, '['), -- data
        e = combo({'cmd'}, 'e'), -- editor
        s = combo({'cmd', 'control'}, ']'), -- structure
    })
    :mode('make', {
        primary = combo({'cmd'}, 'i'),
    })
    :mode('navigate', {
        up = combo({'cmd'}, ']'),
        down = combo({'cmd'}, '['),
    })
    :mode('common', {
        duplicate = combo({'cmd'}, 'd'),
    })

hyper:app(trello)
    :mode('open', {
        primary = keys('b'),
        c = combo({}, 'f'), -- card
    })
    :mode('navigate', {
        back = combo({'cmd'}, '['),
        forward = combo({'cmd'}, ']'),
    })
    :mode('insert', {
        c = keys('-'), -- checklist
        d = chain({
            -- edit description
            keys('e'),
            combo({}, 'right'),
        }),
    })
    :mode('common', {
        save = combo({'cmd'}, 'return'), -- description
    })

hyper:app(vscode)
    :mode('copy', {
        primary = copy(combo({'cmd', 'option', 'control'}, 'y')),
    })
    :mode('open', {
        primary = combo({'cmd'}, 'p'),
        r = combo({'cmd', 'ctrl'}, 'o'), -- project / repo
    })
    :mode('execute', {
        primary = combo({'cmd', 'shift'}, 'p'),
    })
    :mode('toggle', {
        primary = combo({'cmd'}, '/'),
        sidebar = combo({'cmd', 'shift'}, 'e'),
    })

hyper:app('default')
    :mode('open', {
        options = combo({'cmd', 'shift', 'option'}, 's'), -- search selections with vimac
        t = combo({'cmd', 'shift', 'option'}, 't'), -- search tabs with witch
        w = combo({'cmd', 'shift', 'option'}, 'w'), -- search windows with witch
    })
    :mode('toggle', {
        display = moveWindowToNextDisplay()
    })
    :mode('navigate', {
        up = combo({'cmd', 'shift'}, ']'),
        down = combo({'cmd', 'shift'}, '['),
    })
    :mode('execute', {
        primary = alfredWorkflow('com.tedwise.menubarsearch', 'menubarsearch'),
    })
    :mode('common', {
        save = combo({'cmd'}, 's'),
        refresh = combo({'cmd'}, 'r'),
    })
    :mode('find', {
        primary = combo({'cmd'}, 'f'),
    })
    :mode('modal', {
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
