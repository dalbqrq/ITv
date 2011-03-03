require "Model"
require "App"


function teste()                                              -- seleciona app unico na árvore (usado p/ config do nagiosbp)

   columns   = [[ distinct(node.app_id) as id, a.name as name, a.type as type, a.is_active as is_active, 
      a.service_object_id as service_object_id ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_apps AS a ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
      AND parent.id = (select id from itvision_app_trees where lft = 1) 
      AND node.app_id = a.id ]]
   extra     = [[ ORDER BY node.lft desc  ]]

   content = query (tablename, cond, extra, columns)
   return content
end

local c = teste()

for i,v in pairs(c) do
   print (v.id, v.name, v.type, v.is_active, v.service_object_id)
end
