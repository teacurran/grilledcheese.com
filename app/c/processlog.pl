#!/usr/bin/perl

$logdir = "${basedir}data/";
$dumpreal = "${basedir}data/referr.html";

opendir LOGDIR, "$logdir" or die "cant open Log die: $!";
@alllogs = readdir LOGDIR;
closedir LOGDIR;

$SIZE=@alllogs;

sub numsort
	{
	# Clear buffer array:
	%BUFFER = '';
	foreach $fname (keys %REF)
		{
		$rank = sprintf("%.6f",((1000000-$REF{$fname})/1000000));
		# If you're charting more than a million hits, you're in trouble!
		$BUFFER{"$rank---$fname"} = $REF{$fname};
		}
	%REF = %BUFFER;
	}

print "Content-type: text/html\n\n";

$| = 1;
for ($i=0;$i<=$SIZE;$i++)
   	{
   	$vars=$alllogs[$i];

	($articlename, $articleext) = split(/\./, $vars);
	if ($articleext eq 'log')
		{

		$tempfilename = "${basedir}data/$vars";

		open(LOGFILE,"$tempfilename");
		@linesthislog = <LOGFILE>;
		close(LOGFILE);
		$LOGSIZE = @linesthislog;

		for ($j=0;$j<=$LOGSIZE;$j++)
   			{
   			$tempvar=$linesthislog[$j];
			@tempvalues = split(/,/, $tempvar);
			$_ = $tempvalues[3];

			if (!/grilledcheese.com/)
				{
				if ( $REF{$tempvalues[3]} eq '')
					{
					$REF{$tempvalues[3]} = 1;
					}
				else
					{
					$REF{$tempvalues[3]} = $REF{$tempvalues[3]} + 1;
					}
				}
			}
		}
	}

$| = 0;

&numsort;
open (DUMPFILE,">$dumpreal");

foreach $linkname ( sort keys %REF)
	{
	($num, $value) = split(/---/, $linkname);
	print DUMPFILE "<B>$REF{$linkname} - </B><A Href=\"$value\">$value</A><BR>\n";
	print "<B>$REF{$linkname} - </B><A Href=\"$value\">$value</A><BR>\n";
	}
close(DUMPFILE);
