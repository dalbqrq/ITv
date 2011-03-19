local conf = require "config"

----------------------------- MESSAGE ----------------------------------

local strgs = {}
strgs.pt_BR = {
	no = "Não",
	yes = "Sim",
	ofthe = "do(a)",
	logical_and = "E",
	logical_or = "Ou",
	user_group_name = "Nome do grupo",
	host = "Servidor",
	service = "Serviço",
	application = "Aplicação",
	type = "Tipo",
	show = "Mostrar",
	list = "Listar",
	add = "Adicionar",
	edit = "Editar",
	remove = "Remover",
	send = "Enviar",
	reset = "Resetar",
	cancel = "Cancelar",
	login = "Login",
	user = "Usuário",
	name = "Nome",
	group = "Grupo",
	password = "Senha",
	exclude_quest = "Voce tem certeza que deseja excluir a/o ",
	manufacturer = "Fabricante",
	company = "Empresa",
	begins = "Início",
	ends = "Fim",
	description = "Descrição",
	contract = "Contrato",
	object = "Objeto",
	app_relat_type = "Tipo de relacionamento de aplicação",
	app_relat = "Relacionamentos",
	app_object = "Objetos",
	app_tree = "Árvore",
	relation = "Relacionamento",
        version = "Versão",
        created = "Criado",
        update = "Atualizar",
        updated = "Atualizado",
        home_dir = "home_dir",
        monitor_dir = "monitor_dir",
        monitor_bp_dir = "monitor_bp_dir",
	child_of = "Filho de",
	is_active = "Ativo",
	service = "Serviço",
	all = "Todos(as)",
	root = "Raiz",
	location = "Localização",
	physical = "Físico",
	logical = "Lógico",	
	origin = "Origem",	
	destiny = "Destino",	
	category = "Categoria",	
	sonof = "filho de",	
	parent = "Pai",	
	command = "Comando",	
	alias = "Alias",	
	activate = "Ativar",	
	deactivate = "Desativar",	
	inventory = "Inventário",	
	sn = "Número Serial",
	search = "Pesquisar",
	value = "Valor",
	parameter = "Parametro",
	test = "Testar",
	wait = "Por favor aguarde...", 
	fillall = "Por favor preencha todos os parametros.", 

}

strgs.us = {
	no = "No",
	yes = "Yes",
	ofthe = "of the",
	logical_and = "And",
	logical_or = "Or",
	user_group_name = "Group name",
	host = "Host",
	service = "Service",
	application = "Application",
	type = "Type",
	show = "Show",
	list = "List",
	add = "Add",
	edit = "Edit",
	remove = "Remove",
	send = "Send",
	reset = "Reset",
	cancel = "Cancel",
	login = "Login",
	user = "User",
	name = "Name",
	group = "Group",
	password = "Password",
	exclude_quest = "Are you sure you want to remove the ",
	manufacturer = "Manufacturer",
	company = "Company",
	begins = "Begin",
	ends = "End",
	description = "Description",
	contract = "Contract",
	object = "Object",
	app_relat_type = "Relation type",
	app_relat = "Relatioships",
	app_object = "Objects",
	app_tree = "Tree",
	relation = "Relation",
        version = "Version",
        created = "Created",
        updated = "Update",
        updated = "Updated",
        home_dir = "home_dir",
        monitor_dir = "monitor_dir",
        monitor_bp_dir = "monitor_bp_dir",
	child_of = "Child of",
	is_active = "Is active",
	service = "Service",
	all = "All",
	root = "Root",
	location = "Location",
	physical = "Physical",
	logical = "Logiclo",	
	origin = "Origin",
	destiny = "Destiny",
	category = "Category",
	sonof = "son of",
	parent = "Parent",
	command = "Command",
	alias = "Alias",	
	activate = "Activate",	
	deactivate = "Deactivate",	
	inventory = "Inventory",	
	sn = "Serial Number",
	search = "Search",
	value = "Value",
	parameter = "Parameter",
	test = "Test",
	wait = "Please wait...", 
	fillall = "Please fill all parameters.", 
}


strings = strgs[config.language]

