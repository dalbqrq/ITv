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
local locations = Model.glpi:model "locations"
local users = Model.glpi:model "users"
local entities = Model.glpi:model "entities"
local states = Model.glpi:model "states"
local networkequipmenttypes = Model.glpi:model "networkequipmenttypes"
local computertypes = Model.glpi:model "computertypes"
local statehistory = Model.nagios:model "statehistory"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function apps:select(id, obj_id)
   local clause = ""
   if id then clause = "id = "..id end
   if obj_id then clause = "service_object_id = "..obj_id end
   return Model.query("itvision_apps", clause)
end


function locations:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
end


function users:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
end


function entities:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
end


function states:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
end


function networkequipmenttypes:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
end


function computertypes:select(id)
   local clause = ""
   local dash = {}; dash.name = "-"
   if id then clause = "id = "..id end
   local res = self:find_all(clause)
   if #res == 0 then return dash else return res[1] end
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

   local A = Monitor.make_query_3(nil, nil, nil, "m.service_object_id = "..obj_id)
   if tab == 1 then
      return render_info(web, obj_id, A)
   elseif tab == 2 then
      local H = statehistory:select(obj_id)
      return render_history(web, obj_id, A, H)
   elseif tab == 3 then
      return render_cmdb(web, obj_id, A)
   elseif tab == 4 then
      return render_data(web, obj_id, A)
   end
end
ITvision:dispatch_get(info, "/(%d+):(%d+)")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_info(web, obj_id, A)
   local permission, auth = Auth.check_permission(web, "application")
   local h = A[1]
   local res = {}
   local row = {}
   local tab = {}
   local lft, rgt = {}, {}
   local state

   web.prefix="/obj_info"
   local lnkgeo = web:link("/geotag/hst:"..obj_id)
   local lnkedt = web:link("/geotag/hst:"..obj_id)
   web.prefix="/hst_info"

   tab = {}
   tab[#tab+1] = { b{"Hostname: "}, h.c_name }
   tab[#tab+1] = { b{"Alias: "}, h.c_alias }
   tab[#tab+1] = { b{"IP: "}, h.p_ip }
   local location = locations:select(h.c_locations_id)
   tab[#tab+1] = { b{"Localização: "}, location.name }
   local states = states:select(h.c_states_id)
   tab[#tab+1] = { b{"Status: "}, states.name }
   local types = {}
   if h.p_itemtype == "Computer" then
      types = computertypes:select(h.c_computertypes_id)
      class = strings.computer
   else
      types = networkequipmenttypes:select(h.c_computertypes_id)
      class = strings.networkequipment
   end
   tab[#tab+1] = { b{"Classe: "}, class }
   tab[#tab+1] = { b{"Tipo: "}, types.name }
   local ent = entities:select(h.c_entities_id)
   tab[#tab+1] = { b{"Entidade: "}, ent.name }
   local resp = users:select(h.c_users_id_tech)
   tab[#tab+1] = { b{"Técnico responsável: "}, resp.name }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   tab[#tab+1] = { "-", " " }
   lft[#lft+1] = render_table( tab, nil, "tab_cadre_grid" )



   tab = {}
   state = h.ss_current_state
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Status atual: "}, name_ok_warning_critical_unknown(h.ss_current_state) }
   tab[#tab+1] = { b{"Status info: "}, h.ss_output }
   tab[#tab+1] = { b{"No. de tentativas/Máximo de tentativas: "}, h.ss_current_check_attempt.."/"..h.ss_max_check_attempts }
   tab[#tab+1] = { b{"Ultima checagem: "}, h.ss_last_check }
   tab[#tab+1] = { b{"Próxima checagem: "}, h.ss_next_check }
   tab[#tab+1] = { b{"Última mudança de estado: "}, h.ss_last_state_change }
   tab[#tab+1] = { b{"Última mudança de estado tipo 'HARD': "}, h.ss_last_hard_state_change }
   if h.ss_is_flapping == 1 then state = 2 else state = h.ss_is_flapping end
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Está flapping: "}, name_yes_no(h.ss_is_flapping) }
   tab[#tab+1] = { b{"Último status tipo 'HARD': "}, name_ok_warning_critical_unknown(h.ss_last_hard_state) }
   tab[#tab+1] = { b{"Tempo entre checagens: "}, h.ss_normal_check_interval.."min" }
   tab[#tab+1] = { b{"Tempo entre checagens após falha: "}, h.ss_retry_check_interval.."min" }
   tab[#tab+1] = { b{"Output completo: "}, h.ss_long_output }
   tab[#tab+1] = { b{"Dados de performance: "}, h.ss_perfdata }
   tab[#tab+1] = { b{"Latência: "}, h.ss_latency.."ms" }

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

   local header = { "Data e hora", "usec", "Houve Mudança", "Estado Atual", "Tipo", "Último Estado", "Últimpo HARD", "Output"}
   if H then
      res[#res+1] = { "COUNT : " ..obj_id}
      res[#res+1] = { "COUNT : "..#H }
      for i,v in ipairs(H) do
         row[#row+1] = { v.state_time, v.state_time_usec, name_yes_no(v.state_change), 
                         name_ok_warning_critical_unknown(v.state), name_soft_hard(v.state_type), 
                         name_ok_warning_critical_unknown(v.last_state), name_ok_warning_critical_unknown(v.last_hard_state), 
                         v.output }

      end
   else
      res[#res+1] = { "HISTORY : "..obj_id }
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


function render_cmdb(web, obj_id, A)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

--[[
<iframe src="html_intro.asp" width="100%" height="300">
  <p>Your browser does not support iframes.</p>
</iframe>
]]

   web.prefix = "/servdesk"
   local url = web:link("/front/computer.form.php?id=78")

   res[#res+1] = iframe{ src=url, width="100%", height="100%", frameborder="0", "---" }


   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


