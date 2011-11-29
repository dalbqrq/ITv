module("Application")

require "DBAccess"

local loo = require "loop.base"

local Application = oo.class{
  day   = 1,
  month = 1,
  year  = 1900,
}

