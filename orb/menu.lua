#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "Auth"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

function select_profile(user_id)

   columns_ = "p.name as p_name"
   table_   = "glpi_users u, glpi_profiles_users pu, glpi_profiles p"
   -- endidade é 0 pois estou levando em conta que ainda nao existe entidades!
   cond_    = "u.id = pu.users_id and pu.profiles_id = p.id and pu.entities_id = 0 and u.id = "..user_id
   
   local profile = Model.query(table_, cond_, nil, columns_)

   return profile[1].p_name
end

-- controllers ------------------------------------------------------------

function list(web, item, subitem)
   return render_list(web, item, subitem)
end
ITvision:dispatch_get(list, "/(%d+):(%d+)")


-- views ------------------------------------------------------------

function render_menu(web, item, subitem)
   item    = tonumber(item)
   subitem = tonumber(subitem)
   local itens, subitens = {}, {}
   local js = "javascript:void(0);"

   local auth = Auth.is_logged_at_glpi(web)

   if auth == false or ( item == 0 and subitem == 0 ) then
      return ""
   end

   local menu_itens = Auth.get_menu_itens(select_profile(auth.user_id))

   for i,v in ipairs(menu_itens) do
      local active = ""
      if i == item then active = "current" end
      itens[#itens+1] = li{ a{ class=active, href=js, onClick="changeHead('/orb/menu/"..i..":1')", v.name } }
   end
   itens[#itens+1] = li{ a{ class="logout", href=js, onClick="changePage('/orb/menu/0:0', '/orb/login/logout')", 
                            "Logout: "..auth.user_name } }

   for i,v in ipairs(menu_itens[item].submenu) do
      local active = ""
      if i == subitem then active = "current" end
      subitens[#subitens+1] = li{ a{ class=active, href=js, onClick="changePage('/orb/menu/"..item..":"..i.."','"..v.link.."')", 
                                     v.name } }
   end

   return { ul{ id="tablist", itens }, ul{ id="subtablist", subitens } }
end


function render_list(web, item, subitem)
   return render_menu_frame(render_menu(web, item, subitem))
end


orbit.htmlify(ITvision, "render_.+")

return _M

