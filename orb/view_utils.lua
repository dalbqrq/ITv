--[[ 

  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

]]

require "orbit"
module("itvision", package.seeall, orbit.new)

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