----------------------------- ERROR MESSAGE ----------------------------------
local err_msg = {} 
err_msg.pt_BR = {
	[1] = "ERRO: Origen não encontrada.",
	[2] = "ERRO: Aplicação inserida na árvore de aplicações.",
	[3] = "ERRO: Grupo de Usuário não encontrado.",
	[4] = "Preencher.",
	[5] = "Localização inserida na árvore de localizações.",
	[6] = "ERRO: Lista não encontrada.",
	[7] = "ERRO: Selecione uma 'Origem', um 'Tipo de Relacionamento' e um 'Destino'.",
	[8] = "ERRO: A conexão entre os objetos já existe.",
	[9] = "A seguinte Aplicação foi ativada:",
	[10] = "ERRO: A seguinte Aplicação não possui objetos associados:",
	[11] = "Por favor, aguarde a atualização da base de dados.",
	[12] = "ERRO: Monitoração de Service não foi incluida. Por favor entre em contato com o administrador.",
	[13] = "Usuário ou senha inválido. Logue novamente.", 
}

err_msg.us = {
	[1] = "ERROR: Unknown origin.",
	[2] = "ERROR: Application inserted on applications tree.",
	[3] = "ERROR: User Group not found.",
	[4] = "Fill this field.",
	[5] = "Local inserted on local tree.",
	[6] = "ERROR: List not found.",
	[7] = "ERROR: Select a 'Origem', a 'Relationship type' and a 'Destiny'.",
	[8] = "ERROR: The conection of the following objects already existes:",
	[9] = "The following Application was activated:",
	[10] = "ERROR: There is no objects associated with the following Application:",
	[11] = "Please, wait for the database update.",
	[12] = "ERROR: Service monitoring was not included. Please, contact the administrator.",
	[13] = "Invalid user or password. Login again.", 
}


--err_msg = err_msg[config.language]

function html_accent(str)
	local res = str
	res = string.gsub(res,"ã", "&atilde;")
	res = string.gsub(res,"õ", "&otilde;")
	res = string.gsub(res,"ç", "&ccedil;")
	res = string.gsub(res,"á", "&aacute;")
	res = string.gsub(res,"é", "&eacute;")
	res = string.gsub(res,"í", "&iacute;")
	res = string.gsub(res,"ó", "&oacute;")
	res = string.gsub(res,"ú", "&uacute;")
	res = string.gsub(res,"â", "&acirc;")
	res = string.gsub(res,"ê", "&ecirc;")
	res = string.gsub(res,"ô", "&ocirc;")
	return res
end

function error_message (idx)
	return html_accent(err_msg[conf.language][idx])
end

----------------------------- DATE ----------------------------------

months = {}

months.pt = { "Janeiro", "Fevereiro", "Março", "Abril",
    "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro",
    "Novembro", "Dezembro" }

months.en = { "January", "February", "March", "April",
    "May", "June", "July", "August", "September", "October",
    "November", "December" }

weekdays = {}

weekdays.pt = { "Domingo", "Segunda", "Terça", "Quarta",
    "Quinta", "Sexta", "Sábado" }

weekdays.en = { "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday" }

-- Utility functions

time = {}
date = {}
month = {}

local datetime_mt = { __call = function (tab, date) return tab[language](date) end }

setmetatable(time, datetime_mt)
setmetatable(date, datetime_mt)
setmetatable(month, datetime_mt)

function time.pt(date)
  local time = os.date("%H:%M", date)
  date = os.date("*t", date)
  return date.day .. " de "
    .. months.pt[date.month] .. " de " .. date.year .. " às " .. time
end

function date.pt(date)
  date = os.date("*t", date)
  return weekdays.pt[date.wday] .. ", " .. date.day .. " de "
    .. months.pt[date.month] .. " de " .. date.year
end

function month.pt(month)
  return months.pt[month.month] .. " de " .. month.year
end

local function ordinalize(number)
  if number == 1 then
    return "1st"
  elseif number == 2 then
    return "2nd"
  elseif number == 3 then
    return "3rd"
  else
    return tostring(number) .. "th"
  end
end

function time.en(date)
  local time = os.date("%H:%M", date)
  date = os.date("*t", date)
  return months.en[date.month] .. " " .. ordinalize(date.day) .. " " ..
     date.year .. " at " .. time
end

function date.en(date)
  date = os.date("*t", date)
  return weekdays.en[date.wday] .. ", " .. months.en[date.month] .. " " ..
     ordinalize(date.day) .. " " .. date.year 
end

function month.en(month)
  return months.en[month.month] .. " " .. month.year
end


