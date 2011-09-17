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
local statehistory = Model.nagios:model "statehistory"


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


function statehistory:select(id)
   local clause = ""
   if id then clause = "object_id = "..id end
   return Model.query("nagios_statehistory", clause, "order by state_time desc")
end



-- controllers ------------------------------------------------------------

function info(web, tab, obj_id)
   local auth = Auth.check(web)
   tab = tonumber(tab)
   if not auth then return Auth.redirect(web) end

   local A = Monitor.make_query_4(nil, nil, nil, "m.service_object_id = "..obj_id)

   if tab == 1 then
      local APPS = Monitor.make_query_5(nil, 
                      "ax.id in (select app_id from itvision_app_objects where service_object_id = "..obj_id..")", true) 
      local C = objects:select(A[1].s_check_command_object_id) --check_command
      return render_info(web, obj_id, A, C, APPS)
   elseif tab == 2 then
      local H = statehistory:select(obj_id)
      return render_history(web, obj_id, A, H)
   elseif tab == 3 then
      return render_data(web, obj_id, A)
   elseif tab == 4 then
      return render_check(web, obj_id, A)
   end
end
ITvision:dispatch_get(info, "/(%d+):(%d+)")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_info(web, obj_id, A, C, APPS)
   local permission, auth = Auth.check_permission(web, "application")
   local s = A[1]
   local cmd = C[1]
   local res = {}
   local row = {}
   local tab = {}
   local lft, rgt = {}, {}
   local state
   local header = { "SERVIÇO", "RESULTADO DA CHECAGEM" }

   --DEBUG: res[#res+1] = { "COUNT : " ..obj_id.." : "..#A}

   tab = {}
   tab[#tab+1] = { b{"Nome do serviço: "}, s.m_name }
   tab[#tab+1] = { b{"Comando de checagm: "}, cmd.name1 }
   tab[#tab+1] = { ". ", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { colspan=2, ".", " " }
   tab[#tab+1] = { center{b{"DISPOSITIVO"}} }
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
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   lft[#lft+1] = render_table( tab, nil, "tab_cadre_grid" )



   tab = {}
   if tonumber(s.m_state) == 0 then
      state = APPLIC_DISABLE
   else
      state = s.ss_current_state
   end
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Status atual: "}, name_ok_warning_critical_unknown(state) }
   if tonumber(s.m_state) == 0 then
      tab[#tab+1] = { b{"Status info: "}, "" }
      tab[#tab+1] = { b{"No. de tentativas/Máximo de tentativas: "}, "" }
      tab[#tab+1] = { b{"Ultima checagem: "}, "" }
      tab[#tab+1] = { b{"Próxima checagem: "}, "" }
   else
      tab[#tab+1] = { b{"Status info: "}, s.ss_output }
      tab[#tab+1] = { b{"No. de tentativas/Máximo de tentativas: "}, s.ss_current_check_attempt.."/"..s.ss_max_check_attempts }
      tab[#tab+1] = { b{"Ultima checagem: "}, string.extract_datetime(s.ss_last_check) }
      tab[#tab+1] = { b{"Próxima checagem: "}, string.extract_datetime(s.ss_next_check) }
   end
   tab[#tab+1] = { b{"Última mudança de estado: "}, string.extract_datetime(s.ss_last_state_change) }
   tab[#tab+1] = { b{"Última mudança de estado tipo 'HARD': "}, string.extract_datetime(s.ss_last_hard_state_change) }
   if tonumber(s.m_state) == 0 then
      tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Está flapping: "}, strings.no }
   else
      if s.ss_is_flapping == 1 then state = 2 else state = s.ss_is_flapping end
      tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Está flapping: "}, name_yes_no(s.ss_is_flapping) }
   end
   tab[#tab+1] = { b{"Último status tipo 'HARD': "}, name_ok_warning_critical_unknown(s.ss_last_hard_state) }
   tab[#tab+1] = { b{"Tempo entre checagens: "}, s.ss_normal_check_interval.."min" }
   tab[#tab+1] = { b{"Tempo entre checagens após falha: "}, s.ss_retry_check_interval.."min" }
   tab[#tab+1] = { b{"Output completo: "}, s.ss_long_output }
   tab[#tab+1] = { b{"Dados de performance: "}, s.ss_perfdata }
   if tonumber(s.m_state) == 0 then
      tab[#tab+1] = { b{"Latência: "}, "" }
   else
      tab[#tab+1] = { b{"Latência: "}, s.ss_latency.."ms" }
   end

   rgt[#rgt+1] = render_table( tab, nil, "tab_cadre_grid" )

   row[#row+1] = {lft, rgt }
   res[#res+1] = render_table( row, header )
   res[#res+1] = { br(), br() }
   

   -- APLICACOES
   row = {}
   header = { "APLICAÇÕES QUE POSSUEM ESTE SERVIÇO", "STATUS ATUAL", "Última checagem", "Próxima checagem", "Última mudança de estado"  }

   for i, v in ipairs(APPS) do
      row[#row+1] = { v.ax_name, {value=name_ok_warning_critical_unknown(v.ss_current_state), state=v.ss_current_state}, 
                      string.extract_datetime(v.ss_last_check),
                      string.extract_datetime(v.ss_next_check), string.extract_datetime(v.ss_last_state_change), }
   end

   --res[#res+1] = { "APPS: "..obj_id.." : "..#APPS }
   res[#res+1] = render_table( row, header )
   res[#res+1] = { br(), br(), br() }

   return render_layout(res)
end


function render_history(web, obj_id, A, H)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

   --local header = { "Data e hora", "usec", "Estado", "Tipo", "Tentativa", "Houve Mudança", "Último Estado", "Último HARD", "Output"}
   local header = { "Data e hora", "Estado", "Tipo", "Tentativas", "Output"}
   if H then
      --DEBUG: res[#res+1] = { "COUNT : " ..obj_id.." : "..#H}
      for i,v in ipairs(H) do
      --[[
         row[#row+1] = { v.state_time, v.state_time_usec, 
                         {value=name_ok_warning_critical_unknown(v.state), state=v.state},
                         name_soft_hard(v.state_type), 
                         v.current_check_attempt.."/"..v.max_check_attempts,
                         name_yes_no(v.state_change),
                         {value=name_ok_warning_critical_unknown(v.last_state), state=v.last_state},
                         {value=name_ok_warning_critical_unknown(v.last_hard_state),  state=v.last_hard_state},
                         v.output }
       ]]

         row[#row+1] = { string.extract_datetime(v.state_time), 
                         {value=name_ok_warning_critical_unknown(v.state), state=v.state},
                         name_soft_hard(v.state_type), 
                         v.current_check_attempt.."/"..v.max_check_attempts,
                         v.output }

      end
   else
      res[#res+1] = b{ "SEM HISTÓRICO DISPONÍVEL" }
      --DEBUG: res[#res+1] = { " ["..obj_id.."]" }
   end

   res[#res+1] = render_table( row, header )
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


function render_check(web, obj_id, A)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

   web.prefix = "/orb/probe"
   local url = web:link("/update/4:"..A[1].c_id..":"..A[1].p_id..":0:"..obj_id..":0:1")
   res[#res+1] = iframe{ src=url, width="100%", height="100%", frameborder="0", "---" }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


