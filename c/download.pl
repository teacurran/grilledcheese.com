#!/usr/bin/perl

$FORM{platform} = 'pc';
$FORM{font} = 'none';
$FORM{type} = 'ttf';
$endtag = '.zip';

require "../application.pl";

if ($FORM{platform} eq "mac")
{
	$endtag = ".sit.hqx";
}

$fontreaname = "/home/tea/grill/fonts/$FORM{platform}/$FORM{font}$FORM{type}$endtag";

if (-e "$fontreaname")
{
	$counterfname = "/home/tea/grill/data/counters/fonts/$FORM{font}.$FORM{platform}.$FORM{type}";

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

$LastDFName = "/home/tea/grill/data/counters/lastfont.txt";
open(LAST,">$LastDFName");
print LAST $FORM{font};
close(LAST);


	print "Status: 302 Found\n";
	print "Location: http://www.grilledcheese.com/fonts/$FORM{platform}/$FORM{font}$FORM{type}$endtag\n\n";
}
else
{
	print "Status: 302 Found\n";
	print "Location: http://www.grilledcheese.com/error/fontnotfound.html\n\n";
}