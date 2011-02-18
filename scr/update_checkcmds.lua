require "Model"


cmds = {

--[[
   DHCP = {
         command="check_dhcp",
         args={
            { sequence=nil, flag="-s", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },
]]
   HTTP = {
         command="check_http",
         args={
            { sequence=nil, flag="-I", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },
--[[
   HTTPNAME = {
         command="check_http",
         args={
            { sequence=nil, flag="-I", variable="$HOSTNAME$", default_value=nil, description="Nome da Máquina"},
         },
      },
]]
   HTTPURL = {
         command="check_http",
         args={
            { sequence=nil, flag="-I", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1, flag="-H", variable="$ARG1$", default_value=nil, description="URL (Endereço de página web)"},
            { sequence=2, flag="-p", variable="$ARG2$", default_value=80, description="Porta"},
            { sequence=3, flag="-u", variable="$ARG3$", default_value="/", description="Caminho (path)"},
         },
      },
   SQUID = {
         command="check_http",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP)"},
            { sequence=1, flag="-p", variable="$ARG1$", default_value=80, description="Porta"},
            { sequence=2, flag="-u", variable="$ARG2$", default_value="/", description="Caminho (path)"},
            { sequence=nil, flag="-e", variable="HTTP/1.0 200 OK", default_value="HTTP/1.0 200 OK", description="String de retorno"},
         },
      },
   PING = {
         command="check_ping",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1,   flag="-w", variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL"},
            { sequence=2,   flag="-c", variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO"},
            { sequence=nil, flag="-p", variable="5", default_value="5", description="Número de pacotes"},
         },
      },

   --HOST_PING = {
   HOST_ALIVE = {
         command="check_ping",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1,   flag="-w", variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL"},
            { sequence=2,   flag="-c", variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO"},
            { sequence=nil, flag="-p", variable="5", default_value="5", description="Número de pacotes"},
         },
      },

   POP = {
         command="check_pop" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   SMTP = {
         command="check_smtp",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   IMAP = {
         command="check_imap",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   SSH = {
         command="check_ssh" ,
         args={
            { sequence=nil, flag=nil, variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

--[[
   TCP = {
         command="check_tcp" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1, flag="-p", variable="$ARG1$", default_value=nil, description="Número da porta"},
         },
      },

   UDP = {
         command="check_udp" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1, flag="-p", variable="$ARG1$ ", default_value=nil, description="Número da porta"},
         },
      },
]]
}


function update_checkcmd_params()
   Model.delete("itvision_checkcmds")
   Model.delete("itvision_checkcmd_params")
   for i, v in pairs(cmds) do
      print(i)
      q = Model.query("nagios_objects", "name1 = '"..i.."'")
      if q[1] then id = q[1].object_id else id='NULL' end

      cmd = { cmd_object_id = id, command = v.command }
   
      Model.insert("itvision_checkcmds", cmd)
      r = Model.query("itvision_checkcmds", "cmd_object_id = "..id)

      print("CHEKCMDS: ", r[1].id, cmd.cmd_object_id, cmd.command )

      for j, w in pairs(v.args) do
         w.checkcmds_id = r[1].id
         print ("PARAMS: ", w.variable, w.description, w.checkcmds_id, w.default_value )
         Model.insert("itvision_checkcmd_params", w)
      end

      print()
   end
end


update_checkcmd_params()



