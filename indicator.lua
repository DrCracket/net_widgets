local module_path = (...):match ("(.+/)[^/]+$") or ""
local gears       = require("gears")
local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local wired       = require(module_path .. "net_widgets.wired")
local wireless    = require(module_path .. "net_widgets.wireless")
local indicator   = {}

local function worker(args)
  args = args or {}
  local timeout = args.timeout or 5
  local wireless_widget = wireless(args)
  local wireless_icon_container
  local wireless_text_container
  local wireless_text
  local wireless_icon
  local wired_widget = wired(args)
  local wired_text = wibox.widget.textbox()
  local wired_icon

  if args.widget == false then
    wireless_icon_container = wireless_widget.imagebox
    wireless_text_container = wireless_widget.textbox
  else
    wireless_icon_container = wireless_widget:get_all_children()[1]
    wireless_text_container = wireless_widget:get_all_children()[3]
  end

  wireless_icon = wireless_icon_container.icon
  wireless_text = wireless_text_container.text
  wired_icon = wired_widget:get_all_children()[1].icon
  wired_text:set_markup(string.format("<span color=%q><b>%s</b></span>", beautiful.bg_normal, "--"))

  local function net_update()
	awful.spawn.easy_async_with_shell("iwconfig 2>&1 | grep -q ESSID",
      function(_, _, _, exit_code)
        if exit_code == 0 then
          wireless_icon_container:set_widget(wireless_icon)
          wireless_text_container:set_widget(wireless_text)
        else
          wireless_icon_container:set_widget(wired_icon)
          wireless_text_container:set_widget(wired_text)
        end
      end)
  end

  net_update()
  gears.timer.start_new( timeout, function () net_update()
    return true end )

  return wireless_widget
end

return setmetatable(indicator, {__call = function(_,...) return worker(...) end})
