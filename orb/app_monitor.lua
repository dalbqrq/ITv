#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "View"
require "Resume"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)

local objects  = Model.nagios:model "objects"
local monitors = Model.itvision:model "monitors"
local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

function apps:select_apps(id, clause_)
   local q = {}
   local clause = " is_active = 1"
   if id then clause = clause.." and  id = "..id end
   if clause_ then clause = clause.." and "..clause_ end

   q[1] = { id = 0, name = strings.all }
   q2 = Model.query("itvision_apps", clause, "order by id")

   for _,v in ipairs(q2) do table.insert(q, v) end

   return q
end


function objects:select(name1, name2)
   local clause = ""
   if name1 ~= nil then
      clause = " name1 = '"..name1.."'"
   else
      clause = " name1 like '"..config.monitor.check_app.."%'"
   end

   if name2 ~= nil then
      clause = clause.." and name2 = '"..name2.."'"
   else
      clause = clause.." and name2 is NULL"
   end
   clause = clause .. " and is_active = 1"

   return Model.query("nagios_objects", clause)
end


function objects:select_host(name1)
   local clause = ""
   if name1 ~= nil then
      clause = " o.name1 = '"..name1.."'"
   else
      clause = " o.name1 like '"..config.monitor.check_app.."%' "
   end

   clause = clause .. " and objecttype_id = 1 and o.name2 is null and o.is_active = 1"

   return Model.query("nagios_objects o", clause)
end


-- controllers ------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

function pre_list(web, msg)
   local hostname, tipo

   if web.input.hostname ~= "" and web.input.hostname ~= nil and web.input.hostname ~= "all" then 
      hostname = web.input.hostname
   else
      hostname = "all"
   end
   if web.input.tipo ~= "" and web.input.tipo ~= nil then
      tipo = web.input.tipo
   else
      tipo = "all"
   end
   if web.input.app ~= "" and web.input.app ~= nil then
      app = web.input.app
   else
      app = "0"
   end
   if web.input.status ~= "" and web.input.status ~= nil then
      status = web.input.status
   else
      status = "-1"
   end

   return web:redirect(web:link("/"..hostname..":"..tipo..":"..app..":"..status))
end
ITvision:dispatch_get(pre_list, "/", "/pre_list", "/pre_list/(.+)")
ITvision:dispatch_post(pre_list, "/pre_list", "/pre_list/(.+)")



function list(web, hostname, tipo, app, status)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   local filter = { hostname = hostname, tipo = tipo, app = app, status = status }
   local clause, clause34, clause5 = nil, "", ""

   -- Filtro de hostname
   if filter.hostname ~= "" and filter.hostname ~= nil and filter.hostname ~= "all" then 
      clause34 = "and (c.name like '%"..filter.hostname.."%' or c.alias like '%"..filter.hostname.."%' or c.itv_key like '%"..filter.hostname.."%')"
      clause5 = "and c.name like '%"..filter.hostname.."%' "
   end
   -- Filtro de tipo
   if filter.tipo ~= "" and filter.tipo ~= nil then 
      if filter.tipo == 'hst' then
         local a = ""
         if clause then a = " and " else clause = ""  end
         clause = clause..a.."o.name2 = '"..config.monitor.check_host.."' and o.objecttype_id = 2"
      elseif filter.tipo == 'svc' then
         local a = ""
         if clause then a = " and " else clause = ""  end
         clause = clause..a.."o.name2 <> '"..config.monitor.check_host.."' and o.name1 <> '"..config.monitor.check_app.."' and o.objecttype_id = 2"
      elseif filter.tipo == 'app' then
         local a = ""
         if clause then a = " and " else clause = ""  end
         clause = clause..a.."o.name1 = '".. config.monitor.check_app.."' and o.objecttype_id = 2"  
         clause5 = clause5.." and ax.is_entity_root = 0"
      elseif filter.tipo == 'ent' then
         local a = ""
         if clause then a = " and " else clause = ""  end
         clause = clause..a.."o.name1 = '".. config.monitor.check_app.."' and o.objecttype_id = 2"  
         clause5 = clause5.." and ax.is_entity_root = 1"
      end
   end
   -- Filtro de app
   if filter.app ~= "" and filter.app ~= nil and filter.app ~= "0" then 
      app = filter.app
   else
      app = nil
   end
   -- Filtro de staus
   if filter.status ~= "" and filter.status ~= nil and filter.status ~= "-1" then 
      local a = ""
      if clause then a = " and " else clause = ""  end
      if tonumber(filter.status) == APPLIC_DISABLE then
         clause = clause..a.."ss.active_checks_enabled = 0"
      else
         clause = clause..a.."ss.current_state = ".. filter.status.." and ss.active_checks_enabled = 1"
      end
   end

   local a = ""
   if clause then a = " and " else clause = "" end
   clause = clause..a.." p.entities_id in "..Auth.make_entity_clause(auth)

   local ics = Monitor.select_monitors_app_objs(app, clause, clause34, clause5)

   return render_list(web, ics, filter)
