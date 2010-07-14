#!/usr/bin/env wsapi.cgi
--[[ 

  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)

]]

require "orbit"
module("itvision", package.seeall, orbit.new)
require "cosmo"

local scrt = [[
   function confirmation(question, url) { 
      var answer = confirm(question) 
      if (answer){ 
         //alert("The answer is OK!"); 
         window.location = url;
      } else { 
         //alert("The answer is CANCEL!") 
      } 
   } 
   ]]


function do_button(web, label, url, question)
   -- TODO:  NAO ESTAh FUNCIONANDO !!!!
   return { form = { action = web:link(url),  input = { value = label, type = "submit" } } }
end


function button_form(label, btype, class)
   class = class or "none"
   return [[<div class="buttons"><button type="]]..btype..
          [[" class="]]..class..[["> ]]..label..[[ </button> </div> ]]
end


function button_link(label, link, class)
   class = class or "none"
   return [[<div class="buttons"> <a href="]]..link..
          [[" class="]]..class..[[">]]..label..[[ </a> </div>]]
end


function render_layout(inner_html)
   return html{
      head{ 
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type",
            content = "text/html; charset=utf-8" },
         link{ rel = 'stylesheet', type = 'text/css', 
            href = '/css/style.css', media = 'screen' },
         --script{ type="text/javascript", src="http://itv/js/scripts.js" },
         script{ type="text/javascript", scrt },

      },
      body{ inner_html }
   }
end


function select_option(name, T, value_idx, label_idx, default_value)
   local olist = {}

   olist[#olist + 1] = "<select name=\""..name.."\">"
   for i, v in ipairs(T) do
      if default_value and (tonumber(default_value) == tonumber(v[value_idx])) then
         selected = "selected"
      else
         selected = ""
      end

      olist[#olist + 1] = "<option "..selected.." value=\""..v[value_idx].."\" label=\""..
                          v[label_idx].."\">"..v[label_idx].."</option>"

   end
   olist[#olist + 1] = "</select>"

   return olist

end



