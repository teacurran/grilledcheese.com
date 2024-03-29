#!/usr/bin/perl -w

require "../application.pl";

$fname = $FORM{'fname'};
$foundfont = 1;

$fonturl = "/fonts/";
$fontreal = "${basedir}fonts/";
$fontimgreal = "${basedir}img/font/";

$fontsdbm = "${basedir}data/dbm/fonts";

$main_template_file = "${basedir}${template_dir}${page_template}";
$content_template_file = "${basedir}${template_dir}fonts.html";
$downloads_template_file = "${basedir}${template_dir}downloads.html";

undef $/;

open (TEMPLATEFILE,"$main_template_file") || die "Can't Open $templatefile: $!\n";
 $template = <TEMPLATEFILE>;
close(TEMPLATEFILE);
open (TEMPLATEFILE,"$content_template_file") || die "Can't Open $content_template_file: $!\n";
 $content_template = <TEMPLATEFILE>;
close(TEMPLATEFILE);
open (TEMPLATEFILE,"$downloads_template_file") || die "Can't Open $downloads_template_file: $!\n";
 $download_template = <TEMPLATEFILE>;
close(TEMPLATEFILE);

($header, $footer) = split(/<!--- %MAIN% --->/, $template);

dbmopen %FONTS, $fontsdbm, 0666;
	$fontvalues = $FONTS{$fname};
dbmclose %FONTS;

@thisitem = split(/:\|:/, $fontvalues);
$printname = $thisitem[0];
$fontheight = $thisitem[1];
$fontwidth =  $thisitem[2];
$orderflag =  $thisitem[3];
$fontprice =  $thisitem[4];
$pcchars   	= $thisitem[5];
$macchars  	= $thisitem[6];
$created 	= $thisitem[7];
$modify 	= $thisitem[8];
$notes 		= $thisitem[9];
$teaser 	= $thisitem[10];
$new 		= $thisitem[11];
$makambo	= $thisitem[12];

if ($fname eq '')
	{
 	$foundfont = 0;
 	}

if ($fontvalues eq '')
	{
 	$foundfont = 0;
 	}

if ($foundfont eq 0)
	{
	print "Status: 302 Found\n";
	print "Expires: 31 Dec 2020\n";
	print "Location: http://www.grilledcheese.com/\n\n";
	}

if (-e "$fontimgreal$fname.gif") {
  	$fimgname = "${fname}.gif";
} else {
  	$fimgname = 'previewmissing.gif';
}

$downinfo = "";
$fontmacttf = "mac/". $fname ."ttf\.sit\.hqx";
$fontmacps = "mac/". $fname ."ps\.sit\.hqx";
$fontpcttf = "pc/". $fname ."ttf\.zip";
$fontpcps = "pc/". $fname ."ps\.zip";

$insertcount = 0;
sub insertvalue {
	my ($strName, $strRealName, $strCounterName, $strLink, $strImage, $strType, $strTemplate) = @_;
	my $filesizekb, $filesize, $HitsThisFile;
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
$content_template =~ s/%fname%/$fname/g;

if (length($notes)) {
	$content_template =~ s/(<!--- NOTES)(.*?)(--->)/$2/gs;
	$content_template =~ s/%notes%/$notes/g;
}

if (length($makambo) && $orderflag eq 1) {
	$content_template =~ s/(<!--- MAKAMBO)(.*?)(--->)/$2/gs;
	$content_template =~ s/%makambo_link%/$makambo/g;
}

if ($orderflag eq 1) {
	$content_template =~ s/(<!--- MAILORDER)(.*?)(--->)/$2/gs;
}

if ( $insertcount gt 0 ) {
	$content_template =~ s/(<!--- DOWNLOADS)(.*?)(--->)/$2/gs;
	$content_template =~ s/%downloads%/$downinfo/gs;
}

$header =~ s/<!--- %TITLE% --->/Grilledcheese.com : $printname/g;

print "Content-type: text/html\n\n";
print $header;
print $content_template;
print $footer;