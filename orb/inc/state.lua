require "monitor_inc"

color = {
	blue =   "#0066ff",	-- blue color used by peding hosts and services
	green =  "#00ff33",	-- green color used by up hosts and ok services
	yellow = "#fff833",	-- yellow color used by unreachable hosts and unknown services
	orange = "#ff6600",	-- orange color used by warning services
	red =    "#d90000",	-- red color used by down hosts and critical services
	gray =   "#999999",	-- gray color used by all non problem status
	purple = "#9900CC",	-- unused
}


applic_alert = {   
	[APPLIC_UP]      = { name= "NORMAL",		status = APPLIC_UP,		color = color.green,	color_name = "green" },
	[APPLIC_DOWN]    = { name= "CRITICO", 		status = APPLIC_DOWN,		color = color.red,	color_name = "red" },
	[APPLIC_WARNING] = { name= "ANORMAL",		status = APPLIC_WARNING,	color = color.yellow,	color_name = "yellow" },
	[APPLIC_PENDING] = { name= "PENDENTE",		status = APPLIC_PENDING,	color = color.blue,	color_name = "blue" },
	[APPLIC_DISABLE] = { name= "DESABILITADO",	status = APPLIC_DISABLE,	color = color.orange,	color_name = "orange" },
}


host_alert = {   
	[HOST_UP]          = { name= "NORMAL",		status = HOST_UP,		color = color.green,	color_name = "green" },
	[HOST_DOWN]        = { name= "CRITICO", 	status = HOST_DOWN,		color = color.red,	color_name = "red" },
	[HOST_UNREACHABLE] = { name= "DESCONHECIDO",	status = HOST_UNREACHABLE,	color = color.gray,	color_name = "gray" },
	[HOST_PENDING]     = { name= "PENDENTE", 	status = HOST_PENDING,		color = color.blue,	color_name = "blue" },
	[HOST_DISABLE]     = { name= "DESABILITADO",	status = HOST_DISABLE,		color = color.orange,	color_name = "orange" }
}


service_alert = {
	[STATE_OK]       = { name= "NORMAL",		status = STATE_OK,		color = color.green,	color_name = "green" },
	[STATE_WARNING]  = { name= "ANORMAL",	 	status = STATE_WARNING,		color = color.yellow,	color_name = "yellow" },
	[STATE_CRITICAL] = { name= "CRITICO", 		status = STATE_CRITICAL,	color = color.red,	color_name = "red" },
	[STATE_UNKNOWN]  = { name= "DESCONHECIDO",	status = STATE_UNKNOWN,		color = color.gray,	color_name = "gray" },
	[STATE_PENDING]  = { name= "PENDENTE",		status = STATE_PENDING,		color = color.blue,	color_name = "blue" },
	[STATE_DISABLE]  = { name= "DESABILITADO",	status = STATE_DISABLE,		color = color.orange,	color_name = "orange" }
}

