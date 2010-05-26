module (..., package.seeall);

require "config"
require "util"
require "messages"

local dado = require "dado"
local inst = " instance_id = "..config.db.instance_id
local cond = ""

local objecttype = {
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


function connect ()
	local c = config.db
	return dado.connect (c.dbname, c.dbuser, c.dbpass, c.driver)
end


function get_bp_id () -- usado para selecionar os 'services' que sao aplicacoes
	local db = connect ()
	local content = db:selectall ("object_id", "nagios_objects", "name1 = 'check_bp_status'")
	return content[1].object_id
end


function select_columns (table_) -- Retorna tabela com nome dos campos de uma tabela sql
	local content = {}
	local cur = assert ( db:assertexec ("show columns from "..table_))
	local row = cur:fetch ({}, "a")

	while row do
		table.insert (t, row.Field)
		row = cur:fetch (row,"a")
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
end


function set_cond (cond_) -- include instance condition
	if cond_ then 
		cond = cond_.." and ".. inst 
	else 
		cond = inst 
	end
end


function select (table_, cond_, extra_, columns_)
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
	content_.instance_id = config.db.instance_id -- nao insere outras instancias
	assert ( db:insert (table_, content_))
	db:close ()
end


function update (table_, content_, cond_)
	local db = connect ()
	cond_ = set_cond (cond_)
	content_.instance_id = config.db.instance_id -- nao atualiza outras instancias
	assert ( db:update (table_, content_, cond_))
	db:close ()
end


function delete (table_, cond_)
	local db = connect ()
	local cond = set_cond (cond_)
	assert ( db:update (table_, cond_))
	db:close ()
end


function execute (stmt_)
	local db = connect ()
	assert ( db:assertexec (stmt_))
	db:close ()
end


