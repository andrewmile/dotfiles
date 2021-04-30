hs.loadSpoon('Private')
hs.loadSpoon('ModalMgr')
hs.loadSpoon('Mappings')
hs.loadSpoon('Windows')

mode = 'normal'

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
