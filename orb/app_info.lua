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

   local A = Monitor.make_query_5(nil, "o.object_id = "..obj_id)

   if tab == 1 then
      local APPS = Monitor.make_query_5(nil,
                      "ax.id in (select app_id from itvision_app_objects where service_object_id = "..obj_id..")", true) 
      return render_info(web, obj_id, A, APPS)
   elseif tab == 2 then
      local H = statehistory:select(obj_id)
      return render_history(web, obj_id, A, H)
   elseif tab == 4 then
      return render_data(web, obj_id, A)
   end
end
ITvision:dispatch_get(info, "/(%d+):(%d+)")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_info(web, obj_id, A, APPS)
   local permission, auth = Auth.check_permission(web, "application")
   local a = A[1]
   local res = {}
   local row = {}
   local tab = {}
   local lft, rgt = {}, {}
   local state

   web.prefix="/obj_info"
   local lnkgeo = web:link("/geotag/hst:"..obj_id)
   local lnkedt = web:link("/geotag/hst:"..obj_id)
   web.prefix="/app_info"
   local header = { "APLICAÇÃO", "RESULTADO DA CHECAGEM" }

   --DEBUG: res[#res+1] = { "COUNT : " ..obj_id.." : "..#A}

   tab = {}
   tab[#tab+1] = { b{"Nome: "}, a.ax_name }
   local ent = entities:select(a.c_entities_id)
   tab[#tab+1] = { b{"Entidade: "}, ent.name }
   tab[#tab+1] = { b{"Tipo: "}, name_app_ent(a.ax_is_entity_root) }
   tab[#tab+1] = { b{"Está ativo: "}, name_yes_no(a.ax_is_active) }
   --tab[#tab+1] = { b{"Classe: "}, ax.app_type_id }
   tab[#tab+1] = { b{"Lógica: "}, name_and_or(a.ax_type) }
   tab[#tab+1] = { b{"Visibilidade: "}, name_private_public(a.ax_visibility) }
   -- deveria ser implementado um responsavel
   --local resp = users:select(a.c_users_id_tech)
   --tab[#tab+1] = { b{"Técnico responsável: "}, resp.name }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   tab[#tab+1] = { ".", " " }
   lft[#lft+1] = render_table( tab, nil, "tab_cadre_grid" )



   tab = {}
   if tonumber(a.ax_is_active) == 0 then
      state = APPLIC_DISABLE
   else
      state = a.ss_current_state
   end

   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Status atual: "}, name_ok_warning_critical_unknown(state) }
   tab[#tab+1] = { b{"Status info: "}, a.ss_output }
   tab[#tab+1] = { b{"No. de tentativas/Máximo de tentativas: "}, a.ss_current_check_attempt.."/"..a.ss_max_check_attempts }
   tab[#tab+1] = { b{"Ultima checagem: "}, string.extract_datetime(a.ss_last_check) }
   tab[#tab+1] = { b{"Próxima checagem: "}, string.extract_datetime(a.ss_next_check) }
   tab[#tab+1] = { b{"Última mudança de estado: "}, string.extract_datetime(a.ss_last_state_change) }
   tab[#tab+1] = { b{"Última mudança de estado tipo 'HARD': "}, string.extract_datetime(a.ss_last_hard_state_change) }
   if a.ss_is_flapping == 1 then state = 2 else state = a.ss_is_flapping end
   tab[#tab+1] = { status={ state=state, colnumber=2, nolightcolor=true}, b{"Está flapping: "}, name_yes_no(a.ss_is_flapping) }
   tab[#tab+1] = { b{"Último status tipo 'HARD': "}, name_ok_warning_critical_unknown(a.ss_last_hard_state) }
   tab[#tab+1] = { b{"Tempo entre checagens: "}, a.ss_normal_check_interval.."min" }
   tab[#tab+1] = { b{"Tempo entre checagens após falha: "}, a.ss_retry_check_interval.."min" }
   tab[#tab+1] = { b{"Output completo: "}, a.ss_long_output }
   tab[#tab+1] = { b{"Dados de performance: "}, a.ss_perfdata }
   tab[#tab+1] = { b{"Latência: "}, a.ss_latency.."ms" }

   rgt[#rgt+1] = render_table( tab, nil, "tab_cadre_grid" )

   row[#row+1] = {lft, rgt }
   res[#res+1] = render_table( row, header )
   res[#res+1] = { br(), br() }

   -- APLICACOES
   row = {}
   header = { "APLICAÇÕES QUE POSSUEM ESTA APLICAÇÃO", "STATUS ATUAL", "Última checagem", "Próxima checagem", "Última mudança de estado"  }


   for i, v in ipairs(APPS) do
      if tonumber(v.ax_is_active) == 0 then
         state = APPLIC_DISABLE
      else
         state = v.ss_current_state
      end

      web.prefix = "/orb/app_info"
      link = button_link(v.ax_name, web:link("/1:"..v.ax_service_object_id), "negative")
      web.prefix = "/orb/app_tabs"
      link = button_link(v.ax_name, web:link("/list/"..v.ax_id..":6"), "negative")
      row[#row+1] = { link,
                      {value=name_ok_warning_critical_unknown(state), state=state}, 
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
      row[#row+1] = { i, v, }
   end

   res[#res+1] = render_grid({ {render_table(row, nil, ""), render_map_frame(web, "hst", obj_id)} } )

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


