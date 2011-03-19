require "util"


function get_phpuserid()
   local cmd = "/usr/bin/php /usr/local/servdesk/inc/getuserid.php"
   return os.capture(cmd)
end



