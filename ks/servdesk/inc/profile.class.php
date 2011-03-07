<?php
/*
 * @version $Id: profile.class.php 12376 2010-09-09 19:56:44Z moyo $
 -------------------------------------------------------------------------
 GLPI - Gestionnaire Libre de Parc Informatique
 Copyright (C) 2003-2010 by the INDEPNET Development Team.

 http://indepnet.net/   http://glpi-project.org
 -------------------------------------------------------------------------

 LICENSE

 This file is part of GLPI.

 GLPI is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 GLPI is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with GLPI; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 --------------------------------------------------------------------------
 */

// ----------------------------------------------------------------------
// Original Author of file: Julien Dombre
// Purpose of file:
// ----------------------------------------------------------------------

if (!defined('GLPI_ROOT')) {
   die("Sorry. You can't access directly to this file");
}

/// Profile class
class Profile extends CommonDBTM {

   // Specific ones

   /// Helpdesk fields of helpdesk profiles
   static public $helpdesk_rights=array('faq','reservation_helpdesk','create_ticket','add_followups',
                              'observe_ticket','password_update','helpdesk_hardware',
                              'helpdesk_item_type','show_group_ticket','show_group_hardware','create_validation','validate_ticket');

   /// Common fields used for all profiles type
   static public $common_fields=array("id","name","interface","is_default");
   /// Fields not related to a basic right
   static public $noright_fields=array('helpdesk_hardware','helpdesk_item_type','show_group_ticket',
                             'show_group_hardware','own_ticket','helpdesk_status','comment',
                              'date_mod');

   var $dohistory = true;

   static function getTypeName() {
      global $LANG;

      return $LANG['Menu'][35];
   }

   function canCreate() {
      return haveRight('profile', 'w');
   }

   function canView() {
      return haveRight('profile', 'r');
   }

   function defineTabs($options=array()) {
      global $LANG,$CFG_GLPI;

      if (!$this->fields['id']) {
         $ong[1]=$LANG['common'][12];

      } else if ($this->fields['interface']=='helpdesk') {
         $ong[1]=$LANG['Menu'][31]; // Helpdesk
         if (haveRight("user","r")) {
            $ong[4]=$LANG['Menu'][14];
         }
         $ong[12]=$LANG['title'][38];
      } else {
         $ong[1]=$LANG['Menu'][38].'/'.$LANG['Menu'][26].'/'.$LANG['Menu'][18]; // Inventory/Management
         $ong[2]=$LANG['title'][24]; // Assistance
         $ong[3]=$LANG['Menu'][15].'/'.$LANG['common'][12]; // Administration/Setup
         if (haveRight("user","r")) {
            $ong[4]=$LANG['Menu'][14];
         }
         $ong[12]=$LANG['title'][38];
      }
      return $ong;
   }


   function post_updateItem($history=1) {
      global $DB;

      if (in_array('is_default',$this->updates) && $this->input["is_default"]==1) {
         $query = "UPDATE ".
                   $this->getTable()."
                   SET `is_default` = '0'
                   WHERE `id` <> '".$this->input['id']."'";
         $DB->query($query);
      }
   }

   function cleanDBonPurge() {
      global $DB;

      $query = "DELETE
                FROM `glpi_profiles_users`
                WHERE `profiles_id` = '".$this->fields['id']."'";
      $DB->query($query);
   }

   function prepareInputForUpdate($input) {

      // Check for faq
      if (isset($input["interface"]) && $input["interface"]=='helpdesk') {
         if (isset($input["faq"]) && $input["faq"]=='w') {
            $input["faq"]=='r';
         }
      }

      if (isset($input["_helpdesk_item_types"])) {
         if (isset($input["helpdesk_item_type"])) {
            $input["helpdesk_item_type"]=exportArrayToDB($input["helpdesk_item_type"]);
         } else {
            $input["helpdesk_item_type"]=exportArrayToDB(array());
         }
      }

      if (isset($input["_cycles"])) {
         $tab = Ticket::getAllStatusArray();
         $cycle = array();
         foreach ($tab as $from => $label) {
            foreach ($tab as $dest => $label) {
               if ($from!=$dest && $input["_cycle"][$from][$dest]==0) {
                  $cycle[$from][$dest]=0;
               }
            }
         }
         $input["helpdesk_status"]=exportArrayToDB($cycle);
      }
      return $input;
   }

   function prepareInputForAdd($input) {

      if (isset($input["helpdesk_item_type"])) {
         $input["helpdesk_item_type"]=exportArrayToDB($input["helpdesk_item_type"]);
      }
      return $input;
   }

   /**
    * Unset unused rights for helpdesk
    **/
   function cleanProfile() {

      if ($this->fields["interface"]=="helpdesk") {
         foreach($this->fields as $key=>$val) {
            if (!in_array($key,self::$common_fields) && !in_array($key,self::$helpdesk_rights)) {
               unset($this->fields[$key]);
            }
         }
      }
      // decode array
      if (isset($this->fields["helpdesk_item_type"])
            && !is_array($this->fields["helpdesk_item_type"])) {
         $this->fields["helpdesk_item_type"]=importArrayFromDB($this->fields["helpdesk_item_type"],true);
      }
      // Empty/NULL case
      if (!isset($this->fields["helpdesk_item_type"])
          || !is_array($this->fields["helpdesk_item_type"])) {
         $this->fields["helpdesk_item_type"]=array();
      }
      // Decode status array
      if (isset($this->fields["helpdesk_status"])
            && !is_array($this->fields["helpdesk_status"])) {
         $this->fields["helpdesk_status"]=importArrayFromDB($this->fields["helpdesk_status"],true);
      }
   }

   /**
    * Get SQL restrict request to determine profiles with less rights than the active one
    * @param $separator Separator used at the beginning of the request
    * @return SQL restrict string
    **/
   static function getUnderActiveProfileRetrictRequest($separator = "AND") {

      $query = $separator ." ";

      // Not logged -> no profile to see
      if (!isset($_SESSION['glpiactiveprofile'])) {
         return $query." 0 ";
      }

      // Profile right : may modify profile so can attach all profile
      if (haveRight("profile","w")) {
         return $query." 1 ";
      }

      if ($_SESSION['glpiactiveprofile']['interface']=='central') {
         $query.= " (`glpi_profiles`.`interface` = 'helpdesk') " ;
      }

      $query.= " OR (`glpi_profiles`.`interface` = '".$_SESSION['glpiactiveprofile']['interface']."' ";
      foreach ($_SESSION['glpiactiveprofile'] as $key => $val) {
         if (!is_array($val) // Do not include entities field added by login
             && !in_array($key,self::$common_fields)
             && !in_array($key,self::$noright_fields)
             && ($_SESSION['glpiactiveprofile']['interface']=='central'
                 || in_array($key,self::$helpdesk_rights))) {

            switch ($val) {
               case '0' :
                  $query.=" AND (`glpi_profiles`.`$key` IS NULL
                                 OR `glpi_profiles`.`$key` IN ('0', '')) ";
                  break;

               case '1' :
                  $query.=" AND (`glpi_profiles`.`$key` IS NULL
                                 OR `glpi_profiles`.`$key` IN ('0', '1', '')) ";
                  break;

               case 'r' :
                  $query.=" AND (`glpi_profiles`.`$key` IS NULL
                                 OR `glpi_profiles`.`$key` IN ('r', '')) ";
                  break;

               case 'w' :
                  $query.=" AND (`glpi_profiles`.`$key` IS NULL
                                 OR `glpi_profiles`.`$key` IN ('w', 'r', '')) ";
                  break;

