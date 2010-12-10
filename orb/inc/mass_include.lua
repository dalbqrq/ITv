require "probe"


function mass_include_host_alive()
   local cmp = Model.select_monitors(clause)

   print("ITENS TO INCLUDE", table.getn(cmp))

   for i, v in ipairs(cmp) do
      local serv, ip, itemtype, name, id = "", "", "", "", ""

      if v.sw_name ~= "" then serv = v.sw_name.." / "..v.sv_name end

      v.c_id = v.c_id or 0
      v.n_id = v.n_id or 0
      v.p_id = v.p_id or 0
      v.sv_id = v.sv_id or 0
      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "Network" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_name then name = v.c_name else name = v.n_name end

      -- SOh ESTAh INCLUINDO EQUIPAMNETOS DE REDE
      if itemtype == "NetworkEquipment" then
         print( "/insert/",v.p_id, v.sv_id, v.c_id, v.n_id, name, v.sw_name, v.sv_name, ip, itemtype)
         ret = ITvision.insert(nil, v.p_id, v.sv_id, v.c_id, v.n_id, name, v.sw_name, v.sv_name, ip)
         print(ret)
      end

   end
end

mass_include_host_alive()

