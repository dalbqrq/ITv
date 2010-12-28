require "Model"

local DEBUG = true
local DEBUG = false

--[[
        +------------+    +-------------------------+    +-----------------+      +----------+
        |  glpi_     |----| glpi_                   |----|  glpi_          |------|  glpi_   |
        | COMPUTER   |    |COMPUTER_SOFTWAREVERSION |    | SOFTWAREVERSION |      | SOFTWARE |
        | NET_EQUIP_ |    +-------------------------+    +-----------------+      +----------+
        +------------+                                          |
              |                                                 |
        +-------------+                                    +-----------+
        |  glpi_      |------------------------------------| itvision_ |
        | NETWORKPORT |                                    | MONITOR   |
        +-------------+                                    +-----------+
                                                                |
                                                                |
                                                           +---------------+
        +-------------+         +-------------+            | nagios_       |
        | itvision_   |---------| itvision_   |----------- | OBJECTS  .or. |
        | apps        |         | app_objects |            | SERVICES .or. |
        +-------------+         +-------------+            | SERVICESTATUS |
                                                           +---------------+


        QUERY 1 - computador/networkequip com porta sem software e sem monitor
        QUERY 2 - computador              com porta com software e sem monitor
        QUERY 3 - computador/networkequip com porta sem software e com monitor - monitoracao de host onde o service eh ping
        QUERY 4 - computador              com porta com software e com monitor - monitoracao de service 

]]


local tables = { 
--[[
   O valor dos 'aliases' é a resposta da pergunta: Qual é o campo da tabela 'name' que será usado para ligar com a tabela a 'alias'?
   Ou seja, é a chave estrangeira.
]]
   a =   { name="itvision_apps",                   ao="id", } ,
   ao =  { name="itvision_app_objects",            a="app_id", o="service_object_id" } ,
   m =   { name="itvision_monitors",               o="service_object_id", s="service_object_id", ss="service_object_id", 
                                                      n="networkequipments_id", p="networkports_id", sv="softwareversions_id" },
   o =   { name="nagios_objects",                  ao="object_id", m="object_id", s="object_id", ss="object_id" }, 
   s =   { name="nagios_services",                 ao="service_object_id", m="service_object_id", o="service_object_id", 
                                                      ss="service_object_id" },
   ss =  { name="nagios_servicestatus",            ao="service_object_id", m="service_object_id", o="service_object_id", 
                                                      s="service_object_id" },
   c =   { name="glpi_computers",                  p="id", csv="id" },
   n =   { name="glpi_networkequipments",          p="id", csv="id" },
   p =   { name="glpi_networkports",               m="id", c="items_id", n="items_id" },
   csv = { name="glpi_computers_softwareversions", c="computers_id", sv="softwareversions_id" },
   sv =  { name="glpi_softwareversions",           m="id", csv="id", sw="softwares_id" },
   sw =  { name="glpi_softwares",                  sv="id" },
}


--[[ 
   A funcao make_columns() recebe uma string com um alias de tabela ou uma tabela com aliases de tabelas e
   retorna duas strings: s, n

   - Uma (s) com a lista de colunas de uma tabale, precedida pelo alias da tabela e seguido do novo
   nome da coluna composto por: alias"_"name_coluna
   - Outra (n) somente com os supostos novos nomes para colunas que de fato nao existem. O objetivo 
   disso é criar queries em seguencia cuja lista de campos seja homogênia.
]]
function make_columns(a)
   local s, n = "", ""
   local t = {}
   local alias

   if type(a) == "string" then
      table.insert(t, a)
   else 
      t = a
   end
  
   for _, alias in ipairs(t) do
      local q = show_columns(tables[alias].name)

      for _,f in pairs(q) do
         --DEBUG: print(f.Field, f.Key)
         local spc = ""
         if s ~= "" then 
            s = s..",\n"
            n = n..",\n"
         end

         for c = 1,36-string.len(f.Field)-string.len(alias) do spc = spc.." " end
         s = s.."   "..alias.."."..f.Field..spc.."as "..alias.."_"..f.Field --.."\n"
         --n = n.."   ''                                   as "..alias.."_"..f.Field --.."\n"
         n = n.."   null                                 as "..alias.."_"..f.Field --.."\n"
      end
   end

   return s, n
