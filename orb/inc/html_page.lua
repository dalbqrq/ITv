
menu_itens = {
	{ 1, "Monitor", "/fig1.html" },
	{ 2, "Lógico", "/fig1.html" },
	{ 2, "Físico", "/fig2.html" },
	{ 2, "Relatórios", "/blank.html" },
	{ 2, "Árvore", "/orb/app_tree" },
	{ 2, "Aplicações", "/orb/app" },
	{ 2, "Lista Aplicações", "/orb/app_object" },
	{ 2, "Relacionamento Aplicações", "/orb/app_relat" },
	{ 2, "Tipo de Relacionamento", "/orb/app_relat_type" },
	{ 2, "Teste de Atividade", "/orb/probe" },
	{ 2, "Relatórios", "/blank.html" },
	{ 1, "ServiceDesk", "/servdesk/front/central.php" },
	{ 2, "Central", "/servdesk/front/central.php" },
	{ 2, "ticket", "/servdesk/front/ticket.php" },
	{ 2, "Estatística", "/servdesk/front/stat.php" },
	{ 1, "CMDB", "#" },
	{ 2, "Computadores", "/servdesk/front/computer.php" },
	{ 2, "Software", "/servdesk/front/software.php" },
	{ 2, "Equip. de Redes", "/servdesk/front/networkequipment.php" },
	{ 2, "Telefones", "/servdesk/front/phone.php"  },
	{ 2, "Periféricos", "/servdesk/front/peripheral.php" },
	{ 2, "Status", "/servdesk/front/states.php" },
	{ 2, "Base de Conhecimento", "/servdesk/front/knowbaseitem.php" },
	{ 2, "Fornecedores", "/servdesk/front/supplier.php" },
	{ 2, "Contratos", "/servdesk/front/contract.php" },
	{ 2, "Contatos", "/servdesk/front/contact.php" },
	{ 1, "Administrar", "#" },
	{ 2, "Usuários", "/servdesk/front/user.php" },
	{ 2, "Grupos", "/servdesk/front/group.php" },
	{ 2, "Regras", "/servdesk/front/rule.php" },
	{ 2, "Logs", "/servdesk/front/event.php" },
	{ 2, "Comandos de Teste", "/orb/checkcmd" },
	{ 2, "Manutenção", "/orb/system" },
	{ 1, "Ajuda", "/blank.html" },
	{ 2, "iFrame", "/c.html" },
}


function make_menu() 
   s = ""
   o_level = 1
   for i, v in ipairs(menu_itens) do

      n_level = v[1]
      name = v[2]

      if o_level < n_level and i > 1 then
         s = s .. "\n\t\t<ul>\n"
      elseif o_level > n_level and i > 1 then
         s = s .. "</li>\n\t\t</ul>\n\t\t</li>\n"
      elseif i > 1 then
         s = s .. "</li>\n"
      end

      s = s .. "\t\t<li><a href=\""..i.."\" >"..name.."</a>"
      o_level = n_level

   end
   s = s .. "</li>\n"

   return s

end


function make_iframe(item)

   local s = ""
   local link = menu_itens[item][3]

   --s = s.. "\t\t\t<iframe src =\""..link.."\" width=\"100%\" height=\"150%\" align=\"center\" \n"
   --s = s.. "\t\t\tframeborder=\"0\" scrolling=\"no\">\t\t\t</iframe>"

   s = s.."\t\t\t<iframe width=\"100%\" frameborder=0 border=0 src=\""..link.."\" name=\"childframe\" id=\"childframe\"></iframe>"

   --s = s.."<iframe width=\"950\" id=\"the_iframe\" onLoad=\"calcHeight();\" src=\""..link.."\" scrolling=\"NO\" frameborder=\"1\" height=\"1\"> An iframe capable browser is required to view this web site.  </iframe>"

   return s

end


head = [[
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>ITvision</title>
<link href="/css/v_style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="/css/v_menu.css" rel="stylesheet" type="text/css" media="screen" />
</head>

<body onload="resizeFrame(document.getElementById('childframe'))" bgcolor="#cccccc">

	<script type="text/javascript">
		// Firefox worked fine. Internet Explorer shows scrollbar because of frameborder
		function resizeFrame(f) {
			f.style.height = f.contentWindow.document.body.scrollHeight + "px";
		}
	</script>


	<script language="JavaScript">
		<!--
		function calcHeight()
		{
  			//find the height of the internal page
  			var the_height=
    			document.getElementById('the_iframe').contentWindow.
      			document.body.scrollHeight;
			
  			//change the height of the iframe
  			document.getElementById('the_iframe').height=the_height;
		}
		//-->
	</script>


<div id="header">
	<div id="logo">
		<h1><img src="../../v/images/logopurple.png">ITvision</h1>
	</div>

	<div class="menu">
		<ul>
]]


body = [[
		</ul>
	</div>
</div>

<div id="content">
	<div id="page">
		<div class="box1">
			<!-- <h1>Welcome to my website </h1> <p>Lorem ipsum dolor </p> -->
]]


foot = [[

		</div>
	</div>
</div>
<div id="footer">
	<p>&copy;&nbsp;desenvolvido pela Verto</p>
</div>
</body>
]]

