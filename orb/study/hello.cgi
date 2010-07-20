#!/usr/bin/env lua

require "wsapi.cgi"
require "hello"
wsapi.cgi.run(hello.run)
