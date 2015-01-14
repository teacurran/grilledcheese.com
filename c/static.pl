#!/usr/bin/perl

require "../application.pl";

$main_template_file = "${basedir}${template_dir}${page_template}";
$fontpreal 		= "${basedir}img/font/preview/";
$pageslocation 	= "${basedir}static/$FORM{'page'}.txt";

open (TEMPLATEFILE,"$main_template_file");
 @T_LINES=<TEMPLATEFILE>;
close(TEMPLATEFILE);
$SIZE=@T_LINES;

for ($i=0;$i<=$SIZE;$i++)
	{
	$template = "$template$T_LINES[$i]";
	}

($header, $footer) = split(/<!--- %MAIN% --->/, $template);

open (STATIC,"$pageslocation") || die "Can't Open $pageslocation: $!\n";
@MAINTEXT = <STATIC>;
close(STATIC);
$SIZE=@MAINTEXT;

if ( $browser eq 'msie' )
	{
	$javafile = "${basedir}templates/javascript_ie.txt";
	}
else
	{
	$javafile = "${basedir}templates/javascript_ns.txt";
	}

if ( $bversion eq '4' )
	{
	open (JAVAFILE,"$javafile") || die "Can't Open $javafile: $!\n";
 	@J_LINES=<JAVAFILE>;
	close(JAVAFILE);
	$SIZEJAVA=@J_LINES;

	for ($i=0;$i<=$SIZEJAVA;$i++)
		{
		$java= "$java$J_LINES[$i]";
		}
	$header =~ s/<!--- %JAVA% --->/$java/g;
	}

$header =~ s/<!--- %TITLE% --->/$MAINTEXT[0]/g;
$footer =~ s/<!--- %QUOTE% --->/$quote_string/g;

print "Content-type: text/html\n\n";
print "$header\n";
for ($i=1;$i<=$SIZE;$i++)
	{
	print "$MAINTEXT[$i]";
	}
print "$footer\n";