#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web)
   return render_tabs(web)
end
ITvision:dispatch_get(list, "/", "/list")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_tabs(web)
   local res = {}

   web.prefix = "/servdesk"
   local url = web:link("/login.php")

   -- LISTA DE OPERACOES 

   res[#res + 1] = {
      "daniel", br(), "de", br(), "albuquerque",
[[
<div class='sep'></div><div id='tabspanel' class='center-h'></div><script type='text/javascript'> var tabpanel = new Ext.TabPanel({
            applyTo: 'tabspanel',
            width:950,
            enableTabScroll: true,
            resizeTabs: false,
            collapsed: true,
            plain: true,
            items: [{
                  title: "Componentes",
                  id: '1',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=1&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=1',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Volumes",
                  id: '20',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=20&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=20',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Softwares",
                  id: '2',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=2&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=2',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Conexões",
                  id: '3',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=3&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=3',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Gerência",
                  id: '4',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=4&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=4',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Documentos",
                  id: '5',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=5&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=5',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Registro do windows",
                  id: '14',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=14&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=14',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Chamados",
                  id: '6',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=6&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=6',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Links",
                  id: '7',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=7&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=7',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Notas",
                  id: '10',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=10&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=10',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Empréstimos",
                  id: '11',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=11&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=11',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Histórico",
                  id: '12',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=12&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=12',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "OCS-NG",
                  id: '13',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=13&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=13',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }},{
                  title: "Todos",
                  id: '-1',
                  autoLoad: {url: '/glpi/ajax/computer.tabs.php',
                     scripts: true,
                     nocache: true, params: 'target=/glpi/front/computer.form.php&itemtype=Computer&glpi_tab=-1&id=5&withtemplate='},  listeners:{ // Force glpi_tab storage
                       beforeshow : function(panel){
                        /* clean content because append data instead of replace it : no more problem */
                        /* tabpanel.body.update(''); */
                        /* update active tab*/
                        Ext.Ajax.request({
                           url : '/glpi/ajax/updatecurrenttab.php?itemtype=Computer&glpi_tab=-1',
                           success: function(objServerResponse){
                           //alert(objServerResponse.responseText);
                        }
                        });
                     }
                  }}]});/// Define view pointtabpanel.expand();// force first load
            function loadDefaultTab(){
               tabpanel.body=Ext.get('tabcontent');
               tabpanel.setActiveTab('1');}// force reload
            function reloadTab(add){
               var tab = tabpanel.getActiveTab();
               var opt = tab.autoLoad;
               if (add) {
                  if (opt.params)
                     opt.params = opt.params + '&' + add;
                  else
                     opt.params = add;
               }
               tab.getUpdater().update(opt);}</script>
]]
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


