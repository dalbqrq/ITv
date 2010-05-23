#!/usr/bin/env wsapi.cgi

require "orbit"

module("itvision", package.seeall, orbit.new)

-- configs

require "config"

local database = config.db
require("luasql." .. database.driver)
local env = luasql[database.driver]()
mapper.conn = env:connect(database.dbname, database.dbuser, database.dbpass)
mapper.driver = database.driver

-- models

app_list = itvision:model "app_list"

function app_list:find_app_list()
   return self:find_all("")
end

-- controllers

function index(web)
   return render_index()
end

itvision:dispatch_get(index, "/", "/index")


function say(web, name, n1, n2)
   return render_say(web, name, n1, n2)
end

itvision:dispatch_get(say, "/say/(%a+):(%d+):(%d+)")


function add(web, post_id)
   local input = web.imput
   --return web:redirect(web:link("/post/" .. post_id))
   return render_add(web, post_id, web.input.user)
end

itvision:dispatch_post(add, "/add/(%d+)")


function input(web)
   return render_input(web)
end

itvision:dispatch_get(input, "/input")

-- views

function render_layout(inner_html)
   return html{
     head{ title"Hello" },
     body{ inner_html }
   }
end

function render_itvision()
   local s = "<p>"
   local a = app_list:find_app_list()
   for i,v in ipairs(a) do
      s = s.."[ "..v.app_id.." + "..v.object_id.." ] <p>"
   end
   return p.itvision"Hello World!"..s
end

function render_index()
   return render_layout(render_itvision())
end

function render_say(web, name, n1, n2)
   return render_layout(render_itvision() .. 
     p.itvision((web.input.greeting or "Hello ") .. name .. " : " .. n1 .." : " .. n2 .." !"))
end

function render_add(web, post_id, user)
   return render_layout(p.itvision((web.input.greeting or "Hello ") .. post_id .." & ".. user))
end

function render_input(web)
   res = {}

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = "/add/30"),
      --action = web:link("/add/30"),

      --p{ strings.form_name, br(), input{ type="text", name="author", value = web.input.author },
      p{ "NAME:", br(), input{ type="text", name="author", value = "Daniel" },
         br(), br(),

--[[
         strings.form_email, br(), input{ type="text", name="email",
         value = web.input.email },
         br(), br(),
         strings.form_url, br(), input{ type="text", name="url",
         value = web.input.url },
         br(), br(),
         strings.comments .. ":", br(), err_msg,
         textarea{ name="comment", rows="10", cols="60", web.input.comment },
         br(),
         em(" *" .. strings.italics .. "* "),
         strong(" **" .. strings.bold .. "** "),
         " [" .. a{ href="/url", strings.link } .. "](http://url) ",
         br(), br(),
]]
         input.button{ type="submit", value="Enviar" }
      }
   }
   res[#res + 1] = p.itvision "INPUT"
   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M
