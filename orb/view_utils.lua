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

require "messages"

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


local menu = {}
   menu[#menu + 1] = button_link("ARVORE APPS", "app_tree")
   menu[#menu + 1] = button_link("APPS", "apps")
   menu[#menu + 1] = button_link("APP LIST", "app_list")
   menu[#menu + 1] = button_link("RELACIONAMENTOS", "app_relat")
   menu[#menu + 1] = button_link("TIPO RELAC.", "app_relat_type")
   menu[#menu + 1] = button_link("CONTRATOS", "contract")
   menu[#menu + 1] = button_link("LOCALIZACAO", "location_tree")
   menu[#menu + 1] = button_link("FABRICANTE", "manufacturer")
   menu[#menu + 1] = button_link("USUARIO", "user")
   menu[#menu + 1] = button_link("GRUPO", "user_group")
   menu[#menu + 1] = button_link("SISTEMA", "sysconfig")
   menu[#menu + 1] = "<br><br><br>"



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
      body{ menu, inner_html }
   }
end


function select_option(name, T, value_idx, label_idx, default_value)
   local olist = {}

   olist[#olist + 1] = "<select name=\""..name.."\">"
   for i, v in ipairs(T) do
      if default_value then
         if ((type(tonumber(default_value)) ~= "nil") and (tonumber(default_value) == tonumber(v[value_idx])) )
            or ( default_value == v[value_idx] )
         then
            selected = "selected "
         else
            selected = ""
         end
      else
         selected = ""
      end

      olist[#olist + 1] = "<option "..selected.." value=\""..v[value_idx].."\" label=\""..
                          v[label_idx].."\">"..v[label_idx].."</option>"

   end
   olist[#olist + 1] = "</select>"

   return olist

end

AndOrOr = {
   { id = "and", name = strings.logical_and },
   { id = "or",  name = strings.logical_or },
}

NoOrYes = {
      { id = 0, name = strings.no },
      { id = 1, name = strings.yes },
   }


function select_and_or(name, default)
   return select_option(name, AndOrOr, "id", "name", default)
end


function select_yes_no(name, default)
   return select_option(name, NoOrYes, "id", "name", default)
end


