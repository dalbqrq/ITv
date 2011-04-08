require "util"
require "config"

local GLPISYNC = "glpisync.log"

function log_glpisync(line)
   local filename = config.path.log.."/"..GLPISYNC

   text_file_appender(filename, line)
end
