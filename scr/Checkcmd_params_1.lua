cmds = {


   SIMAP = {
      label = "SIMAP (porta 993)",
      command = "check_imap",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   SPOP = {
      label = "SPOP3 (porta 995)",
      command = "check_pop",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },

   SSMTP = {
      label = "SSMTP",
      command = "check_ssmtp",
      args = {
         { sequence=nil, flag="-H",  variable="$HOSTADDRESS$", default_value=nil, description="Endereço IP" },
      },
   },


}
