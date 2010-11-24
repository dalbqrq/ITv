require "Model"


cmds = {

   DHCP = {
         command="$USER1$/check_dhcp",
         args={
            { sequence=nil, flag="-s", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   HTTP = {
         command="$USER1$/check_http",
         args={
            { sequence=nil, flag="-I", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Hostname"},
         },
      },

   HTTPURL = {
         command="$USER1$/check_http",
         args={
            { sequence=1, flag="-I", variable="$ARG1$", default_value=nil, description="Endereço IP"},
         },
      },

   PING = {
         command="$USER1$/check_ping",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1,   flag="-w", variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL"},
            { sequence=2,   flag="-c", variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO"},
            { sequence=nil, flag="-p", variable="5", default_value=nil, description="Número de pacotes"},
         },
      },

   --HOST_ALIVE = {
   HOST_PING = {
         command="$USER1$/check_ping",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1,   flag="-w", variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL"},
            { sequence=2,   flag="-c", variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO"},
            { sequence=nil, flag="-p", variable="5", default_value=nil, description="Número de pacotes"},
         },
      },

   POP = {
         command="$USER1$/check_pop" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   SMTP = {
         command="$USER1$/check_smtp",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   IMAP = {
         command="$USER1$/check_imap",
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   SSH = {
         command="$USER1$/check_ssh" ,
         args={
            { sequence=nil, flag=nil, variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
         },
      },

   TCP = {
         command="$USER1$/check_tcp" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1, flag="-p", variable="$ARG1$", default_value=nil, description="Número da porta"},
         },
      },

   UDP = {
         command="$USER1$/check_udp" ,
         args={
            { sequence=nil, flag="-H", variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP"},
            { sequence=1, flag="-p", variable="$ARG1$ ", default_value=nil, description="Número da porta"},
         },
      },

}


function update_checkcmd_params()
   Model.delete("itvision_checkcmds")
   Model.delete("itvision_checkcmd_params")
   for i, v in pairs(cmds) do
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

   end
end


--update_checkcmd_params()


