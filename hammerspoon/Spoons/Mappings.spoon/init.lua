local obj = {}
obj.__index = obj

hs.loadSpoon('Hyper')
hs.loadSpoon('Helpers')
hs.loadSpoon('Apps')

local modeMenuBar = hs.menubar.new():setTitle('Normal');

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
        default = alfredSearch('bm'),
        options = combo({'control', 'shift'}, 's'),
        a = combo({'cmd', 'shift'}, 'm'), -- profile
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
        default = alfredSearch('open'),
    })
    :action('toggle', {
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
    :action('copy', {
        b = chain({
            keys('git branch --show-current | tr -d \'\\n\' | pbcopy'),
            combo({}, 'return'),
        }),
        d = chain ({
            keys('pwd | pbcopy'),
            combo({}, 'return'),
        }),
    })
    :action('general', {
        delete = combo({'control'}, 'c'),
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
        a = slackReaction(':thanks'),
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
    })
    :action('make', {
        default = combo({'cmd', 'option'}, 'n'),
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
        duplicate = combo({'cmd', 'shift'}, 'd'),
        delete = combo({'cmd', 'option'}, 'delete'),
    })
    :action('relocate', {
        down = combo({'cmd', 'control'}, 'down'),
        up = combo({'cmd', 'control'}, 'up'),
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
        b = combo({'cmd', 'shift'}, 'b'), -- branch
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
    })
    :action('toggle', {
        default = combo({'cmd'}, '/'),
        sidebar = combo({'cmd', 'shift'}, 'e'),
    })

hyper:app('fallback')
    :action('open', {
        options = combo({'cmd', 'shift', 'option'}, 's'), -- search selections with vimac
        t = combo({'cmd', 'shift', 'option'}, 't'), -- search tabs with witch
        w = combo({'cmd', 'shift', 'option'}, 'w'), -- search windows with witch
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
