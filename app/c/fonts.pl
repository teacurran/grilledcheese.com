#!/usr/bin/perl -W
use strict;
use warnings;
use diagnostics;
use DB_File;

require "/app/application.pl";

our (%FORM, $basedir, $template_dir, $page_template);

my $fname = $FORM{'fname'};
my $foundfont = 1;

my $fonturl = "/fonts/";
my $fontreal = "${basedir}fonts/";
my $fontimgreal = "${basedir}img/font/";
my $fontsdbm = "${basedir}data/dbm/fonts";
my $fontdata = "${basedir}data/font_data.txt";
my $fh;

my $main_template_file = "/${basedir}${template_dir}${page_template}";
my $content_template_file = "${basedir}${template_dir}fonts.html";
my $downloads_template_file = "${basedir}${template_dir}downloads.html";

my %FONTS;
open ($fh, '<', $fontdata) or die "Can't Open $fontdata: $!";
while (my $line = <$fh>) {
    chomp $line;
    my @thisLine = split(/:\|:/, $line);
    if ($thisLine[0] and $thisLine[0] ne '') {
        $FONTS{$thisLine[0]} = $line;
    }
}
close($fh);

my ($template, $content_template, $download_template);
open ($fh, '<', $main_template_file) || die "Can't Open main_template_file: $main_template_file: $!\n";
{
  local $/ = undef;
  $template = <$fh>;
}
close($fh);
open ($fh, '<', $content_template_file) || die "Can't Open content_template_file: $content_template_file: $!\n";
{
  local $/ = undef;
  $content_template = <$fh>;
}
close($fh);

open ($fh, '<', $downloads_template_file) || die "Can't Open downloads_template_file: $downloads_template_file: $!\n";
{
  local $/ = undef;
  $download_template = <$fh>;
}
close($fh);

my ($header, $footer) = split(/<!--- %MAIN% --->/, $template);

my $fontValues = $FONTS{$fname};

my @thisItem = split(/:\|:/, $fontValues);
my $printname = $thisItem[1];
my $fontheight = $thisItem[2];
my $fontwidth =  $thisItem[3];
my $orderflag =  $thisItem[4];
my $fontprice =  $thisItem[5];
my $pcchars   	= $thisItem[6];
my $macchars  	= $thisItem[7];
my $created 	= $thisItem[8];
my $modify 	= $thisItem[9];
my $notes 		= $thisItem[10];
my $teaser 	= $thisItem[11];
my $new 		= $thisItem[12];
my $makambo	= $thisItem[13];

if ($fname eq '')
	{
 	$foundfont = 0;
 	}

if ($fontValues eq '')
	{
 	$foundfont = 0;
 	}

if ($foundfont eq 0)
	{
	print "Status: 404 Not Found\n";
	print "Expires: 31 Dec 2020\n\n";
	print "fname: $fname not found\n\n";
	}

my $fimgname;
if (-e "$fontimgreal$fname.gif") {
  	$fimgname = "${fname}.gif";
} else {
  	$fimgname = 'previewmissing.gif';
}

our $downinfo = "";
my $fontmacttf = "mac/". $fname ."ttf\.sit\.hqx";
my $fontmacps = "mac/". $fname ."ps\.sit\.hqx";
my $fontpcttf = "pc/". $fname ."ttf\.zip";
my $fontpcps = "pc/". $fname ."ps\.zip";
our ($fontreaname, $fontname, $fontcountername, $link, $imagename, $fonttype);

our $insertcount = 0;
sub insertvalue {
	my ($strName, $strRealName, $strCounterName, $strLink, $strImage, $strType, $strTemplate) = @_;
	my ($filesizekb, $filesize, $HitsThisFile);
	$insertcount++;

	open(FILEHITS,"$strCounterName");
	$HitsThisFile = <FILEHITS>;
	close(FILEHITS);

	if ($HitsThisFile eq '')
		{
		$HitsThisFile = 0;
		}
	$filesize = -s $fontreaname;
	$filesizekb = ($filesize / 1024);
	$filesizekb = int ($filesizekb * 100);
	$filesizekb = ($filesizekb / 100);

	$strTemplate =~ s/%download_link%/$strLink/g;
	$strTemplate =~ s/%imagename%/$strImage/g;
	$strTemplate =~ s/%fonttype%/$strType/g;
	$strTemplate =~ s/%filesizekb%/$filesizekb/g;
	$strTemplate =~ s/%download_count%/$HitsThisFile/g;
	$strTemplate =~ s/%filename%/$strName/g;

	$downinfo .= $strTemplate;
}

