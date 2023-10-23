#!/usr/bin/perl -W
use DB_File;

require "/app/application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";
$main_template_file = "${basedir}${template_dir}${page_template}";
$fontpreal = "${basedir}img/font/preview/";
$fontdata = "${basedir}data/font_data.txt";

open (TEMPLATEFILE,"$main_template_file") || die "Can't open '$templatefile': $!\n";
 @T_LINES=<TEMPLATEFILE>;
close(TEMPLATEFILE);
$SIZE=@T_LINES;

for ($i=0;$i<=$SIZE;$i++) {
	$template = "$template$T_LINES[$i]";
}


open (FONT_DATA,"$fontdata") || die "Can't Open $fontdata: $!\n";
	@LINES=<FONT_DATA>;
close(FONT_DATA);
$SIZE=@LINES;
for ($i=0;$i<=$SIZE;$i++) {
	@thisitem 	= split(/:\|:/, $LINES[$i]);
	if ($thisitem[0] ne '') {
		$FONTS{$thisitem[0]} = $LINES[$i];
	}
}	


($header, $footer) = split(/<!--- %MAIN% --->/, $template);
$header =~ s/<!--- %TITLE% --->/Grilledcheese.com: F O N T S/g;

$loopcount = 0;

#dbmopen %FONTS, $fontsdbm, 0666;

	@dbmkeys = keys %FONTS;
	$dbmsize = @dbmkeys;
	$halfsize = $dbmsize / 2;

	print "Content-type: text/html\n\n";
	print "$header\n";
	print "<CENTER>";
	print "\n\n";

	print "<TABLE BORDER=0 CELLPADDING=5 CELLSPACING=2 WIDTH=400>\n";
	print "	<TR>\n";
	print "		<TD ALIGN=CENTER COLSPAN=2><B><FONT COLOR=\"FF0000\" FACE=\"Airal,Helvetica\">*&nbsp\;</FONT> = Free Font</B></TD>\n";
	print "	<TR>\n";
	print "		<TD>\n";

	foreach $val(sort keys %FONTS)
		{
		$loopcount++;
		@thisitem 	= split(/:\|:/, $FONTS{$val});
		$name 		= $thisitem[1];
		$height 	= $thisitem[2];
		$width 		= $thisitem[3];
		$orderflag 	= $thisitem[4];
		$price 		= $thisitem[5];
		$pcchars   	= $thisitem[6];
		$macchars  	= $thisitem[7];
		$created 	= $thisitem[8];
		$modify 	= $thisitem[9];
		$notes 		= $thisitem[10];
		$teaser 	= $thisitem[11];
		$new	 	= $thisitem[12];

		if ($price <= 0)
			{
			print '<FONT COLOR="FF0000"><B>*&nbsp;</B></FONT>';
			}
		else
			{
			print '<B>&nbsp;&nbsp;&nbsp;</B>';
			}
		print "<A Href=\"/c/fonts.pl/fname=${val}\">$name</A><BR>\n";

		if ( $loopcount >= $halfsize && $loopcount < $halfsize + 1)
			{
			print "		</TD>\n		<TD>\n";
			}
		}

		print "		</TD>\n";
		print "	</TR>\n";
		print "</TABLE>\n";
		print "</CENTER>\n";

print "$footer\n";
