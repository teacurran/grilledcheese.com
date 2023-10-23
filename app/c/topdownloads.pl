#!/usr/bin/perl

require "../application.pl";
$counterdir = "${basedir}data/counters/fonts/";

opendir COUNTDIR, "$counterdir" or die "cant open counter die: $!";
@allcounters = readdir COUNTDIR;
closedir COUNTDIR;

$SIZE=@allcounters;

sub numsort
{
# %STAT_ARRAY is now a large associative array holding ($value,$num_hits)
# pairs for all the relevant data.  We want to give the ability to sort
# based on number of hits instead of the default alpha-sort.  The
# $STATE{'numsort'} variable controls this.  To create a sorted array on
# the number of hits, we rebuild STAT_ARRAY as ($num_hits-$value,$num_hits)
# then alpha sort again.  Of course logical sorts like by hour and by
# weekday will be unaffected.

# Clear buffer array:
%BUFFER = '';
foreach $fname (keys %FONTV)
	{
	$rank = sprintf("%.6f",((1000000-$FONTV{$fname})/1000000));
	# If you're charting more than a million hits, you're in trouble!
	$BUFFER{"$rank-$fname"} = $FONTV{$fname};
	}
%FONTV = %BUFFER;
# Done.
}

for ($i=0;$i<=$SIZE;$i++)
   	{
   		$vars=$allcounters[$i];

		$tempfilename = "${basedir}data/counters/fonts/$vars";

		open(FONTVALUECOUNT,"$tempfilename");
		$HitsThisFont = <FONTVALUECOUNT>;
		close(FONTVALUECOUNT);

		($fname, $fplat, $ftype) = split(/\./, $vars);

		if ($fname ne '')
		{
			$FONTV{$fname} = $FONTV{$fname} + $HitsThisFont;
		}

	}

$LastDFName = "${basedir}data/counters/lastfont.txt";
open(LAST,"$LastDFName");
$LastDF = <LAST>;
close(LAST);

print "Content-type: text/html\n\n";

$header = <<'EOT';

<HTML>
<BODY BGCOLOR="#FFFFFF" TEXT="#FFFFFF" LINK="#FFFFFF" VLINK="#FFFFFF" ALINK="#FFFFFF">

<HEAD><TITLE>-------(grilledcheese.com)--------</TITLE></HEAD>
<IMG SRC="/img/leftcornersmall.gif" ALIGN="Left">
<CENTER>
&nbsp;<BR>
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD VALIGN="BOTTOM"><IMG SRC="/img/border/l1.gif"></TD><TD VALIGN="BOTTOM" WIDTH=197><IMG SRC="/img/border/top.gif" WIDTH=197></TD><TD VALIGN="BOTTOM"><IMG SRC="/img/border/r1.gif"></TD></TR><TR><TD VALIGN="TOP" ALIGN="RIGHT"><IMG SRC="/img/border/l2.gif" WIDTH=37 HEIGHT=121></TD><TD ALIGN="CENTER" ROWSPAN=2 BGCOLOR="#000000" WIDTH=197>

EOT

$footer = <<'EOT';

<TR><TD COLSPAN=3 ALIGN="CENTER">
<BR><BR>X = Last Downloaded Font.<BR><BR>
</TD></TR>
</TD></TR></TABLE>
</TD><TD VALIGN="TOP"><IMG SRC="/img/border/r2.gif"></TD></TR></TABLE>
</CENTER>
<BR><BR>
</HTML>

EOT

print $header;
print "<TABLE BORDER=0 CELLPADDING=3 CELLSPACING=0>";
print "<TR><TD COLSPAN=3><BR><FONT SIZE=\"+2\"<B>Top Downloads</B></FONT></TD></TR>";

&numsort;
$totaldownload = 0;
$i = 0;

foreach $fname ( sort keys %FONTV)
	{
	$i++;
	($num, $value) = split(/-/, $fname);
	$totaldownload = $totaldownload + $FONTV{$fname};

	if ( $i == 1 )
		{
		$bar_divide = $FONTV{$fname} / 100;
		}

	$this_bar_size = $FONTV{$fname} / $bar_divide;
	$bar_left = $this_bar_size;

	print "<TR><TD ALIGN=\"RIGHT\" VALIGN=\"TOP\"><B><A Href=\"fontview2.pl?fname=$value\">$value</A></B>";

	print "</TD><TD><B>";

	if ($LastDF eq $value) {print 'X</B>';}
	else {print '&nbsp;</B>';}

	print "</TD><TD><B>";
	print "$FONTV{$fname}</B></TD>";

	print "<TD>";
	while ( $bar_left > 0 )
		{
		if ( $bar_left >= 100 )
			{
			$bar_left = $bar_left - 100;
			print '<IMG SRC="/img/bar/bar_100.gif">';
			}
		elsif ( $bar_left >= 50 )
			{
			$bar_left = $bar_left - 50;
			print '<IMG SRC="/img/bar/bar_50.gif">';
			}
		elsif ( $bar_left >= 25 )
			{
			$bar_left = $bar_left - 25;
			print '<IMG SRC="/img/bar/bar_25.gif">';
			}
		elsif ( $bar_left >= 10 )
			{
			$bar_left = $bar_left - 10;
			print '<IMG SRC="/img/bar/bar_10.gif">';
			}
		elsif ( $bar_left >= 5 )
			{
			$bar_left = $bar_left - 5;
			print '<IMG SRC="/img/bar/bar_5.gif">';
			}
		elsif ( $bar_left >= 1 )
			{
			$bar_left = $bar_left - 1;
			print '<IMG SRC="/img/bar/bar_1.gif">';
			}
		elsif ( $bar_left > 0 )
			{
			$bar_left = 0;
			}
		}
	print "</TD>";

	print "</TR>\n";
	}

print '<TR><TD COLSPAN=3>&nbsp;</TD></TR><TR><TD ALIGN="RIGHT" VALIGN="TOP"><B>Total Downloads</A></B>';

print '</TD><TD><B>&nbsp;</B>';

print '</TD><TD><B>';
print "$totaldownload</B></TD></TR>\n";


print $footer;