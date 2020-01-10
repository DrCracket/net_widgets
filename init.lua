local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.net_widgets = nil

local net_widgets = {
    wired       = require(module_path .. "net_widgets.wired"),
    wireless    = require(module_path .. "net_widgets.wireless"),
    indicator   = require(module_path .. "net_widgets.indicator"),
    internet    = require(module_path .. "net_widgets.internet")
}

return net_widgets
