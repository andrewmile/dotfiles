chrome = 'com.google.Chrome'
discord = 'com.hnc.Discord'
finder = 'com.apple.finder'
iterm = 'com.googlecode.iterm2'
notion = 'notion.id'
preview = 'com.apple.Preview'
spotify = 'com.spotify.client'
sublime = 'com.sublimetext.3'

function appIs(bundle)
    return hs.application.frontmostApplication():bundleID() == bundle
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
