#!/usr/bin/env wsapi.cgi

local loo = require "loop.base"

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "View"
require "Resume"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)

local monitors = Model.itvision:model "monitors"
local objects  = Model.nagios:model "objects"
local apps = Model.itvision:model "apps"

print("hi")

for i,v in pairs(package.loaded) do
   print(i.."\t\t\t",v)
   if type(v) == "table" then
      for j,u in pairs(v) do
         print("\t"..j.."\t\t\t",u)
         if type(u) == "table" then
            for k,w in pairs(u) do
               print("\t\t"..k.."\t\t\t",w)
               if w == "seeall" then
                  for l,x in pairs(w) do
                     print("\t\t"..l.."\t\t\t",x)
                  end
               end
            end
         end
      end
   end
end
