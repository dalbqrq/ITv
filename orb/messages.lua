require "config"

--------------------------------------
local msg = {
pt_BR = {
	[1] = "Origen não encontrada.",
	[2] = "Aplicação inserida na árvore de aplicações."
},

us = {
	[1] = "Unknown origin.",
	[2] = "Application inserted on applications tree."
}
}

--------------------------------------
local language = { 
	[1] = "pt_BR",
	[2] = "us"
}


--------------------------------------
function message (idx)
	return msg[config.lang][idx]
end


