require "util"
require "messages"

local db = Model.db
local dado = require "dado"
local inst = " instance_id = "..db.instance_id
local cond = nil

objecttype = {
   [1] = "Host",
   [2] = "Service",
   [3] = "Host group",
   [4] = "Service group",
   [5] = "Host escalation",
   [6] = "Service escalation",
   [7] = "Host dependency",
   [8] = "Service dependency",
   [9] = "Timeperiod",
   [10] = "Contact",
   [11] = "Contact group",
   [12] = "Command",
   [13] = "Extended host info (deprecated)",
   [14] = "Extended service info (deprecated)"
}


----------------------------- CONFIG ----------------------------------

function set_db (db_)
    db = db_
    inst = " instance_id = "..db_.instance_id
end


function connect ()
   return dado.connect (db.dbname, db.dbuser, db.dbpass, db.driver)
end


function show_columns (table_) -- Retorna tabela com nome dos campos de uma tabela sql
   local db = connect ()
   local content = {}
   --local cur = assert ( db:assertexec ("show columns from "..table_))
   local cur = assert ( db:assertexec ("desc "..table_))
   local row = cur:fetch ({}, "a")

   while row do
      table.insert (content, { Field=row.Field, Type=row.Type, Null=row.Null, Key=row.Key, 
                               Default=row.Default, Extra=row.Extra  } )
      row = cur:fetch (row, "a")
   end
   return content
end


----------------------------- DB ACCESS ----------------------------------

function set_instance (inst_) -- change instance to be included in condition stmt
   if inst_ then
      inst = " instance_id = "..inst_
   else
      inst = " instance_id > 0 "
   end
   return inst
end


function set_cond (cond_) -- include instance condition
   if cond_ then 
      cond = cond_.." and ".. inst 
   else 
      cond = inst 
   end
   return cond
end


--function select (table_, cond_, extra_, columns_)
function query (table_, cond_, extra_, columns_)
   local db = connect ()
   local cond = set_cond (cond_)
   if not columns_ then columns_ = "*" end
   local content = db:selectall (columns_, table_, cond_, extra_)
   db:close ()
   return content
end


function select_func (table_, cond_, extra_, columns_) -- this function return another function
   local db = connect ()
   local cond = set_cond (cond_)
   if not columns_ then columns_ = "*" end
   local content = db:selectall (columns_, table_, cond_, extra_)
   -- Exemplo de uso:
   --   for field1, field2 in content do print (field1, field2) end     
   --   print (type (t))
   db:close ()
   return content
end


function insert (table_, content_)
   local db = connect ()
   local content = {}
   if content_.instance_id then 
      --content_.instance_id = Model.db.instance_id -- nao insere outras instancias
   end
   assert ( db:insert (table_, content_))
   db:close ()
end


function update (table_, content_, cond_)
   local db = connect ()
   --cond_ = set_cond (cond_)
   if content_.instance_id then 
      --content_.instance_id = Model.db.instance_id -- nao insere outras instancias
      content_.instance_id = nil
   end
   assert ( db:update (table_, content_, cond_))
   db:close ()
end


function delete (table_, cond_)
   local db = connect ()
   local cond = set_cond (cond_)
   assert ( db:delete (table_, cond_))
   db:close ()
end


function execute (stmt_)
   local db = connect ()
   local cur = assert ( db:assertexec (stmt_))
   db:close ()
   return cur
end


----------------------------- SPECIAL OPERATIONS ----------------------------------

function insert_monitor (table_, content_)
   local db = connect ()
   if content_.instance_id then 
      content_.instance_id = Model.db.instance_id -- nao insere outras instancias
   end
   assert ( db:insert (table_, content_))

   local content = db:selectall ("max(id) as id", table_)
   
   db:close ()
   return content[1].id
end


