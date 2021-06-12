hs.loadSpoon('Private')
hs.loadSpoon('Mappings')
hs.loadSpoon('Windows')

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
end)wf = hs.window.filter
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