               default :
                  $query.=" AND (`glpi_profiles`.`$key` IS NULL OR `glpi_profiles`.`$key` = '') ";
            }
         }
      }
      $query.=")";
      return $query;
   }

   /**
    * Is the current user have more right than all profiles in parameters
    *
    *@param $IDs array of profile ID to test
    *@return boolean true if have more right
    **/
   static function currentUserHaveMoreRightThan($IDs=array()) {
      global $DB;
      if (count($IDs)==0) {
         // Check all profiles (means more right than all possible profiles)
         return (countElementsInTable('glpi_profiles')
                 == countElementsInTable('glpi_profiles', Profile::getUnderActiveProfileRetrictRequest('')));
      }
      $under_profiles=array();
      $query = "SELECT *
                FROM `glpi_profiles` ".
                Profile::getUnderActiveProfileRetrictRequest("WHERE");
      $result=$DB->query($query);
      while ($data=$DB->fetch_assoc($result)) {
         $under_profiles[$data['id']]=$data['id'];
      }

      foreach ($IDs as $ID) {
         if (!isset($under_profiles[$ID])) {
            return false;
         }
      }
      return true;
   }

   function showLegend() {
      global $LANG;

      echo "<table class='tab_cadre_fixe'>";
      echo "<tr class='tab_bg_2'><td width='70' style='text-decoration:underline'>";
      echo "<strong>".$LANG['profiles'][34]."&nbsp;: </strong></td>";
      echo "<td class='tab_bg_4' width='15' style='border:1px solid black'></td>";
      echo "<td><strong>".$LANG['profiles'][0]."</strong></td></tr>\n";
      echo "<tr class='tab_bg_2'><td></td>";
      echo "<td class='tab_bg_2' width='15' style='border:1px solid black'></td>";
      echo "<td><strong>".$LANG['profiles'][1]."</strong></td></tr>";
      echo "</table>\n";
   }

   function post_getEmpty () {
      global $LANG;

      $this->fields["interface"]="helpdesk";
      $this->fields["name"]=$LANG['common'][0];
   }

   /**
    * Print the profile form headers
    *
    * @param $ID Integer : Id of the item to print
    * @param $options array
    *     - target filename : where to go when done.
    *     - withtemplate boolean : template or basic item
    *
    * @return boolean item found
    **/
   function showForm($ID, $options=array()) {
      global $LANG,$CFG_GLPI;

      $onfocus = "";
      $new = false;
      $rowspan=4;
      if ($ID > 0) {
         $rowspan++;
         $this->check($ID,'r');
      } else {
         // Create item
         $this->check(-1,'w');
         $onfocus = "onfocus=\"if (this.value=='".$this->fields["name"]."') this.value='';\"";
         $new = true;
      }

      $rand = mt_rand();

      $this->showTabs($options);
      $this->showFormHeader($options);

      echo "<tr class='tab_bg_1'><td>".$LANG['common'][16]."&nbsp;:</td>";
      echo "<td><input type='text' name='name' value=\"".$this->fields["name"]."\" $onfocus></td>";


      echo "<td rowspan='$rowspan' class='middle right'>".$LANG['common'][25]."&nbsp;: </td>";
      echo "<td class='center middle' rowspan='$rowspan'><textarea cols='45'
      rows='4' name='comment' >".$this->fields["comment"]."</textarea></td></tr>";

      echo "<tr class='tab_bg_1'><td>".$LANG['profiles'][13]."&nbsp;:</td><td>";
      Dropdown::showYesNo("is_default",$this->fields["is_default"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_1'><td>".$LANG['profiles'][2]."&nbsp;:</td><td>";
      echo "<select name='interface'>";
      echo "<option value='helpdesk' ".($this->fields["interface"]=="helpdesk"?"selected":"").">".
             self::getInterfaceName("helpdesk")."</option>\n";
      echo "<option value='central' ".($this->fields["interface"]=="central"?"selected":"").">".
             self::getInterfaceName("central")."</option>";
      echo "</select></td></tr>\n";

      echo "<tr class='tab_bg_1'><td>".$LANG['profiles'][24]."&nbsp;:</td><td>";
      Dropdown::showYesNo("password_update",$this->fields["password_update"]);
      echo "</td></tr>\n";

      if ($ID>0) {
         echo "<tr class='tab_bg_1'>";
         echo "<td>".$LANG['common'][26]."&nbsp;: </td>";
         echo "<td>";
         echo ($this->fields["date_mod"] ? convDateTime($this->fields["date_mod"]) : $LANG['setup'][307]);
         echo "</td></tr>";
      }

      $this->showFormButtons($options);
      $this->addDivForTabs();

      return true;
   }

   /**
   * Print the helpdesk right form for the current profile
   *
   * @param $target of the form
   **/
   function showFormHelpdesk($target) {
      global $LANG,$CFG_GLPI;

      $ID = $this->fields['id'];

      if (!haveRight("profile","r")) {
         return false;
      }
      if ($canedit=haveRight("profile","w")) {
         echo "<form method='post' action='$target'>";
      }

      echo "<table class='tab_cadre_fixe'>";

      echo "<tr class='tab_bg_1'><td colspan='4' class='center'>";
      echo "<strong>".$LANG['title'][24]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][5]."&nbsp;:</td><td>";
      Dropdown::showYesNo("create_ticket",$this->fields["create_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][6]."&nbsp;:</td><td>";
      Dropdown::showYesNo("add_followups",$this->fields["add_followups"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][9]."&nbsp;:</td><td>";
      Dropdown::showYesNo("observe_ticket",$this->fields["observe_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][26]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_group_ticket",$this->fields["show_group_ticket"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][27]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_group_hardware",$this->fields["show_group_hardware"]);
      echo "</td>";
      echo "<td colspan='2'></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['setup'][350]."&nbsp;:</td><td>";
      echo "<select name='helpdesk_hardware'>";
      echo "<option value='0' ".($this->fields["helpdesk_hardware"]==0?"selected":"")." >".DROPDOWN_EMPTY_VALUE;
      echo "</option>\n";
      echo "<option value=\"".pow(2,HELPDESK_MY_HARDWARE)."\" ".
             ($this->fields["helpdesk_hardware"]==pow(2,HELPDESK_MY_HARDWARE)?"selected":"")." >".
             $LANG['tracking'][1]."</option>\n";
      echo "<option value=\"".pow(2,HELPDESK_ALL_HARDWARE)."\" ".
             ($this->fields["helpdesk_hardware"]==pow(2,HELPDESK_ALL_HARDWARE)?"selected":"")." >".
             $LANG['setup'][351]."</option>\n";
      echo "<option value=\"".(pow(2,HELPDESK_MY_HARDWARE)+pow(2,HELPDESK_ALL_HARDWARE))."\" ".
             ($this->fields["helpdesk_hardware"]
              ==(pow(2,HELPDESK_MY_HARDWARE)+pow(2,HELPDESK_ALL_HARDWARE))?"selected":"")." >".
              $LANG['tracking'][1]." + ".$LANG['setup'][351]."</option>";
      echo "</select>\n";
      echo "</td><td>".$LANG['setup'][352]."&nbsp;:</td>";
      echo "<td>";

      echo "<input type='hidden' name='_helpdesk_item_types' value='1'>";
      echo "<select name='helpdesk_item_type[]' multiple size='3'>";
      foreach($CFG_GLPI["helpdesk_types"] as $key => $itemtype) {
         if (class_exists($itemtype)) {
            if (!isPluginItemType($itemtype)) { // No Plugin for the moment
               $item = new $itemtype();
               echo "<option value='".$itemtype."' ".
                     (in_array($itemtype,$this->fields["helpdesk_item_type"])?" selected":"").">".
                     $item->getTypeName()."</option>\n";
            }
         } else {
            unset($CFG_GLPI["helpdesk_types"][$key]);
         }
      }
      echo "</select></td>";
      echo "</tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][48]."&nbsp;:</td><td>";
      Dropdown::showYesNo("create_validation",$this->fields["create_validation"]);
      echo "<td>".$LANG['profiles'][49]."&nbsp;:</td><td>";
      Dropdown::showYesNo("validate_ticket",$this->fields["validate_ticket"]);
      echo "</td>";
      echo "</tr>\n";

      echo "<tr class='tab_bg_1'><td colspan='4' class='center'>";
      echo "<strong>".$LANG['Menu'][18]."</strong></td>";
      echo "</tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['knowbase'][1]."&nbsp;:</td><td>";
      if ($this->fields["interface"]=="helpdesk" && $this->fields["faq"]=='w') {
         $this->fields["faq"]='r';
      }
      Profile::dropdownNoneReadWrite("faq",$this->fields["faq"],1,1,0);
      echo "</td>";
      echo "<td>".$LANG['Menu'][17]."&nbsp;:</td><td>";
      Dropdown::showYesNo("reservation_helpdesk",$this->fields["reservation_helpdesk"]);
      echo "</td></tr>\n";

      if ($canedit) {
         echo "<tr class='tab_bg_1'>";
         echo "<td colspan='4' class='center'>";
         echo "<input type='hidden' name='id' value=$ID>";
         echo "<input type='submit' name='update' value=\"".$LANG['buttons'][7]."\" class='submit'>";
         echo "</td></tr>\n";
         echo "</table></form>\n";
      } else {
         echo "</table>\n";
      }
   }

   /**
   * Print the Inventory/Management/Toolsd right form for the current profile
   *
   * @param $target of the form
   * @param $openform boolean open the form
   * @param $closeform boolean close the form
   **/
   function showFormInventory($target, $openform=true, $closeform=true) {
      global $LANG,$CFG_GLPI;

      $ID = $this->fields['id'];

      if (!haveRight("profile","r")) {
         return false;
      }
      if (($canedit=haveRight("profile","w")) && $openform) {
         echo "<form method='post' action='$target'>";
      }

      echo "<table class='tab_cadre_fixe'>";

      // Inventory
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['Menu'][38]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][0]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("computer",$this->fields["computer"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][3]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("monitor",$this->fields["monitor"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][4]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("software",$this->fields["software"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][1]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("networking",$this->fields["networking"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][2]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("printer",$this->fields["printer"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][21]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("cartridge",$this->fields["cartridge"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][32]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("consumable",$this->fields["consumable"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][34]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("phone",$this->fields["phone"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][16]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("peripheral",$this->fields["peripheral"],1,1,1);
      echo "</td></tr>\n";

      // daniel@itvision.com.br
      // Gestion / Management
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['Menu'][50]."</strong></td></tr>";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][51]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("application",$this->fields["application"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][52]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("checkcmds",$this->fields["checkcmds"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][53]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("app_relat_type",$this->fields["app_relat_type"],1,1,1);
      echo "</td></tr>\n";
      // daniel@itvision.com.br


      // Gestion / Management
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['Menu'][26]."</strong></td></tr>";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][22]." / ".$LANG['Menu'][23]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("contact_enterprise",$this->fields["contact_enterprise"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][27]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("document",$this->fields["document"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][25]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("contract",$this->fields["contract"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][24]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("infocom",$this->fields["infocom"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['financial'][87]."&nbsp;:</td><td colspan='3'>";
      Profile::dropdownNoneReadWrite("budget",$this->fields["budget"],1,1,1);
      echo "</td></tr>\n";

      // Outils / Tools
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['Menu'][18]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['title'][37]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("notes",$this->fields["notes"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['reminder'][1]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("reminder_public",$this->fields["reminder_public"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['bookmark'][5]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("bookmark_public",$this->fields["bookmark_public"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['knowbase'][1]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("faq",$this->fields["faq"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][6]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("reports",$this->fields["reports"],1,1,0);
      echo "</td>";
      echo "<td>".$LANG['Menu'][17]."&nbsp;:</td><td>";
      Dropdown::showYesNo("reservation_helpdesk",$this->fields["reservation_helpdesk"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['title'][5]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("knowbase",$this->fields["knowbase"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['profiles'][23]."&nbsp;:</td><td colspan='3'>";
      Profile::dropdownNoneReadWrite("reservation_central",$this->fields["reservation_central"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][33]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("ocsng",$this->fields["ocsng"],1,0,1);
      echo "</td>";
      echo "<td>".$LANG['profiles'][31]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("sync_ocsng",$this->fields["sync_ocsng"],1,0,1);
      echo "</td>";
      echo "<td>".$LANG['profiles'][30]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("view_ocsng",$this->fields["view_ocsng"],1,1,0);
      echo "</td></tr>\n";

      if ($canedit && $closeform) {
         echo "<tr class='tab_bg_1'>";
         echo "<td colspan='6' class='center'>";
         echo "<input type='hidden' name='id' value=$ID>";
         echo "<input type='submit' name='update' value=\"".$LANG['buttons'][7]."\" class='submit'>";
         echo "</td></tr>\n";
         echo "</table></form>\n";
      } else {
         echo "</table>\n";
      }
   }

   /**
   * Print the Tracking right form for the current profile
   *
   * @param $target of the form
   * @param $openform boolean open the form
   * @param $closeform boolean close the form
   **/
   function showFormTracking($target, $openform=true, $closeform=true) {
      global $LANG,$CFG_GLPI;

      $ID = $this->fields['id'];

      if (!haveRight("profile","r")) {
         return false;
      }
      if (($canedit=haveRight("profile","w")) && $openform) {
         echo "<form method='post' action='$target'>";
      }

      echo "<table class='tab_cadre_fixe'>";

      // Assistance / Tracking-helpdesk
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['title'][24]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['profiles'][41]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][5]."&nbsp;:</td><td>";
      Dropdown::showYesNo("create_ticket",$this->fields["create_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][6]."&nbsp;:</td><td>";
      Dropdown::showYesNo("add_followups",$this->fields["add_followups"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][15]."&nbsp;:</td><td>";
      Dropdown::showYesNo("global_add_followups",$this->fields["global_add_followups"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td colspan='2'>&nbsp;</td>";
      echo "<td>".$LANG['profiles'][4]."&nbsp;:</td><td>";
      Dropdown::showYesNo("group_add_followups",$this->fields["group_add_followups"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][45]."&nbsp;:</td><td>";
      Dropdown::showYesNo("global_add_tasks",$this->fields["global_add_tasks"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['profiles'][40]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][18]."&nbsp;:</td><td>";
      Dropdown::showYesNo("update_ticket",$this->fields["update_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][14]."&nbsp;:</td><td>";
      Dropdown::showYesNo("delete_ticket",$this->fields["delete_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][35]."&nbsp;:</td><td>";
      Dropdown::showYesNo("update_followups",$this->fields["update_followups"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][44]."&nbsp;:</td><td>";
      Dropdown::showYesNo("update_priority",$this->fields["update_priority"]);
      echo "</td>";
      echo "<td colspan='2'></td>";
      echo "<td>".$LANG['profiles'][46]."&nbsp;:</td><td>";
      Dropdown::showYesNo("update_tasks",$this->fields["update_tasks"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['validation'][0]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][48]."&nbsp;:</td><td>";
      Dropdown::showYesNo("create_validation",$this->fields["create_validation"]);
      echo "<td>".$LANG['profiles'][49]."&nbsp;:</td><td>";
      Dropdown::showYesNo("validate_ticket",$this->fields["validate_ticket"]);
      echo "</td>";
      echo "<td colspan='2'></td></tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['profiles'][39]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][16]."&nbsp;:</td><td>";
      Dropdown::showYesNo("own_ticket",$this->fields["own_ticket"]);
      echo "<td>".$LANG['profiles'][17]."&nbsp;:</td><td>";
      Dropdown::showYesNo("steal_ticket",$this->fields["steal_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][19]."&nbsp;:</td><td>";
      Dropdown::showYesNo("assign_ticket",$this->fields["assign_ticket"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['profiles'][42]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][27]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_group_hardware",$this->fields["show_group_hardware"]);
      echo "</td>";
      echo "<td>".$LANG['setup'][350]."&nbsp;:</td><td>";
      echo "\n<select name='helpdesk_hardware'>";
      echo "<option value='0' ".($this->fields["helpdesk_hardware"]==0?"selected":"")." >".DROPDOWN_EMPTY_VALUE;
      echo "</option>\n";
      echo "<option value=\"".pow(2,HELPDESK_MY_HARDWARE)."\" ".
            ($this->fields["helpdesk_hardware"]==pow(2,HELPDESK_MY_HARDWARE)?"selected":"")." >".
            $LANG['tracking'][1]."</option>\n";
      echo "<option value=\"".pow(2,HELPDESK_ALL_HARDWARE)."\" ".
            ($this->fields["helpdesk_hardware"]==pow(2,HELPDESK_ALL_HARDWARE)?"selected":"")." >".
            $LANG['setup'][351]."</option>\n";
      echo "<option value=\"".(pow(2,HELPDESK_MY_HARDWARE)+pow(2,HELPDESK_ALL_HARDWARE))."\" ".
            ($this->fields["helpdesk_hardware"]
             ==(pow(2,HELPDESK_MY_HARDWARE)+pow(2,HELPDESK_ALL_HARDWARE))?"selected":"")." >".
            $LANG['tracking'][1]." + ".$LANG['setup'][351]."</option>";
      echo "</select>\n";
      echo "</td>";
      echo "<td>".$LANG['setup'][352]."&nbsp;:</td>";
      echo "<td>";
      echo "<input type='hidden' name='_helpdesk_item_types' value='1'>";
      echo "<select name='helpdesk_item_type[]' multiple size='3'>";

      foreach($CFG_GLPI["helpdesk_types"] as $key => $itemtype) {
         if (class_exists($itemtype)) {
            if (!isPluginItemType($itemtype)) { // No Plugin for the moment
               $item = new $itemtype();
               echo "<option value='".$itemtype."' ".
                     (in_array($itemtype,$this->fields["helpdesk_item_type"])?" selected":"").">".
                     $item->getTypeName()."</option>\n";
            }
         } else {
            unset($CFG_GLPI["helpdesk_types"][$key]);
         }
      }
      echo "</select></td>";
      echo "</tr>\n";

      echo "<tr class='tab_bg_5'><td colspan='6' align='center'>";
      echo "<strong>".$LANG['profiles'][38]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][32]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_assign_ticket",$this->fields["show_assign_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][26]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_group_ticket",$this->fields["show_group_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][7]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_all_ticket",$this->fields["show_all_ticket"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][9]."&nbsp;:</td><td>";
      Dropdown::showYesNo("observe_ticket",$this->fields["observe_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][8]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_full_ticket",$this->fields["show_full_ticket"]);
      echo "</td>";
      echo "<td>".$LANG['Menu'][13]."&nbsp;:</td><td>";
      Dropdown::showYesNo("statistic",$this->fields["statistic"]);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['profiles'][20]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_planning",$this->fields["show_planning"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][36]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_group_planning",$this->fields["show_group_planning"]);
      echo "</td>";
      echo "<td>".$LANG['profiles'][21]."&nbsp;:</td><td>";
      Dropdown::showYesNo("show_all_planning",$this->fields["show_all_planning"]);
      echo "</td></tr>\n";

      echo "</table><br><table class='tab_cadre_fixe'>";
      $tabstatus = Ticket::getAllStatusArray();

      echo "<th colspan='".(count($tabstatus)+1)."'>".$LANG['setup'][615]."</th>";
      echo "<tr class='tab_bg_1'><td class='b center'>".$LANG['setup'][616];
      echo "<input type='hidden' name='_cycles' value='1'</td>";
      foreach ($tabstatus as $label) {
         echo "<td class='center'>$label</td>";
      }
      echo "</tr>\n";
      foreach ($tabstatus as $from => $label) {
         echo "<tr class='tab_bg_2'><td class='tab_bg_1'>$label</td>";
         foreach ($tabstatus as $dest => $label) {
            echo "<td class='center'>";
            if ($dest==$from) {
               echo Dropdown::getYesNo(1);
            } else {
               Dropdown::showYesNo("_cycle[$from][$dest]",
                                   (!isset($this->fields['helpdesk_status'][$from][$dest])
                                    || $this->fields['helpdesk_status'][$from][$dest]));
            }
            echo "</td>";
         }
         echo "</tr>\n";
      }

      if ($canedit && $closeform) {
         echo "<tr class='tab_bg_1'>";
         echo "<td colspan='".(count($tabstatus)+1)."' class='center'>";
         echo "<input type='hidden' name='id' value=$ID>";
         echo "<input type='submit' name='update' value=\"".$LANG['buttons'][7]."\" class='submit'>";
         echo "</td></tr>\n";
         echo "</table></form>\n";
      } else {
         echo "</table>\n";
      }
   }

   /**
   * Print the central form for a profile
   *
   * @param $target target of the form
   * @param $openform boolean open the form
   * @param $closeform boolean close the form
   **/
   function showFormAdmin($target, $openform=true, $closeform=true) {
      global $LANG,$CFG_GLPI;

      $ID = $this->fields['id'];

      if (!haveRight("profile","r")) {
         return false;
      }
      if (($canedit=haveRight("profile","w")) && $openform) {
         echo "<form method='post' action='$target'>";
      }

      echo "<table class='tab_cadre_fixe'><tr>";

      // Administration
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['Menu'][15]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['Menu'][14]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("user",$this->fields["user"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][36]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("group",$this->fields["group"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['profiles'][43]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("user_authtype",$this->fields["user_authtype"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['Menu'][37]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("entity",$this->fields["entity"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['transfer'][1]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("transfer",$this->fields["transfer"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][35]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("profile",$this->fields["profile"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['Menu'][12]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("backup",$this->fields["backup"],1,0,1);
      echo "</td>";
      echo "<td>".$LANG['Menu'][30]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("logs",$this->fields["logs"],1,1,0);
      echo "</td>";

      echo "<td class='tab_bg_2'>".$LANG['profiles'][47]."&nbsp;:</td><td class='tab_bg_2'>";
      Profile::dropdownNoneReadWrite("import_externalauth_users",$this->fields["import_externalauth_users"],1,0,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['rulesengine'][17].' / '.$LANG['rulesengine'][77]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['rulesengine'][19]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_ldap",$this->fields["rule_ldap"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['rulesengine'][18]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_ocs",$this->fields["rule_ocs"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['rulesengine'][70]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_mailcollector",$this->fields["rule_mailcollector"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['rulesengine'][37]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_softwarecategories",$this->fields["rule_softwarecategories"],
                            1,1,1);
      echo "</td>";
      echo "<td>".$LANG['rulesengine'][33]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_dictionnary_dropdown",$this->fields["rule_dictionnary_dropdown"],
                            1,1,1);
      echo"</td>";
      echo "<td>".$LANG['rulesengine'][35]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_dictionnary_software",$this->fields["rule_dictionnary_software"],
                            1,1,1);
      echo"</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['rulesengine'][28]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("rule_ticket",$this->fields["rule_ticket"],1,1,0);
      echo "</td>";
      echo "<td class='tab_bg_1'>".$LANG['rulesengine'][28]." (".$LANG['entity'][0].")&nbsp;:</td><td class='tab_bg_1'>";
      Profile::dropdownNoneReadWrite("entity_rule_ticket",$this->fields["entity_rule_ticket"],1,1,1);
      echo "</td><td class='tab_bg_1' colspan='2'>";
      echo"</td></tr>\n";
      // Configuration
      echo "<tr class='tab_bg_1'><td colspan='6' class='center'>";
      echo "<strong>".$LANG['common'][12]."</strong></td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['common'][12]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("config",$this->fields["config"],1,0,1);
      echo "</td>";
      echo "<td>".$LANG['setup'][250]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("search_config_global",$this->fields["search_config_global"],1,0,1);
      echo "</td>";
      echo "<td class='tab_bg_2'>".$LANG['setup'][250]." (".$LANG['common'][34].")&nbsp;:</td>";
      echo "<td class='tab_bg_2'>";
      Profile::dropdownNoneReadWrite("search_config",$this->fields["search_config"],1,0,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['title'][30]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("device",$this->fields["device"],1,0,1);
      echo "</td>";
      echo "<td>".$LANG['setup'][0]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("dropdown",$this->fields["dropdown"],1,1,1);
      echo "</td>";
      echo "<td class='tab_bg_2'>".$LANG['setup'][0]." (".$LANG['entity'][0].")&nbsp;:</td>";
      echo "<td class='tab_bg_2'>";
      Profile::dropdownNoneReadWrite("entity_dropdown",$this->fields["entity_dropdown"],1,1,1);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_4'>";
      echo "<td>".$LANG['document'][7]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("typedoc",$this->fields["typedoc"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['title'][33]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("link",$this->fields["link"],1,1,1);
      echo "</td>";
      echo "<td>".$LANG['setup'][306]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("check_update",$this->fields["check_update"],1,1,0);
      echo "</td></tr>\n";

      echo "<tr class='tab_bg_2'>";
      echo "<td>".$LANG['setup'][704]."&nbsp;:</td><td>";
      Profile::dropdownNoneReadWrite("notification",$this->fields["notification"],1,1,1);
      echo "</td>";
      echo "<td colspan='4'>";
      echo "</td></tr>\n";

      if ($canedit && $closeform) {
         echo "<tr class='tab_bg_1'>";
         echo "<td colspan='6' class='center'>";
         echo "<input type='hidden' name='id' value=$ID>";
         echo "<input type='submit' name='update' value=\"".$LANG['buttons'][7]."\" class='submit'>";
         echo "</td></tr>\n";
         echo "</table></form>\n";
      } else {
         echo "</table>\n";
      }

      $this->showLegend();
   }

   function getSearchOptions() {
      global $LANG;

      $tab = array();

      $tab['common']           = $LANG['common'][32];

      $tab[1]['table']         = $this->getTable();
      $tab[1]['field']         = 'name';
      $tab[1]['linkfield']     = 'name';
      $tab[1]['name']          = $LANG['common'][16];
      $tab[1]['datatype']      = 'itemlink';
      $tab[1]['itemlink_type'] = $this->getType();

      $tab[19]['table']     = $this->getTable();
      $tab[19]['field']     = 'date_mod';
      $tab[19]['linkfield'] = '';
      $tab[19]['name']      = $LANG['common'][26];
      $tab[19]['datatype']  = 'datetime';

      $tab[2]['table']     = $this->getTable();
      $tab[2]['field']     = 'interface';
      $tab[2]['linkfield'] = '';
      $tab[2]['name']      = $LANG['profiles'][2];

      $tab[3]['table']     = $this->getTable();
      $tab[3]['field']     = 'is_default';
      $tab[3]['linkfield'] = '';
      $tab[3]['name']      = $LANG['profiles'][13];
      $tab[3]['datatype']  = 'bool';

      $tab[16]['table']     = $this->getTable();
      $tab[16]['field']     = 'comment';
      $tab[16]['linkfield'] = 'comment';
      $tab[16]['name']      = $LANG['common'][25];
      $tab[16]['datatype']  = 'text';

      $tab['inventory'] = $LANG['Menu'][18];

      $tab[20]['table'] = $this->getTable();
      $tab[20]['field'] = 'computer';
      $tab[20]['name'] = $LANG['Menu'][0];
      $tab[20]['linkfield'] = 'computer';
      $tab[20]['datatype'] = 'right';

      $tab[21]['table'] = $this->getTable();
      $tab[21]['field'] = 'monitor';
      $tab[21]['name'] = $LANG['Menu'][3];
      $tab[21]['linkfield'] = 'monitor';
      $tab[21]['datatype'] = 'right';

      $tab[22]['table'] = $this->getTable();
      $tab[22]['field'] = 'software';
      $tab[22]['name'] = $LANG['Menu'][4];
      $tab[22]['linkfield'] = 'software';
      $tab[22]['datatype'] = 'right';

      $tab[23]['table'] = $this->getTable();
      $tab[23]['field'] = 'networking';
      $tab[23]['name'] = $LANG['Menu'][1];
      $tab[23]['linkfield'] = 'networking';
      $tab[23]['datatype'] = 'right';

      $tab[24]['table'] = $this->getTable();
      $tab[24]['field'] = 'printer';
      $tab[24]['name'] = $LANG['Menu'][2];
      $tab[24]['linkfield'] = 'printer';
      $tab[24]['datatype'] = 'right';

      $tab[25]['table'] = $this->getTable();
      $tab[25]['field'] = 'peripheral';
      $tab[25]['name'] = $LANG['Menu'][16];
      $tab[25]['linkfield'] = 'peripheral';
      $tab[25]['datatype'] = 'right';

      $tab[26]['table'] = $this->getTable();
      $tab[26]['field'] = 'cartridge';
      $tab[26]['name'] = $LANG['Menu'][21];
      $tab[26]['linkfield'] = 'cartridge';
      $tab[26]['datatype'] = 'right';

      $tab[27]['table'] = $this->getTable();
      $tab[27]['field'] = 'consumable';
      $tab[27]['name'] = $LANG['Menu'][32];
      $tab[27]['linkfield'] = 'consumable';
      $tab[27]['datatype'] = 'right';

      $tab[28]['table'] = $this->getTable();
      $tab[28]['field'] = 'phone';
      $tab[28]['name'] = $LANG['Menu'][34];
      $tab[28]['linkfield'] = 'phone';
      $tab[28]['datatype'] = 'right';

      $tab[29]['table'] = $this->getTable();
      $tab[29]['field'] = 'notes';
      $tab[29]['name'] = $LANG['title'][37];
      $tab[29]['linkfield'] = 'notes';
      $tab[29]['datatype'] = 'right';

      $tab['monitoring']           = $LANG['Menu'][50];

      $tab[150]['table'] = $this->getTable();
      $tab[150]['field'] = 'application';
      $tab[150]['name'] = $LANG['Menu'][51];
      $tab[150]['linkfield'] = 'application';
      $tab[150]['datatype'] = 'right';

      $tab[150]['table'] = $this->getTable();
      $tab[150]['field'] = 'checkcmds';
      $tab[150]['name'] = $LANG['Menu'][52];
      $tab[150]['linkfield'] = 'checkcmds';
      $tab[150]['datatype'] = 'right';

      $tab[150]['table'] = $this->getTable();
      $tab[150]['field'] = 'app_relat_type';
      $tab[150]['name'] = $LANG['Menu'][53];
      $tab[150]['linkfield'] = 'app_relat_type';
      $tab[150]['datatype'] = 'right';

      $tab['management']           = $LANG['Menu'][26];

      $tab[30]['table'] = $this->getTable();
      $tab[30]['field'] = 'contact_enterprise';
      $tab[30]['name'] = $LANG['common'][92]." / ".$LANG['financial'][26];
      $tab[30]['linkfield'] = 'contact_enterprise';
      $tab[30]['datatype'] = 'right';

      $tab[31]['table'] = $this->getTable();
      $tab[31]['field'] = 'document';
      $tab[31]['name'] = $LANG['Menu'][27];
      $tab[31]['linkfield'] = 'document';
      $tab[31]['datatype'] = 'right';

      $tab[32]['table'] = $this->getTable();
      $tab[32]['field'] = 'contract';
      $tab[32]['name'] = $LANG['Menu'][25];
      $tab[32]['linkfield'] = 'contract';
      $tab[32]['datatype'] = 'right';

      $tab[33]['table'] = $this->getTable();
      $tab[33]['field'] = 'infocom';
      $tab[33]['name'] = $LANG['Menu'][24];
      $tab[33]['linkfield'] = 'infocom';
      $tab[33]['datatype'] = 'right';

      $tab[101]['table'] = $this->getTable();
      $tab[101]['field'] = 'budget';
      $tab[101]['name'] = $LANG['financial'][87];
      $tab[101]['linkfield'] = 'budget';
      $tab[101]['datatype'] = 'right';

      $tab['tools'] = $LANG['Menu'][18];

      $tab[34]['table'] = $this->getTable();
      $tab[34]['field'] = 'knowbase';
      $tab[34]['name'] = $LANG['Menu'][19];
      $tab[34]['linkfield'] = 'knowbase';
      $tab[34]['datatype'] = 'right';

      $tab[35]['table'] = $this->getTable();
      $tab[35]['field'] = 'faq';
      $tab[35]['name'] = $LANG['Menu'][20];
      $tab[35]['linkfield'] = 'faq';
      $tab[35]['datatype'] = 'right';

      $tab[36]['table'] = $this->getTable();
      $tab[36]['field'] = 'reservation_helpdesk';
      $tab[36]['name'] = $LANG['Menu'][17];
      $tab[36]['linkfield'] = 'reservation_helpdesk';
      $tab[36]['datatype'] = 'bool';

      $tab[37]['table'] = $this->getTable();
      $tab[37]['field'] = 'reservation_central';
      $tab[37]['name'] = $LANG['profiles'][23];
      $tab[37]['linkfield'] = 'reservation_central';
      $tab[37]['datatype'] = 'bool';

      $tab[38]['table'] = $this->getTable();
      $tab[38]['field'] = 'reports';
      $tab[38]['name'] = $LANG['Menu'][6];
      $tab[38]['linkfield'] = 'reports';
      $tab[38]['datatype'] = 'right';

      $tab[39]['table'] = $this->getTable();
      $tab[39]['field'] = 'ocsng';
      $tab[39]['name'] = $LANG['Menu'][33];
      $tab[39]['linkfield'] = 'ocsng';
      $tab[39]['datatype'] = 'right';

      $tab[40]['table'] = $this->getTable();
      $tab[40]['field'] = 'view_ocsng';
      $tab[40]['name'] = $LANG['profiles'][30];
      $tab[40]['linkfield'] = 'view_ocsng';
      $tab[40]['datatype'] = 'right';

      $tab[41]['table'] = $this->getTable();
      $tab[41]['field'] = 'sync_ocsng';
      $tab[41]['name'] = $LANG['profiles'][31];
      $tab[41]['linkfield'] = 'sync_ocsng';
      $tab[41]['datatype'] = 'right';

      $tab['config'] = $LANG['common'][12];

      $tab[42]['table'] = $this->getTable();
      $tab[42]['field'] = 'dropdown';
      $tab[42]['name'] = $LANG['setup'][0];
      $tab[42]['linkfield'] = 'dropdown';
      $tab[42]['datatype'] = 'right';

      $tab[43]['table'] = $this->getTable();
      $tab[43]['field'] = 'entity_dropdown';
      $tab[43]['name'] = $LANG['setup'][0]."(".$LANG['Menu'][37].")";
      $tab[43]['linkfield'] = 'entity_dropdown';
      $tab[43]['datatype'] = 'right';

      $tab[44]['table'] = $this->getTable();
      $tab[44]['field'] = 'device';
      $tab[44]['name'] = $LANG['title'][30];
      $tab[44]['linkfield'] = 'device';
      $tab[44]['datatype'] = 'right';

      $tab[106]['table'] = $this->getTable();
      $tab[106]['field'] = 'notification';
      $tab[106]['name'] = $LANG['setup'][704];
      $tab[106]['linkfield'] = 'notification';
      $tab[106]['datatype'] = 'right';

      $tab[45]['table'] = $this->getTable();
      $tab[45]['field'] = 'typedoc';
      $tab[45]['name'] = $LANG['document'][7];
      $tab[45]['linkfield'] = 'typedoc';
      $tab[45]['datatype'] = 'right';

      $tab[46]['table'] = $this->getTable();
      $tab[46]['field'] = 'link';
      $tab[46]['name'] = $LANG['title'][33];
      $tab[46]['linkfield'] = 'link';
      $tab[46]['datatype'] = 'right';

      $tab[47]['table'] = $this->getTable();
      $tab[47]['field'] = 'config';
      $tab[47]['name'] = $LANG['common'][12];
      $tab[47]['linkfield'] = 'config';
      $tab[47]['datatype'] = 'right';

      $tab[52]['table'] = $this->getTable();
      $tab[52]['field'] = 'search_config';
      $tab[52]['name'] = $LANG['setup'][250]."(".$LANG['common'][34].")";
      $tab[52]['linkfield'] = 'search_config';
      $tab[52]['datatype'] = 'right';

      $tab[53]['table'] = $this->getTable();
      $tab[53]['field'] = 'search_config_global';
      $tab[53]['name'] = $LANG['setup'][250];
      $tab[53]['linkfield'] = 'search_config_global';
      $tab[53]['datatype'] = 'right';

      $tab['admin'] = $LANG['Menu'][15];

      $tab[48]['table'] = $this->getTable();
      $tab[48]['field'] = 'rule_ticket';
      $tab[48]['name'] = $LANG['rulesengine'][28];
      $tab[48]['linkfield'] = 'rule_ticket';
      $tab[48]['datatype'] = 'right';

      $tab[105]['table']     = $this->getTable();
      $tab[105]['field']     = 'rule_mailcollector';
      $tab[105]['name']      = $LANG['rulesengine'][70];
      $tab[105]['linkfield'] = 'rule_mailcollector';
      $tab[105]['datatype']  = 'right';

      $tab[49]['table'] = $this->getTable();
      $tab[49]['field'] = 'rule_ocs';
      $tab[49]['name'] = $LANG['rulesengine'][18];
      $tab[49]['linkfield'] = 'rule_ocs';
      $tab[49]['datatype'] = 'right';

      $tab[50]['table'] = $this->getTable();
      $tab[50]['field'] = 'rule_ldap';
      $tab[50]['name'] = $LANG['rulesengine'][19];
      $tab[50]['linkfield'] = 'rule_ldap';
      $tab[50]['datatype'] = 'right';

      $tab[51]['table'] = $this->getTable();
      $tab[51]['field'] = 'rule_softwarecategories';
      $tab[51]['name'] = $LANG['rulesengine'][37];
      $tab[51]['linkfield'] = 'rule_softwarecategories';
      $tab[51]['datatype'] = 'right';

      $tab[90]['table'] = $this->getTable();
      $tab[90]['field'] = 'rule_dictionnary_software';
      $tab[90]['name'] = $LANG['rulesengine'][35];
      $tab[90]['linkfield'] = 'rule_dictionnary_software';
      $tab[90]['datatype'] = 'right';

      $tab[91]['table'] = $this->getTable();
      $tab[91]['field'] = 'rule_dictionnary_dropdown';
      $tab[91]['name'] = $LANG['rulesengine'][33];
      $tab[91]['linkfield'] = 'rule_dictionnary_dropdown';
      $tab[91]['datatype'] = 'right';

      $tab[93]['table'] = $this->getTable();
      $tab[93]['field'] = 'entity_rule_ticket';
      $tab[93]['name'] = $LANG['rulesengine'][28]." (".$LANG['entity'][0].")";
      $tab[93]['linkfield'] = 'entity_rule_ticket';
      $tab[93]['datatype'] = 'right';

      $tab[54]['table'] = $this->getTable();
      $tab[54]['field'] = 'check_update';
      $tab[54]['name'] = $LANG['setup'][306];
      $tab[54]['linkfield'] = 'check_update';
      $tab[54]['datatype'] = 'bool';

      $tab[55]['table'] = $this->getTable();
      $tab[55]['field'] = 'profile';
      $tab[55]['name'] = $LANG['Menu'][35];
      $tab[55]['linkfield'] = 'profile';
      $tab[55]['datatype'] = 'right';

      $tab[56]['table'] = $this->getTable();
      $tab[56]['field'] = 'user';
      $tab[56]['name'] = $LANG['Menu'][14];
      $tab[56]['linkfield'] = 'user';
      $tab[56]['datatype'] = 'right';

      $tab[57]['table'] = $this->getTable();
      $tab[57]['field'] = 'user_authtype';
      $tab[57]['name'] = $LANG['profiles'][43];
      $tab[57]['linkfield'] = 'user_authtype';
      $tab[57]['datatype'] = 'right';

      $tab[104]['table'] = $this->getTable();
      $tab[104]['field'] = 'import_externalauth_users';
      $tab[104]['name'] = $LANG['profiles'][47];
      $tab[104]['linkfield'] = 'import_externalauth_users';
      $tab[104]['datatype'] = 'right';

      $tab[58]['table'] = $this->getTable();
      $tab[58]['field'] = 'group';
      $tab[58]['name'] = $LANG['Menu'][36];
      $tab[58]['linkfield'] = 'group';
      $tab[58]['datatype'] = 'right';

      $tab[59]['table'] = $this->getTable();
      $tab[59]['field'] = 'entity';
      $tab[59]['name'] = $LANG['Menu'][37];
      $tab[59]['linkfield'] = 'entity';
      $tab[59]['datatype'] = 'right';

      $tab[60]['table'] = $this->getTable();
      $tab[60]['field'] = 'transfer';
      $tab[60]['name'] = $LANG['transfer'][1];
      $tab[60]['linkfield'] = 'transfer';
      $tab[60]['datatype'] = 'right';

      $tab[61]['table'] = $this->getTable();
      $tab[61]['field'] = 'logs';
      $tab[61]['name'] = $LANG['Menu'][30];
      $tab[61]['linkfield'] = 'logs';
      $tab[61]['datatype'] = 'right';

      $tab[62]['table'] = $this->getTable();
      $tab[62]['field'] = 'backup';
      $tab[62]['name'] = $LANG['Menu'][12];
      $tab[62]['linkfield'] = 'backup';
      $tab[62]['datatype'] = 'right';

      $tab['ticket'] = $LANG['title'][24];

      $tab[102]['table'] = $this->getTable();
      $tab[102]['field'] = 'create_ticket';
      $tab[102]['name'] = $LANG['profiles'][5];
      $tab[102]['linkfield'] = 'create_ticket';
      $tab[102]['datatype'] = 'bool';

      $tab[65]['table'] = $this->getTable();
      $tab[65]['field'] = 'delete_ticket';
      $tab[65]['name'] = $LANG['profiles'][14];
      $tab[65]['linkfield'] = 'delete_ticket';
      $tab[65]['datatype'] = 'bool';

      $tab[66]['table'] = $this->getTable();
      $tab[66]['field'] = 'add_followups';
      $tab[66]['name'] = $LANG['profiles'][6];
      $tab[66]['linkfield'] = 'add_followups';
      $tab[66]['datatype'] = 'bool';

      $tab[67]['table'] = $this->getTable();
      $tab[67]['field'] = 'global_add_followups';
      $tab[67]['name'] = $LANG['profiles'][15];
      $tab[67]['linkfield'] = 'comment_all_ticket';
      $tab[67]['datatype'] = 'bool';

      $tab[68]['table'] = $this->getTable();
      $tab[68]['field'] = 'update_ticket';
      $tab[68]['name'] = $LANG['profiles'][18];
      $tab[68]['linkfield'] = 'update_ticket';
      $tab[68]['datatype'] = 'bool';

      $tab[69]['table'] = $this->getTable();
      $tab[69]['field'] = 'own_ticket';
      $tab[69]['name'] = $LANG['profiles'][16];
      $tab[69]['linkfield'] = 'own_ticket';
      $tab[69]['datatype'] = 'bool';

      $tab[70]['table'] = $this->getTable();
      $tab[70]['field'] = 'steal_ticket';
      $tab[70]['name'] = $LANG['profiles'][17];
      $tab[70]['linkfield'] = 'steal_ticket';
      $tab[70]['datatype'] = 'bool';

      $tab[71]['table'] = $this->getTable();
      $tab[71]['field'] = 'assign_ticket';
      $tab[71]['name'] = $LANG['profiles'][19];
      $tab[71]['linkfield'] = 'assign_ticket';
      $tab[71]['datatype'] = 'bool';

      $tab[72]['table'] = $this->getTable();
      $tab[72]['field'] = 'show_all_ticket';
      $tab[72]['name'] = $LANG['profiles'][7];
      $tab[72]['linkfield'] = 'show_all_ticket';
      $tab[72]['datatype'] = 'bool';

      $tab[73]['table'] = $this->getTable();
      $tab[73]['field'] = 'show_assign_ticket';
      $tab[73]['name'] = $LANG['profiles'][32];
      $tab[73]['linkfield'] = 'show_assign_ticket';
      $tab[73]['datatype'] = 'bool';

      $tab[74]['table'] = $this->getTable();
      $tab[74]['field'] = 'show_full_ticket';
      $tab[74]['name'] = $LANG['profiles'][8];
      $tab[74]['linkfield'] = 'show_full_ticket';
      $tab[74]['datatype'] = 'bool';

      $tab[75]['table'] = $this->getTable();
      $tab[75]['field'] = 'observe_ticket';
      $tab[75]['name'] = $LANG['profiles'][9];
      $tab[75]['linkfield'] = 'observe_ticket';
      $tab[75]['datatype'] = 'bool';

      $tab[76]['table'] = $this->getTable();
      $tab[76]['field'] = 'update_followups';
      $tab[76]['name'] = $LANG['profiles'][35];
      $tab[76]['linkfield'] = 'update_followups';
      $tab[76]['datatype'] = 'bool';

      $tab[77]['table'] = $this->getTable();
      $tab[77]['field'] = 'show_planning';
      $tab[77]['name'] = $LANG['profiles'][20];
      $tab[77]['linkfield'] = 'show_planning';
      $tab[77]['datatype'] = 'bool';

      $tab[78]['table'] = $this->getTable();
      $tab[78]['field'] = 'show_group_planning';
      $tab[78]['name'] = $LANG['profiles'][36];
      $tab[78]['linkfield'] = 'show_group_planning';
      $tab[78]['datatype'] = 'bool';

      $tab[79]['table'] = $this->getTable();
      $tab[79]['field'] = 'show_all_planning';
      $tab[79]['name'] = $LANG['profiles'][21];
      $tab[79]['linkfield'] = 'show_all_planning';
      $tab[79]['datatype'] = 'bool';

      $tab[85]['table'] = $this->getTable();
      $tab[85]['field'] = 'statistic';
      $tab[85]['name'] = $LANG['Menu'][13];
      $tab[85]['linkfield'] = 'statistic';
      $tab[85]['datatype'] = 'bool';

      $tab[86]['table'] = $this->getTable();
      $tab[86]['field'] = 'helpdesk_hardware';
      $tab[86]['name'] = $LANG['setup'][350];
      $tab[86]['linkfield'] = 'helpdesk_hardware';

      $tab[87]['table'] = $this->getTable();
      $tab[87]['field'] = 'helpdesk_item_type';
      $tab[87]['name'] = $LANG['setup'][352];
      $tab[87]['linkfield'] = 'helpdesk_item_type';

      $tab[88]['table'] = $this->getTable();
      $tab[88]['field'] = 'show_group_ticket';
      $tab[88]['name'] = $LANG['profiles'][26];
      $tab[88]['linkfield'] = 'show_group_ticket';
      $tab[88]['datatype'] = 'bool';

      $tab[89]['table'] = $this->getTable();
      $tab[89]['field'] = 'show_group_hardware';
      $tab[89]['name'] = $LANG['profiles'][27];
      $tab[89]['linkfield'] = 'show_group_hardware';
      $tab[89]['datatype'] = 'bool';

      $tab[94]['table'] = $this->getTable();
      $tab[94]['field'] = 'group_add_followups';
      $tab[94]['name'] = $LANG['profiles'][4];
      $tab[94]['linkfield'] = 'group_add_followups';
      $tab[94]['datatype'] = 'bool';

      $tab[95]['table'] = $this->getTable();
      $tab[95]['field'] = 'global_add_tasks';
      $tab[95]['name'] = $LANG['profiles'][45];
      $tab[95]['linkfield'] = 'global_add_task';
      $tab[95]['datatype'] = 'bool';

      $tab[96]['table'] = $this->getTable();
      $tab[96]['field'] = 'update_priority';
      $tab[96]['name'] = $LANG['profiles'][44];
      $tab[96]['linkfield'] = 'update_priority';
      $tab[96]['datatype'] = 'bool';

      $tab[97]['table'] = $this->getTable();
      $tab[97]['field'] = 'update_tasks';
      $tab[97]['name'] = $LANG['profiles'][46];
      $tab[97]['linkfield'] = 'update_tasks';
      $tab[97]['datatype'] = 'bool';

      $tab[98]['table'] = $this->getTable();
      $tab[98]['field'] = 'validate_ticket';
      $tab[98]['name'] = $LANG['profiles'][49];
      $tab[98]['linkfield'] = 'validate_ticket';
      $tab[98]['datatype'] = 'bool';

      $tab[99]['table'] = $this->getTable();
      $tab[99]['field'] = 'create_validation';
      $tab[99]['name'] = $LANG['profiles'][48];
      $tab[99]['linkfield'] = 'create_validation';
      $tab[99]['datatype'] = 'bool';

      $tab[100]['table'] = $this->getTable();
      $tab[100]['field'] = 'helpdesk_status';
      $tab[100]['name'] = $LANG['setup'][615];
      $tab[100]['linkfield'] = '';
      $tab[100]['nosearch'] = true;
      $tab[100]['shorthistory'] = true;

      $tab['other'] = $LANG['common'][62];

      $tab[63]['table'] = $this->getTable();
      $tab[63]['field'] = 'reminder_public';
      $tab[63]['name'] = $LANG['reminder'][1];
      $tab[63]['linkfield'] = 'reminder_public';
      $tab[63]['datatype'] = 'right';

      $tab[64]['table'] = $this->getTable();
      $tab[64]['field'] = 'bookmark_public';
      $tab[64]['name'] = $LANG['bookmark'][5];
      $tab[64]['linkfield'] = 'bookmark_public';
      $tab[64]['datatype'] = 'right';

      $tab[4]['table'] = $this->getTable();
      $tab[4]['field'] = 'password_update';
      $tab[4]['name'] = $LANG['profiles'][24];
      $tab[4]['linkfield'] = 'password_update';
      $tab[4]['datatype'] = 'bool';

      return $tab;
   }

   /**
    * Make a select box for a None Read Write choice
    *
    *
    *
    * @param $name select name
    * @param $value preselected value.
    * @param $none display none choice ?
    * @param $read display read choice ?
    * @param $write display write choice ?
    * @return nothing (print out an HTML select box)
    */
   static function dropdownNoneReadWrite($name,$value,$none=1,$read=1,$write=1) {
      global $LANG;

      if ($none) {
         $values['NULL'] = $LANG['profiles'][12];
      }
      if ($read) {
         $values['r'] = $LANG['profiles'][10];
      }
      if ($write) {
         $values['w'] = $LANG['profiles'][11];
      }
      Dropdown::showFromArray($name,$values,array('value'=>$value));
   }

   /**
   * Dropdown profiles which have rights under the active one
   *
   *    - name : string / name of the select (default is profiles_id)
   *    - value : integer / preselected value (default 0)
   * @param $options possible options
   */
   static function dropdownUnder($options=array()) {
      global $DB;

      $p['name']  = 'profiles_id';
      $p['value'] = '';

      if (is_array($options) && count($options)) {
         foreach ($options as $key => $val) {
            $p[$key]=$val;
         }
      }


      $profiles[0]=DROPDOWN_EMPTY_VALUE;

      $query="SELECT *
            FROM `glpi_profiles` ".
            Profile::getUnderActiveProfileRetrictRequest("WHERE")."
            ORDER BY `name`";
      $res = $DB->query($query);

      //New rule -> get the next free ranking
      if ($DB->numrows($res)) {
         while ($data = $DB->fetch_array($res)) {
            $profiles[$data['id']]=$data['name'];
         }
      }

      Dropdown::showFromArray($p['name'],$profiles,array('value' => $p['value']));
   }

   /**
    * Get the default Profile for new user
    *
    * @return integer profiles_id
    */

   static function getDefault() {
      global $DB;

      foreach ($DB->request('glpi_profiles', array('is_default'=>1)) as $data) {
         return $data['id'];
      }
      return 0;
   }

   static function getRightValue($value) {
      global $LANG;

      switch ($value) {
         case '':
            return $LANG['profiles'][12];
         case 'r':
            return $LANG['profiles'][10];
         case 'w';
            return $LANG['profiles'][11];
         default:
            return '';
      }
   }
   static function getInterfaceName($value) {
      global $LANG;

      switch ($value) {
         case 'central':
            return $LANG['common'][56];
         case 'helpdesk':
            return $LANG['Menu'][31];
      }
   }
}
?>