end



function make_columns_code()
   local r = ""

   for alias,t in pairs(tables) do
      local s, n = "", ""

      s = "-- "..t.name.." as "..alias.."\n"
      s = s.."local cols_"..t.name.." {\n"
      n = "local null_"..t.name.." {\n"

      make_columns(alias)

      s = s.."}\n\n"
      n = n.."}\n\n"
      r = r..n..s
   end

   return r
end


function make_tables(a)
   local s = ""
   local t = {}

   if type(a) == "string" then
      table.insert(t, a)
   else 
      t = a
   end

   for _, alias in ipairs(t) do
      if s ~= "" then s = s..",\n" end
      s = s.."   "..tables[alias].name.." "..alias
   end

   return s
end


--[[ a -> tabela com dois ou mais  aliases de nomes de tabela ]]
function make_where(a)
   local w = ""
   local i, j
   local t = a

   if type(t) ~= "table" and #t < 2 then
      return ""
   end

   for i = 1,#t-1 do
      for j = 2,#t do
         m, n = t[i], t[j]
         local from, to = tables[m][n], tables[n][m]
         if from and to then 
            if w ~= "" then w = w.." and\n" end
            w = w.."   "..m.."."..from.." = "..n.."."..to
         end
      end
   end

   return w
end



--[[ a -> string ou tabela com os aliases de nomes de tabela ]]
function make_quer_generaly(a)
   local t = {}

   if type(a) == "string" then
      table.insert(t, a)
   else 
      t = a
   end

   local columns_ = make_columns(t)
   local tables_  = make_tables(t)
   local cond_    = make_where(t)

   return "\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n"
end


--[[
        +-------------+    +-------------------------+    +-----------------+      +----------+
        | COMPUTER ou |----|COMPUTER_SOFTWAREVERSION |----| SOFTWAREVERSION |------| SOFTWARE |
        | NET_EQUIPM. |    +-------------------------+    +-----------------+      +----------+
        +-------------+                                         |
              |                                                 |
        +-------------+                                    +-----------+
        | NETWORKPORT |------------------------------------| MONITOR   |
        +-------------+                                    +-----------+
                                                                |
                                                           +---------------+
        +-------------+         +-------------+            | OBJECTS  .or. |
        | apps        |---------| app_objects |------------| SERVICES .or. |
        +-------------+         +-------------+            | SERVICESTATUS |
                                                           +---------------+
        QUERY 1 - computador/networkequip com porta sem software e sem monitor
        QUERY 2 - computador              com porta com software e sem monitor
        QUERY 3 - computador/networkequip com porta sem software e com monitor - monitoracao de host onde o service eh ping
        QUERY 4 - computador              com porta com software e com monitor - monitoracao de service 

]]

local g_excludes = [[ and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1 ]]

