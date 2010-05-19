local conf = require "config"

----------------------------- ERROR MESSAGE ----------------------------------
local err_msg = {} 
err_msg.pt_BR = {
	[1] = "Origen não encontrada.",
	[2] = "Aplicação inserida na árvore de aplicações."
}

err_msg.us = {
	[1] = "Unknown origin.",
	[2] = "Application inserted on applications tree."
}


err_msg = err_msg[config.language]

function error_message (idx)
	return err_msg[conf.language][idx]
end

----------------------------- DATE ----------------------------------

months = {}

months.pt = { "Janeiro", "Fevereiro", "Março", "Abril",
    "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro",
    "Novembro", "Dezembro" }

months.en = { "January", "February", "March", "April",
    "May", "June", "July", "August", "September", "October",
    "November", "December" }

weekdays = {}

weekdays.pt = { "Domingo", "Segunda", "Terça", "Quarta",
    "Quinta", "Sexta", "Sábado" }

weekdays.en = { "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday" }

-- Utility functions

time = {}
date = {}
month = {}

local datetime_mt = { __call = function (tab, date) return tab[language](date) end }

setmetatable(time, datetime_mt)
setmetatable(date, datetime_mt)
setmetatable(month, datetime_mt)

function time.pt(date)
  local time = os.date("%H:%M", date)
  date = os.date("*t", date)
  return date.day .. " de "
    .. months.pt[date.month] .. " de " .. date.year .. " às " .. time
end

function date.pt(date)
  date = os.date("*t", date)
  return weekdays.pt[date.wday] .. ", " .. date.day .. " de "
    .. months.pt[date.month] .. " de " .. date.year
end

function month.pt(month)
  return months.pt[month.month] .. " de " .. month.year
end

local function ordinalize(number)
  if number == 1 then
    return "1st"
  elseif number == 2 then
    return "2nd"
  elseif number == 3 then
    return "3rd"
  else
    return tostring(number) .. "th"
  end
end

function time.en(date)
  local time = os.date("%H:%M", date)
  date = os.date("*t", date)
  return months.en[date.month] .. " " .. ordinalize(date.day) .. " " ..
     date.year .. " at " .. time
end

function date.en(date)
  date = os.date("*t", date)
  return weekdays.en[date.wday] .. ", " .. months.en[date.month] .. " " ..
     ordinalize(date.day) .. " " .. date.year 
end

function month.en(month)
  return months.en[month.month] .. " " .. month.year
end


