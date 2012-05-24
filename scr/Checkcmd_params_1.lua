cmds = {


   IMAPS = {
      label = "IMAPS",
      command = "check_imap",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   POP3 = {
      label = "POP3",
      command = "check_pop",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   SMTPS = {
      label = "SMTPS",
      command = "check_smtp",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },


}
