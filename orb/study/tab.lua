--[[
        +------------+    +-------------------------+    +-----------------+      +----------+
        |  glpi_     |----| glpi_                   |----|  glpi_          |------|  glpi_   |
        | COMPUTER   |    |COMPUTER_SOFTWAREVERSION |    | SOFTWAREVERSION |      | SOFTWARE |
        +------------+    +-------------------------+    +-----------------+      +----------+
              |                                                 |
              |                                                 |
        +-------------+                                    +-----------+     +------------+
        |  glpi_      |------------------------------------| itvision_ |-----|  glpi_     | 
        | NETWORKPORT |                                    | MONITOR   |     | NET_EQUIP_ |
        +-------------+                                    +-----------+     +------------+
                                                                |
                                                                |
                                                           +---------------+
        +-------------+         +-------------+            | nagios_       |
        | itvision_   |---------| itvision_   |----------- | OBJECTS  .or. |
        | apps        |         | app_objects |            | SERVICES .or. |
        +-------------+         +-------------+            | SERVICESTATUS |
                                                           +---------------+
]]

require "Model"

local tables = { 
--[[
   Interpretacao do valor dos campos 'alias'.

   O valor do alias é a resposta da pergunta: Qual é o campo da tabela 'name' que será usado para ligar com a tabela a 'alias'?
   Ou seja, é a chave estrangeira.
]]
   a =   { name="itvision_app",                    ao="id", } ,
   ao =  { name="itvision_app_object",             a="app_id", o="object_id", s="object_id", ss="object_id" } ,
   m =   { name="itvision_monitor",                o="service_object_id", s="service_object_id", ss="service_object_id", n="networkequipments_id", p="networkports_id", sv="softwareversions_id" },
   o =   { name="nagios_objects",                  ao="object_id", m="object_id", s="object_id", ss="object_id" }, 
   s =   { name="nagios_services",                 ao="service_object_id", m="service_object_id", o="service_object_id", ss="service_object_id" },
   ss =  { name="nagios_servicestatus",            ao="service_object_id", m="service_object_id", o="service_object_id", s="service_object_id" },
   c =   { name="glpi_computers",                  p="id", csv="id" },
   n =   { name="glpi_networkequipments",          m="id" },
   p =   { name="glpi_networkports",               m="id", c="item_id", n="item_id" },
   csv = { name="glpi_computers_softwareversions", c="computers_id", sw="softwareversions_id" },
   sw =  { name="glpi_softwares",                  sv="id" },
   sv =  { name="glpi_softwareversions",           m="id", csv="id", sw="softwares_id" },

--[[

- mudar nomes das tabelas:
  itvision_apps
  itvision_app_objects
  itvision_monitors

- acrescrentar campos "networkequipments_id" em itvision_monitors
- remover campo "host_object_id" de itvision_monitors
- mudar nome do campo object_id da tabela itvision_app_object para service_object_id

]]
}

function make_columns()
local r = ""

   for alias,t in pairs(tables) do
      local s, n = "", ""
      local q = show_columns(t.name)

      s = "-- "..t.name.." as "..alias.."\n"
      s = s.."local cols_"..t.name.." {\n"
      n = "local null_"..t.name.." {\n"

      for _,f in pairs(q) do
         local spc = ""
         --print(f.Field, f.Key)
         for c = 1,36-string.len(f.Field)-string.len(alias) do spc = spc.." " end
         s = s.."   "..alias.."."..f.Field..spc.."as "..alias.."_"..f.Field.."\n"
         n = n.."   ''                                   as "..alias.."_"..f.Field.."\n"
      end

      s = s.."}\n\n"
      n = n.."}\n\n"
      r = r..n..s
   end

   return r
end


function make_where(a, b)
   local from = tables[a][b]
   local to   = tables[b][a]
   from = from or "Error_From"
   to   = to   or "Error_To"
   local s = a.."."..from.." = "..b.."."..to
   return s
end

--print(make_columns())

print(make_where("a", "ao"))
print(make_where("m", "sv"))
print(make_where("sv", "sw"))
print(make_where("m", "p"))
print(make_where("p", "m"))
print(make_where("m", "ss"))
print(make_where("m", "n"))