end
--ITvision:dispatch_get(list, "/(%a+):(%a+):(%d+)", "/list/(%a+):(%a+):(%d+)", "/list/(%a+):(%a+):(%d+):(.+)")
--ITvision:dispatch_post(list, "/list/(%a+):(%a+):(%d+)", "/list/(%a+):(%a+):(%d+):(.+)")
ITvision:dispatch_get(list, "/(.+):(.+):(.+):(.+)", "/list/(.+):(.+):(.+):(.+)")
ITvision:dispatch_post(list, "/(.+):(.+):(.+):(.+)")




-- views ------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
function render_filter(web, filter)
   local res = {}

   if filter.hostname == "all" then filter.hostname = "" end

   res[#res+1] = {strings.name..": ", input{ type="text", name="hostname", value = filter.hostname }, " "}
   res[#res+1] = {strings.type..": ", select_hst_svc_app("tipo", filter.tipo), " "}
   res[#res+1] = {strings.application..": ", select_option("app", apps:select_apps(), "id", "name", filter.app), " " }
   res[#res+1] = {strings.status..": ", select_ok_warning_critical_unknown("status", filter.status), " "}

   return res
end



---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
function render_list(web, ics, filter, msg)
   local permission, auth = Auth.check_permission(web, "checkcmds")
   local row, res, link, url, output = {}, {}, {}, "", ""
   local refresh_time = 60

   local header = { 
      strings.alias.."/"..strings.name, strings.status, "IP", "CHECAGEM", strings.type, "."
   }


   for i, v in ipairs(ics) do
      local probe = v.m_name
      local serv, ip, itemtype, id, hst_name, alias = "", "", "", "", nil, nil
      if v.sw_name ~= "" and v.sv_name ~= nil then serv = v.sw_name.." / "..v.sv_name end

      -- muitos dos ifs abaixo existem em funcao da direrenca entre as queries com Computer e as com Network
      v.c_id = v.c_id or 0 v.n_id = v.n_id or 0 v.p_id = v.p_id or 0 v.sv_id = v.sv_id or 0
      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      -- DEBUG: if hst_name == nil then hst_name = v.a_name.." ["..v.a_id..":"..v.o_object_id.."]" end
      if hst_name == nil then hst_name = v.ax_name end
      alias = v.m_name

      if v.p_itemtype then 
         itemtype = v.p_itemtype 
      else 
         if v.ax_is_entity_root == "1" then 
            itemtype = strings.entity 
         else 
            itemtype = strings.application 
         end
      end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_id ~= 0 then c_id = v.c_id else c_id = v.n_id end

      if v.s_check_command_object_id == nil then 
         if permission == "w" then
            if tonumber(v.m_service_object_id) == -1 then
               link = font{ color="orange", "Pendente" }
            elseif serv ~= "" then
               link = a{ href= web:link("/add/"..v[1]..":"..c_id..":"..v.p_id..":"..v.sv_id), strings.add }
            else
               link = a{ href= web:link("/insert_host/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"
                                         ..hst_name..":"..ip), strings.add.." host" }
            end
         else
            link = "--"
         end
      else
         link = "--"
      end

      if probe == nil then
         web.prefix = "/orb/app_tabs"
         url = web:link("/list/"..v.ax_id..":6")
         probe = ""
      else if probe ~= config.monitor.check_host and probe ~=  "" then
         web.prefix = "/orb/obj_info"
         url = web:link("/svc/"..v.m_service_object_id)
         itemtype = strings.service
      else 
         web.prefix = "/orb/obj_info"
         url = web:link("/hst/"..v.m_service_object_id)
      end

      end
      web.prefix = "/orb/app_monitor"

      local name
      if permission == "w" then
         name = a{ href=url, hst_name}
      else
         name = hst_name
      end

      local state
      if tonumber(v.ss_has_been_checked) == 1 then
         if tonumber(v.m_state) == 0 then
            state = tonumber(APPLIC_DISABLE)
            output = ""
         else
            state = tonumber(v.ss_current_state)
            output = v.ss_output
         end

      else
         state = 4
      end
      local statename = applic_alert[state].name
      row[#row + 1] = { status={ state=state, colnumber=2 }, name, statename, ip, probe, itemtype, output }
      --row[#row + 1] = { name, { value=statename, state=state }, ip, probe, itemtype, output }
   end


   res[#res+1] = render_resume(web)
   res[#res+1] = render_content_header(auth, "Monitoração", nil, web:link("/pre_list"))
   --DEBUG: msg = filter.status.." | "..APPLIC_DISABLE; res[#res+1] = p{ font{ color="red", msg } }
   res[#res+1] = render_form_bar( render_filter(web, filter), strings.search, web:link("/pre_list"), web:link("/pre_list") )
   res[#res+1] = render_table(row, header)
   res[#res+1] = { br(), br(), br(), br() }

   return render_layout(res, refresh_time)
end


orbit.htmlify(ITvision, "render_.+")

return _M


