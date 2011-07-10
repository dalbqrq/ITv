#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "View"
require "util"
require "state"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"
local objects = Model.nagios:model "objects"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function apps:select(id, obj_id)
   local clause = ""
   if id then clause = "id = "..id end
   if obj_id then clause = "service_object_id = "..obj_id end
   return Model.query("itvision_apps", clause)
end


function objects:select(id)
   local clause = ""
   if id then clause = "object_id = "..id end
   return Model.query("nagios_objects", clause)
end


-- controllers ------------------------------------------------------------

function info(web, tab, obj_id)
   local auth = Auth.check(web)
   tab = tonumber(tab)
   if not auth then return Auth.redirect(web) end

   local A = Monitor.make_query_4(nil, nil, nil, "m.service_object_id = "..obj_id)
   local C = objects:select(A[1].s_check_command_object_id) --check_command
   if tab == 1 then
      return render_info(web, obj_id, A, C)
   elseif tab == 2 then
      return render_history(web, obj_id, A)
   elseif tab == 3 then
      return render_data(web, obj_id, A)
   end
end
ITvision:dispatch_get(info, "/(%d+):(%d+)")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_info(web, obj_id, A, C)
   local permission, auth = Auth.check_permission(web, "application")
   local s = A[1]
   local cmd = C[1]
   local res = {}
   local row = {}
   local tab = {}
   local lft, rgt = {}, {}
   local state

   tab = {}
   tab[#tab+1] = { b{"Nome do serviço: "}, s.m_name }
   tab[#tab+1] = { b{"Comando de checagm: "}, cmd.name1 }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { b{"Hostname: "}, s.c_name }
   tab[#tab+1] = { b{"Alias: "}, s.c_alias }
   tab[#tab+1] = { b{"IP: "}, s.p_ip }
   local types = {}
   if s.p_itemtype == "Computer" then
      class = strings.computer
   else
      class = strings.networkequipment
   end
   tab[#tab+1] = { b{"Classe: "}, class }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   lft[#lft+1] = render_table( tab, nil, "tab_cadre_grid" )



   tab = {}
   state = s.ss_current_state
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Status atual: "}, name_ok_warning_critical_unknown(s.ss_current_state) }
   tab[#tab+1] = { b{"Status info: "}, s.ss_output }
   tab[#tab+1] = { b{"No. de tentativas/Máximo de tentativas: "}, s.ss_current_check_attempt.."/"..s.ss_max_check_attempts }
   tab[#tab+1] = { b{"Ultima checagem: "}, s.ss_last_check }
   tab[#tab+1] = { b{"Próxima checagem: "}, s.ss_next_check }
   tab[#tab+1] = { b{"Última mudança de estado: "}, s.ss_last_state_change }
   tab[#tab+1] = { b{"Última mudança de estado tipo 'HARD': "}, s.ss_last_hard_state_change }
   if s.ss_is_flapping == 1 then state = 2 else state = s.ss_is_flapping end
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Está flapping: "}, name_yes_no(s.ss_is_flapping) }
   tab[#tab+1] = { b{"Último status tipo 'HARD': "}, name_ok_warning_critical_unknown(s.ss_last_hard_state) }
   tab[#tab+1] = { b{"Tempo entre checagens: "}, s.ss_normal_check_interval.."min" }
   tab[#tab+1] = { b{"Tempo entre checagens após falha: "}, s.ss_retry_check_interval.."min" }
   tab[#tab+1] = { b{"Output completo: "}, s.ss_long_output }
   tab[#tab+1] = { b{"Dados de performance: "}, s.ss_perfdata }
   tab[#tab+1] = { b{"Latência: "}, s.ss_latency.."ms" }

   rgt[#rgt+1] = render_table( tab, nil, "tab_cadre_grid" )

   row[#row+1] = {lft, rgt }
   res[#res+1] = render_table( row )
   res[#res+1] = { br(), br(), br(), br() }
   

   return render_layout(res)
end


function render_history(web, obj_id, A, H)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

   if H then
      for i,v in ipairs(H) do
         row[#row+1] = { v.state_time, v.state_time_usec, v.state_change, v.state, v.state_type, v.last_state, v.last_hard_state }
      end
   else
      res[#res+1] = { "HISTORY : "..obj_id }
   end

   res[#res+1] = render_table( row )
   res[#res+1] = { br(), br(), br(), br() }

   return render_layout(res)
end


function render_data(web, obj_id, A)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

   res[#res+1] = { "RAW DATA" }
   row = {}
   for i, v in pairs(A[1]) do
      row[#row+1] = {
         i, v,
--[[
         a{ href=lnk, v.name },
         strings["logical_"..v.type],
         NoOrYes[v.is_active+1].name,
         button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type)),
]]
      }
   end

   --res[#res+1] = render_content_header(auth, A[1].c_name, nil, nil, nil , nil)
   res[#res+1] = render_grid({ {render_table(row, nil, ""), render_map_frame(web, "hst", obj_id)} } )

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