----------------------------------------------------------------------
--  QUERY 1 - computador com porta sem software e sem monitor
----------------------------------------------------------------------
function make_query_1(c_id, p_id, clause)
   local q = {}
   local ictype, it = { "c", "n" }, ""

   for _,ic in ipairs(ictype) do
      local r = {}
      local t = { ic, "p" }
      local n = { "csv", "sv", "sw", "o", "s", "m", "ss" }

      local columns_ = make_columns(t)
      local _,nulls_ = make_columns(n)
      local tables_  = make_tables(t)
      local cond_    = make_where(t)

      -- os nomes dos campos tanto de computers como os de networkequipment comecam com c_
      if ic == "n" then 
         columns_ = string.gsub(columns_, "as n_", "as c_") 
         excludes = string.gsub(g_excludes, "c%.", "n.")
         if clause then clause = string.gsub(clause, "c%.", "n.") end
         it = "'NetworkEquipment'"
      else 
         excludes = g_excludes
         it = "'Computer'"
      end 

      cond_ = cond_ .. [[ 
         and p.itemtype = ]]..it..[[
         and not exists (select 1 from itvision_monitors m2 where m2.networkports_id = p.id)
      ]] .. excludes

      columns_ = columns_..",\n"..nulls_

      if c_id  then cond_ = cond_ .. " and "..ic..".id = "  .. c_id  end
      if p_id  then cond_ = cond_ .. " and p.id = "  .. p_id  end
      if clause then cond_ = cond_ .. " and " .. clause end

      r = Model.query(tables_, cond_, nil, columns_)
      for _,v in ipairs(r) do table.insert(v, 1, 1) end
      for _,v in ipairs(r) do table.insert(q, v) end

      --if DEBUG then print ("\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end
   end

   return q
end


----------------------------------------------------------------------
--  QUERY 1+1/2 - computador com porta sem software e sem monitor
----------------------------------------------------------------------
function make_query_112(c_id, p_id, clause)
   local q = {}
   local ictype, it = { "c", "n" }, ""

   for _,ic in ipairs(ictype) do
      local r = {}
      local t = { ic, "p", "m" }
      local n = { "csv", "sv", "sw", "o", "s", "ss" }

      local columns_ = make_columns(t)
      local _,nulls_ = make_columns(n)
      local tables_  = make_tables(t)
      local cond_    = make_where(t)

      -- os nomes dos campos tanto de computers como os de networkequipment comecam com c_
      if ic == "n" then 
         columns_ = string.gsub(columns_, "as n_", "as c_") 
         excludes = string.gsub(g_excludes, "c%.", "n.")
         if clause then clause = string.gsub(clause, "c%.", "n.") end
         it = "'NetworkEquipment'"
      else 
         excludes = g_excludes
         it = "'Computer'"
      end 

      cond_ = cond_ .. [[ 
         and p.itemtype = ]]..it..[[
         and m.service_object_id = -1
      ]] .. excludes

      columns_ = columns_..",\n"..nulls_

      if c_id  then cond_ = cond_ .. " and "..ic..".id = "  .. c_id  end
      if p_id  then cond_ = cond_ .. " and p.id = "  .. p_id  end
      if clause then cond_ = cond_ .. " and " .. clause end

      r = Model.query(tables_, cond_, nil, columns_)
      for _,v in ipairs(r) do table.insert(v, 1, 1) end
      for _,v in ipairs(r) do table.insert(q, v) end

      --if DEBUG then print ("\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end
   end

   return q
end


----------------------------------------------------------------------
--  QUERY 2 - computador com porta com software e sem monitor
----------------------------------------------------------------------
function make_query_2(c_id, p_id, sv_id, clause)
   local q = {}
   t = { "c", "p", "csv", "sv", "sw" }
   n = { "o", "s", "m", "ss" }

   local columns_ = make_columns(t)
   local _,nulls_ = make_columns(n)
   local tables_  = make_tables(t)
   local cond_    = make_where(t)

   cond_ = cond_ .. [[ 
      and p.itemtype = "Computer" 
      and not exists (select 1 from itvision_monitors m2 where m2.networkports_id = p.id and m2.softwareversions_id = sv.id)
   ]] .. g_excludes

   columns_ = columns_..",\n"..nulls_

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if p_id  then cond_ = cond_ .. " and p.id = "  .. p_id  end
   if sv_id then cond_ = cond_ .. " and sv.id = " .. sv_id end
   if clause  then cond_ = cond_ .. " and " .. clause end

   q = Model.query(tables_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 2) end

   --if DEBUG then print( "\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end

   return q
end


----------------------------------------------------------------------
--  QUERY 3 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping
----------------------------------------------------------------------
function make_query_3(c_id, p_id, a_id, clause)
   local q, t = {}, {}
   local ictype, it = { "c", "n" }, ""

   for _,ic in ipairs(ictype) do
      local r = {}
      if a_id then
          t = { ic, "p", "o", "s", "m", "ss", "a", "ao" }
      else
          t = { ic, "p", "o", "s", "m", "ss" }
      end
      local n = { "csv", "sv", "sw" }

      local columns_ = make_columns(t)
      local _,nulls_ = make_columns(n)
      local tables_  = make_tables(t)
      local cond_    = make_where(t)

      -- os nomes dos campos tanto de computers como os de networkequipment comecam com c_
      if ic == "n" then 
         columns_ = string.gsub(columns_, "as n_", "as c_") 
         excludes = string.gsub(g_excludes, "c%.", "n.")
         if clause then clause = string.gsub(clause, "c%.", "n.") end
         it = "'NetworkEquipment'"
      else 
         excludes = g_excludes
         it = "'Computer'"
      end 

      cond_ = cond_ .. [[ 
         and p.itemtype = ]]..it..[[
         and m.softwareversions_id is null
      ]] .. excludes

      columns_ = columns_..",\n"..nulls_

      if c_id  then cond_ = cond_ .. " and "..ic..".id = "  .. c_id  end
      if p_id  then cond_ = cond_ .. " and p.id = "  .. p_id  end
      if a_id then cond_ = cond_ .. " and a.id = " .. a_id end
      if clause  then cond_ = cond_ .. " and " .. clause end

      r = Model.query(tables_, cond_, nil, columns_)
      for _,v in ipairs(r) do table.insert(v, 1, 3) end
      for _,v in ipairs(r) do table.insert(q, v) end

      --if DEBUG then print ("\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end
   end

   return q
end


----------------------------------------------------------------------
--  QUERY 4 - computador com porta com software e com monitor - monitoracao de service 
----------------------------------------------------------------------
function make_query_4(c_id, p_id, sv_id, a_id, clause)
   local q, t = {}, {}
   if a_id then
       t = { "c", "p", "csv", "sv", "sw", "o", "s", "m", "ss", "a", "ao" }
   else
       t = { "c", "p", "csv", "sv", "sw", "o", "s", "m", "ss" }
   end
   n = { }

   local columns_ = make_columns(t)
   local tables_  = make_tables(t)
   local cond_    = make_where(t)

   cond_ = cond_ .. [[ 
      and p.itemtype = "Computer" 
   ]] .. g_excludes

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if p_id  then cond_ = cond_ .. " and p.id = "  .. p_id  end
   if sv_id then cond_ = cond_ .. " and sv.id = " .. sv_id end
   if a_id then cond_ = cond_ .. " and a.id = " .. a_id end
   if clause  then cond_ = cond_ .. " and " .. clause end

   q = Model.query(tables_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 4) end

   --if DEBUG then print( "\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end

   return q
end




----------------------------------------------------------------------
--  QUERY 5 - aplicacao com monitor - monitoracao de service 
----------------------------------------------------------------------
function make_query_5(a_id, clause)
   local q, t = {}, {}
   t = { "o", "s", "ss", "a", "ao" }
   n = { "c", "p", "m", "csv", "sv", "sw" }

   local columns_ = make_columns(t)
   local _,nulls_ = make_columns(n)
   local tables_  = make_tables(t)
   local cond_    = make_where(t)

   cond_ = cond_ .. [[ 
      and o.name1 = ']]..config.monitor.check_app..[[' 
   ]]

   if a_id then cond_ = cond_ .. " and a.id = " .. a_id end
   if clause then cond_ = cond_ .. " and " .. clause end

   q = Model.query(tables_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 5) end

   --if DEBUG then print( "\nselect\n"..columns_.."\nfrom\n"..tables_.."\nwhere\n"..cond_.."\n") end

   return q
end




----------------------------------------------------------------------
--  END of the QUERIES
----------------------------------------------------------------------

-- A FUNCAO ABAIXO JUNTA O RESULTADO DE TODAS AS QUERIES (1 à 6) EM UM UNICO RESULT SET

function select_monitors(clause)
   local q = {}
   local q1 = make_query_1(nil, nil, clause)
   local q112 = make_query_112(nil, nil, clause)
   local q2 = make_query_2(nil, nil, nil, clause)
   local q3 = make_query_3(nil, nil, nil, clause)
   local q4 = make_query_4(nil, nil, nil, nil, clause)

   for _,v in ipairs(q1) do table.insert(q, v) end
   for _,v in ipairs(q112) do table.insert(q, v) end
   for _,v in ipairs(q2) do table.insert(q, v) end
   for _,v in ipairs(q3) do table.insert(q, v) end
   for _,v in ipairs(q4) do table.insert(q, v) end

   table.sort(q, function (a, b) 
      a.c_name  = a.c_name  or ""
      a.p_ip    = a.p_ip    or ""
      a.sw_name = a.sw_name or ""
      a.sv_name = a.sv_name or ""
      b.c_name  = b.c_name  or ""
      b.p_ip    = b.p_ip    or ""
      b.sw_name = b.sw_name or ""
      b.sv_name = b.sv_name or ""
      return a.c_name..a.p_ip..a.sw_name..a.sv_name < b.c_name..b.p_ip..b.sw_name..b.sv_name  end )

   return q
end


function select_monitors_app_objs(app_id, clause)
   local q = {}

   local q3 = make_query_3(nil, nil, app_id, clause)
   local q4 = make_query_4(nil, nil, nil, app_id, clause)
   local q5 = make_query_5(app_id, clause)

   for _,v in ipairs(q3) do table.insert(q, v) end
   for _,v in ipairs(q4) do table.insert(q, v) end
   for _,v in ipairs(q5) do table.insert(q, v) end

   table.sort(q, function (a, b) 
      a.c_name  = a.c_name  or ""
      a.p_ip    = a.p_ip    or ""
      a.sw_name = a.sw_name or ""
      a.sv_name = a.sv_name or ""
      b.c_name  = b.c_name  or ""
      b.p_ip    = b.p_ip    or ""
      b.sw_name = b.sw_name or ""
      b.sv_name = b.sv_name or ""
      return a.c_name..a.p_ip..a.sw_name..a.sv_name < b.c_name..b.p_ip..b.sw_name..b.sv_name  end )

   return q
end


function tree(app_id, show_svc)
   local q = {}
   local clause = nil

   if show_svc ~= true then
      clause = "ao.type = 'hst'"
   end

   local q3 = make_query_3(nil, nil, app_id, clause)
   local q4 = make_query_4(nil, nil, nil, app_id, clause)
   for _,v in ipairs(q3) do table.insert(q, v) end
   for _,v in ipairs(q4) do table.insert(q, v) end

   local q5 = make_query_5(app_id, nil)
   for _,v in ipairs(q5) do 
      local content = Model.query("itvision_apps", "service_object_id = "..v.ao_service_object_id)
      local q_ = tree(content[1].id, show_svc)
      for _,v in ipairs(q_) do table.insert(q, v) end
   end

   return q
end




--[[ Funcao para mostrar como usar este modulo: ]]
function how_to_use()
   local a, b = {}, {}
--[[
   erint(make_where("a", "ao"))
   print(make_where("m", "sv"))
   print(make_where("sv", "sw"))
   print(make_where("m", "p"))
   print(make_where("p", "m"))
   print(make_where("m", "ss"))
   print(make_where("m", "n"))
   print(make_where("m", "sw"))

   a = make_columns({"a", "ao"})
   a = make_where({"a", "ao"})
   a = make_tables({"a", "ao"})
   a = make_query_general({"a", "ao", "o", "m", })
   a = make_query_1()
   a = make_query_2()
   a = make_query_4()
   a = make_query_2(1,1,2)
   a = make_query_3(nil, nil, nil, "m.service_object_id = 181")
   a = make_query_4()
   a = make_query_3()
   if type(a) == "string" then print(a) end
   print("count: ", table.getn(a))
   for i,v in ipairs(a) do 
      print("A: ",table.getn(a), v.c_name, v.s_name, v.sv_name, v.p_itemtype) 
   end

   for i,v in ipairs(a) do
      print("Q: ",table.getn(a), v.c_name, v.p_itemtype) 
   end
]]

--[[
   print("========================")
   a = select_monitors_app_objs(8)

   for i,v in ipairs(a) do
      print("A: ",table.getn(a), v.c_name, v.s_name, v.sv_name, v.p_itemtype, v.ao_type) 
   end

   a = make_query_5(5)
   if type(a) == "string" then print(a) end
   print("count: ", table.getn(a))
   for i,v in ipairs(a) do 
      print("A: ",v.ao_type, v.ao_service_object_id, v.a_id, v.a_name, v.o_name1, v.o_name2, v.ss_current_state) 
   end
]]

   --a = tree(8)

   --a = make_query_1()
   --a = make_query_2()
   --a = make_query_3()
   --a = make_query_4()

   a = make_query_112()
   a = select_monitors()

   for i,v in ipairs(a) do
      print("A: ",table.getn(a), v.c_name, v.s_name, v.sv_name, v.p_itemtype, v.ao_type, v.c_geotag, v.m_service_object_id) 
   end


end

if DEBUG then how_to_use() end

