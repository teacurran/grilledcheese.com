#!/usr/bin/perl

$filevalue = $ENV{'DOCUMENT_URI'};
$filevalue =~ s/\///g;
$filevalue =~ s/\.//g;

$dbmfile = "${basedir}counters/counter";

dbmopen %COUNTERS, $dbmfile, 0666;
	$COUNTERS{$filevalue} = $COUNTERS{$filevalue} + 1;
	$Hits = $COUNTERS{$filevalue};
dbmclose %COUNTERS;

$Ones = $Hits % 10;
$Hits = ($Hits - $Ones) / 10;
$Tens = $Hits % 10;
$Hits = ($Hits - $Tens) / 10;
$Hundreds = $Hits % 10;
$Hits = ($Hits - $Hundreds) / 10;
$Thousands = $Hits % 10;
$Hits = ($Hits - $Thousands) / 10;

@Roman_Ones = ("I","II","III","IV","V","VI","VII","VIII","IX");
@Roman_Tens = ("X","XX","XXX","XL","L","LX","LXX","LXXX","XC");
@Roman_Hundreds = ("C","CC","CCC","CD","D","DC","DCC","DCCC","CM");
@Roman_Thousands = ("M","MM","MMM","MW","W","WM","WMM","WMMM","WQ");
print "Content-type: text/html\n\n";
for ($i=0; $i < $Hits; $i++)
	{print "Q";}
if ($Thousands)
	{print"@Roman_Thousands[$Thousands]";}
if ($Hundreds)
	{print"@Roman_Hundreds[$Hundreds-1]";}
if ($Tens)
	{print "@Roman_Tens[$Tens-1]";}
if ($Ones)
	{print "@Roman_Ones[$Ones-1]";}