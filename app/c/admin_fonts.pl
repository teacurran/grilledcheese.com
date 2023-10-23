#!/usr/bin/perl


require "../application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";

$maintemplate = <<'EOT';

<HTML>
<BODY BGCOLOR="000000" TEXT="FFFFFF" LINK="FFFFFF" VLINK="FFFFFF">

<CENTER>

<TABLE BORDER=1>
	<TR>
		<TD>
			%currentfonts%
		</TD>
	</TR>
	<TR>
		<TD>
			<FORM METHOD="post">
			<INPUT TYPE="hidden" NAME="action" VALUE="insert">
			<TABLE BORDER=0 CELLPADDING=5 CELLSPACING=0>
				<TR>
					<TD ALIGN="RIGHT"><B>ID Name:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%fname%" NAME="fname"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Name:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%name%" NAME="name"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Height:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%height%" NAME="height"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Width:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%width%" NAME="width"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Order Flag:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%orderflag%" NAME="orderflag"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Price:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%price%" NAME="price"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>PC Chars:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%pcchars%" NAME="pcchars"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>MAC Chars:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%macchars%" NAME="macchars"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Created:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%created%" NAME="created"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Modifyed:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%modify%" NAME="modify"></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Notes:</B></TD>
					<TD><TEXTAREA NAME="notes" WRAP="VIRTUAL" COLS=35 ROWS=8>%notes%</TEXTAREA></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>Teaser:</B></TD>
					<TD><TEXTAREA NAME="teaser" WRAP="VIRTUAL" COLS=35 ROWS=8>%teaser%</TEXTAREA></TD>
				</TR>
				<TR>
					<TD ALIGN="RIGHT"><B>New:</B></TD>
					<TD><INPUT TYPE="TEXT" SIZE=10 VALUE="%new%" NAME="new"></TD>
				</TR>
				<TR>
					<TD COLSPAN=2><INPUT TYPE="submit" VALUE="INSERT"></TD>
				</TR>
			</TABLE>
			</FORM>
		</TD>
	</TR>
</TABLE>

</CENTER>

</HTML>

EOT

if ( $FORM{'action'} eq '' )
	{
	$action = "main";
	}
else
	{
	$action = $FORM{'action'};
	}

$fname = $FORM{'fname'};

dbmopen %FONTS, $fontsdbm, 0666;
	if ( $action eq "insert" )
		{
		$fontvalues = "$FORM{'name'}:|:$FORM{'height'}:|:$FORM{'width'}:|:$FORM{'orderflag'}:|:$FORM{'price'}:|:$FORM{'pcchars'}:|:$FORM{'macchars'}:|:$FORM{'created'}:|:$FORM{'modify'}:|:$FORM{'notes'}:|:$FORM{'teaser'}:|:$FORM{'new'}";
		$FONTS{$fname} = $fontvalues;

		if ( $FORM{'name'} eq 'delete' )
			{
			delete $FONTS{$fname};
			}
		}
	elsif ( $FORM{'fname'} )
		{
		$fontvalues = $FONTS{$fname};
		}

	foreach $val(sort keys %FONTS)
		{
		$currentfonts = "${currentfonts} <BR>\n <A Href=\"insertfont.pl?action=edit&fname=${val}\">${val}</A>\n";
		}
dbmclose %FONTS;

@thisitem 	= split(/:\|:/, $fontvalues);
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
$new 		= $thisitem[11];
$updated 	= $thisitem[12];

$maintemplate =~ s/%currentfonts%/$currentfonts/g;
$maintemplate =~ s/%fname%/$fname/g;
$maintemplate =~ s/%name%/$name/g;
$maintemplate =~ s/%height%/$height/g;
$maintemplate =~ s/%width%/$width/g;
$maintemplate =~ s/%orderflag%/$orderflag/g;
$maintemplate =~ s/%price%/$price/g;
$maintemplate =~ s/%pcchars%/$pcchars/g;
$maintemplate =~ s/%macchars%/$macchars/g;
$maintemplate =~ s/%created%/$created/g;
$maintemplate =~ s/%modify%/$modify/g;
$maintemplate =~ s/%notes%/$notes/g;
$maintemplate =~ s/%teaser%/$teaser/g;
$maintemplate =~ s/%new%/$new/g;

print "Content-type: text/html\n\n";
print "+$FORM{'action'}+\n\n";
print "+${fontvalues}+\n\n";
print $maintemplate;