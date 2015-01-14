#!/usr/bin/perl

require "../application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";
$main_template_file = "${basedir}${template_dir}${page_template}";
$fontpreal = "${basedir}img/font/preview/";

open (TEMPLATEFILE,"$main_template_file") || die "Can't Open $templatefile: $!\n";
 @T_LINES=<TEMPLATEFILE>;
close(TEMPLATEFILE);
$SIZE=@T_LINES;

for ($i=0;$i<=$SIZE;$i++)
	{
	$template = "$template$T_LINES[$i]";
	}

($header, $footer) = split(/<!--- %MAIN% --->/, $template);
$header =~ s/<!--- %TITLE% --->/Grilledcheese.com: F O N T S/g;

$loopcount = 0;

dbmopen %FONTS, $fontsdbm, 0666;

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
		$name 		= $thisitem[0];
		$height 	= $thisitem[1];
		$width 		= $thisitem[2];
		$orderflag 	= $thisitem[3];
		$price 		= $thisitem[4];
		$pcchars   	= $thisitem[5];
		$macchars  	= $thisitem[6];
		$created 	= $thisitem[7];
		$modify 	= $thisitem[8];
		$notes 		= $thisitem[9];
		$teaser 	= $thisitem[10];
		$new	 	= $thisitem[11];

		if ($price <= 0)
			{
			print '<FONT COLOR="FF0000"><B>*&nbsp;</B></FONT>';
			}
		else
			{
			print '<B>&nbsp;&nbsp;&nbsp;</B>';
			}
		print "<A Href=\"http://grilledcheese.com/c/fonts.pl/fname=${val}/\">$name</A><BR>\n";

		if ( $loopcount >= $halfsize && $loopcount < $halfsize + 1)
			{
			print "		</TD>\n		<TD>\n";
			}
		}

		print "		</TD>\n";
		print "	</TR>\n";
		print "</TABLE>\n";
		print "</CENTER>\n";
dbmclose %FONTS;

print "$footer\n";