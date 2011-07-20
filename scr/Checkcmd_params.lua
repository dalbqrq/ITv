cmds = {

   CUPS = {
      label = "CUPS",
      command = "check_http",
      args = {
         { sequence=nil, flag="-I",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP Server CUPS" },
         { sequence=1, flag="-p",  variable="$ARGS$", default_value="631", description="Porta do serviço CUPS" },
      },
   },

   DHCP = {
      label = "DHCP",
      command = "check_dhcp",
      args = {
         { sequence=nil, flag="-s",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP DHCP" },
      },
   },

   DHCP_INTERFACE = {
      label = "DHCP_INTERFACE",
      command = "check_dhcp",
      args = {
         { sequence=nil, flag="-s",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP DHCP" },
         { sequence=1, flag="-i",  variable="$ARG1", default_value="eth0", description="Interface de entrega DHCP" },
      },
   },

   DIG = {
      label = "DIG",
      command = "check_dig",
      args = {
         { sequence=1, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=2, flag="-l",  variable="$ARG1$", default_value=nil, description="Query Address" },
      },
   },

   DNS = {
      label = "DNS",
      command = "check_dns",
      args = {
         { sequence=1, flag="-H",  variable="$HOSTANAME$", default_value=nil, description="Hostname" },
         { sequence=nil, flag="-s",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   FTP = {
      label = "FTP",
      command = "check_ftp",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-p",  variable="$ARG1$", default_value="21", description="Porta FTP" },
      },
   },

   HOST_ALIVE = {
      label = "HOST_ALIVE",
      command = "check_ping",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-w",  variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL" },
         { sequence=2, flag="-c",  variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO" },
         { sequence=nil, flag="-p",  variable="5", default_value="5", description="Número de pacotes" },
      },
   },

   HTTP = {
      label = "HTTP_IP",
      command = "check_http",
      args = {
         { sequence=nil, flag="-I",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   HTTP2 = {
      label = "HTTP_2",
      command = "check_http",
      args = {
         { sequence=1, flag="-H",  variable="$ARG1$", default_value=nil, description="Hostname" },
         { sequence=nil, flag="-I",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=2, flag="-w",  variable="$ARG2$", default_value="0.3", description="Response Time Warning" },
         { sequence=3, flag="-c",  variable="$ARG3$", default_value="0.5", description="Response Time Critical" },
      },
   },

   HTTPS = {
      label = "HTTPS",
      command = "check_http",
      args = {
         { sequence=nil, flag="--ssl",  variable="", default_value="--ssl", description="Check SSL" },
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP Server" },
         { sequence=1, flag="-I",  variable="$HOSTNAME$", default_value=nil, description="Endereço IP Virtual Host" },
      },
   },

   HTTPS_AUTH = {
      label = "HTTPS_AUTH",
      command = "check_http",
      args = {
         { sequence=nil, flag="--ssl",  variable="", default_value="--ssl", description="Check SSL" },
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP Server" },
         { sequence=1, flag="-I",  variable="$HOSTNAME$", default_value=nil, description="Endereço IP Virtual Host" },
         { sequence=2, flag="-a",  variable="$ARGS$", default_value="username:password", description="Usuário e senha para autenticação básica" },
      },
   },

   HTTPURL = {
      label = "HTTP_URL",
      command = "check_http",
      args = {
         --{ sequence=4, flag="-I",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-H",  variable="$ARG1$", default_value=nil, description="URL (Endereço de página web)" },
         { sequence=2, flag="-p",  variable="$ARG2$", default_value="80", description="Porta" },
         { sequence=3, flag="-u",  variable="$ARG3$", default_value="/", description="Caminho (path)" },
      },
   },

   IMAP = {
      label = "IMAP",
      command = "check_imap",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   LDAP = {
      label = "LDAP",
      command = "check_ldap",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-b",  variable="$ARG1$", default_value="ou=my unit, o=my org, c=at", description="Base LDAP" },
      },
   },

   MYSQL_DATABASE = {
      label = "MYSQL_DATABASE",
      command = "check_mysql",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-u",  variable="$ARG1$", default_value="user", description="Usuário Mysql" },
         { sequence=2, flag="-p",  variable="$ARG2$", default_value="password", description="Senha Mysql" },
         { sequence=3, flag="-d",  variable="$ARG3$", default_value="database", description="Nome da base de dados Mysql" },
      },
   },

   NRPE = {
      label = "NRPE",
      command = "check_nrpe",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-c",  variable="$ARG1$", default_value="check_load", description="Command a ser executado no servidore" },
      },
   },

   NTP = {
      label = "NTP",
      command = "check_ntp_time",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-w",  variable="$ARG1$", default_value="10", description="--warning=THRESHOLD" },
         { sequence=2, flag="-p",  variable="$ARG2$", default_value="15", description="--critical=THRESHOLD" },
      },
   },

   PGSQL = {
      label = "PGSQL",
      command = "check_pgsql",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-l",  variable="$ARG1$", default_value="user", description="Usuário PostgreSQL" },
         { sequence=2, flag="-p",  variable="$ARG2$", default_value="password", description="Senha PostgreSQL" },
         { sequence=3, flag="-d",  variable="$ARG3$", default_value="database", description="Nome da base de dados PostgreSQL" },
      },
   },

   PING = {
      label = "PING",
      command = "check_ping",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-w",  variable="$ARG1$", default_value="400.0,20%", description="Tempo de resposta e percentual de perda para alerta ANORMAL" },
         { sequence=2, flag="-c",  variable="$ARG2$", default_value="999.0,70%", description="Tempo de resposta e percentual de perda para alerta CRITICO" },
         { sequence=nil, flag="-p",  variable="5", default_value="5", description="Número de pacotes" },
      },
   },

   POP = {
      label = "POP",
      command = "check_pop",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   RADIUS = {
      label = "RADIUS",
      command = "check_radius",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-u",  variable="$ARG1$", default_value="username", description="Nome do usuário para autenticação" },
         { sequence=2, flag="-p",  variable="$ARG2$", default_value="password", description="Senha do usuário para autenticação" },
         { sequence=3, flag="-t",  variable="$ARG3$", default_value="10", description="Timeout" },
         { sequence=4, flag="-P",  variable="$ARG4$", default_value="1645", description="Porta Radius para autenticação" },
      },
   },

   SMTP = {
      label = "SMTP",
      command = "check_smtp",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   SQUID = {
      label = "SQUID",
      command = "check_http",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP)" },
         { sequence=1, flag="-p",  variable="$ARG1$", default_value="80", description="Porta" },
         { sequence=2, flag="-u",  variable="$ARG2$", default_value="/", description="Caminho (path)" },
         { sequence=nil, flag="-e",  variable="HTTP/1.0 200 OK", default_value="HTTP/1.0 200 OK", description="String de retorno" },
      },
   },

   SSH = {
      label = "SSH",
      command = "check_ssh",
      args = {
         { sequence=nil, flag=nil,  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   TELNET = {
      label = "TELNET",
      command = "check_telnet",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
         { sequence=1, flag="-p",  variable="$ARG1$", default_value="23", description="Porta Telnet" },
      },
   },


}