if (-e "$fontreal$fontmacttf")
    {
	$fontname = "${fname}ttf.sit.hqx";
	$fontreaname = "${basedir}fonts/mac/$fontname";
	$fontcountername = "${basedir}data/counters/fonts/$fname.mac.ttf";
	$link = "/c/download.pl/font=$fname/platform=mac/type=ttf/get=$fname.html";
	$imagename = "apple_d.gif";
	$fonttype = "TTF";
	&insertvalue ($fontname, $fontreaname, $fontcountername, $link, $imagename, $fonttype, $download_template);
	}

 if (-e "$fontreal$fontmacps")
    {
	$fontname = "${fname}ps.sit.hqx";
	$fontreaname = "${basedir}fonts/mac/$fontname";
	$fontcountername = "${basedir}data/counters/fonts/$fname.mac.ps";
	$link = "/c/download.pl/font=$fname/platform=mac/type=ps/get=$fname.html";
	$imagename = "apple_d.gif";
	$fonttype = "PS";
	&insertvalue ($fontname, $fontreaname, $fontcountername, $link, $imagename, $fonttype, $download_template);
    }

 if (-e "$fontreal$fontpcttf")
    {
	$fontname = "${fname}ttf.zip";
	$fontreaname = "${basedir}fonts/pc/$fontname";
	$fontcountername = "${basedir}data/counters/fonts/$fname.pc.ttf";
	$link = "/c/download.pl/font=$fname/platform=pc/type=ttf/get=$fname.html";
	$imagename = "windows_d.gif";
	$fonttype = "TTF";
	&insertvalue ($fontname, $fontreaname, $fontcountername, $link, $imagename, $fonttype, $download_template);
    }

 if (-e "$fontreal$fontpcps")
    {
	$fontname = "${fname}ps.zip";
	$fontreaname = "${basedir}fonts/pc/$fontname";
	$fontcountername = "${basedir}data/counters/fonts/$fname.pc.ps";
	$link = "/c/download.pl/font=$fname/platform=pc/type=ps/get=$fname.html";
	$imagename = "windows_d.gif";
	$fonttype = "PS";
	&insertvalue ($fontname, $fontreaname, $fontcountername, $link, $imagename, $fonttype, $download_template);
    }


$content_template =~ s/<!--- %printname% --->/$printname/g;
$content_template =~ s/<!--- %fimgname% --->/$fimgname/g;
$content_template =~ s/<!--- %fontheight% --->/$fontheight/g;
$content_template =~ s/<!--- %fontprice% --->/$fontprice/g;
$content_template =~ s/<!--- %macchars% --->/$macchars/g;
$content_template =~ s/<!--- %pcchars% --->/$pcchars/g;
$content_template =~ s/<!--- %created% --->/$created/g;
$content_template =~ s/<!--- %modify% --->/$modify/g;
$content_template =~ s/<!--- %fname% --->/$fname/g;

$content_template =~ s/%printname%/$printname/g;
$content_template =~ s/%fontprice%/$fontprice/g;
$content_template =~ s/%fname%/$fname/g;

$content_template =~ s/%fname%/$fname/g;

if (length($notes)) {
	$content_template =~ s/(<!--- NOTES)(.*?)(--->)/$2/gs;
	$content_template =~ s/%notes%/$notes/g;
}

#if (length($makambo) && $orderflag eq 1) {
#	$content_template =~ s/(<!--- MAKAMBO)(.*?)(--->)/$2/gs;
#	$content_template =~ s/%makambo_link%/$makambo/g;
#}

if ($orderflag eq 1) {
	$content_template =~ s/(<!--- PAYPAL)(.*?)(--->)/$2/gs;
}

if ( $insertcount gt 0 ) {
	$content_template =~ s/(<!--- DOWNLOADS)(.*?)(--->)/$2/gs;
	$content_template =~ s/%downloads%/$downinfo/gs;
}

# Cleanup leftover comments
$content_template =~ s/(<!---)(.*?)(--->)//gs;

$header =~ s/<!--- %TITLE% --->/Grilledcheese.com : $printname/g;


print "Content-type: text/html\n\n";
print $header;
print $content_template;
print $footer;
