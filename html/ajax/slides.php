<?php
header( "Content-type: text/xml" );
?>
<slides>
<?php
if ($handle = opendir('images')) {

while (false !== ($file = readdir($handle)))
{
        if ( preg_match( "/[.]jpg$/", $file ) ) {
                preg_match( "/_(\d+)_(\d+)[.]/", $file, $found );
?>
<slide src="images/<?php echo $file; ?>" 
  width="<?php echo $found[1]; ?>"
  height="<?php echo $found[2]; ?>" /><?php echo( "\n" ); ?>
<?php
        }
}
closedir($handle);
}
?>
</slides>
