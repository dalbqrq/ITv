#!/usr/bin/env wsapi.cgi

module(..., package.seeall)

function do_something()
  local i = 14
  local j = 3

  return(tostring(i*j))

end

function run(wsapi_env)
  local headers = { ["Content-type"] = "text/html" }

  local function hello_text()
    local s = do_something()
    coroutine.yield("<html><body>")
    coroutine.yield("<p>Hello Wsapi!</p>")
    coroutine.yield("<p>PATH_INFO: " .. wsapi_env.PATH_INFO .. "</p>")
    coroutine.yield("<p>SCRIPT_NAME: " .. wsapi_env.SCRIPT_NAME .. "</p>")
    coroutine.yield("<p>DO SOMETHING: " .. s .. "</p>")
    coroutine.yield("</body></html>")
  end

  return 200, headers, coroutine.wrap(hello_text)
end

