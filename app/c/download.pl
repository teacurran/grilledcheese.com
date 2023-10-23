#!/usr/bin/perl -W

$FORM{platform} = 'pc';
$FORM{font} = 'none';
$FORM{type} = 'ttf';
$endtag = '.zip';

require "../application.pl";

if ($FORM{platform} eq "mac")
{
	$endtag = ".sit.hqx";
}

$fontreaname = "/app/fonts/$FORM{platform}/$FORM{font}$FORM{type}$endtag";

if (-e "$fontreaname")
{
	$counterfname = "/app/data/counters/fonts/$FORM{font}.$FORM{platform}.$FORM{type}";

	open(LOG, ">>",  "/home/api/grilledcheese.com/log.txt");
		print LOG "$counterfname\n";
	close LOG;

	if (-e "$counterfname")
		{
		open(COUNT,"$counterfname");
			$Hits = <COUNT>;
		close(COUNT);
		}
	else
		{
		$Hits = 0
		}

	$Hits++;
	open(COUNT,">$counterfname");
		print COUNT $Hits;
	close(COUNT);

$LastDFName = "/app/data/counters/lastfont.txt";
open(LAST,">$LastDFName");
print LAST $FORM{font};
close(LAST);


	print "Status: 302 Found\n";
	print "Location: /fonts/$FORM{platform}/$FORM{font}$FORM{type}$endtag\n\n";
}
else
{
	print "Status: 302 Found\n";
	print "Location: /error/fontnotfound.html\n\n";
}
