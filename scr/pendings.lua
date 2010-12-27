require "Model"


function update_pending()

   -- ATUALIZA OS HOSTS PENDENTES

   os.reset_monitor()

   stmt = [[ update itvision_monitors m set m.state = 1, m.service_object_id = 
             (select o.object_id
              from nagios_objects o 
              where o.name1 = m.name1 and o.name2 = m.name2 and m.service_object_id = -1)
              where m.service_object_id = -1; ]]

   Model.execute(stmt)

end

update_pending()

