#!/usr/bin/perl

require ("/app/application.pl");

$pageslocation = "/app/static/updates.txt";
$main_template_file = "${basedir}${template_dir}${page_template}";


undef $/;
open (TEMPLATEFILE,"$main_template_file");
 $template = <TEMPLATEFILE>;
close(TEMPLATEFILE);

($header, $footer) = split(/<!--- %MAIN% --->/, $template);

open (STATIC,"$pageslocation");
$maintext = <STATIC>;
close(STATIC);

$/ = "\n";
($title_var) = ($maintext =~ /(.*?)\n/);
$maintext =~ s/(.*?)\n//;


$header =~ s/<!--- %TITLE% --->/$title_var/g;
$footer =~ s/<!--- %QUOTE% --->/$hits_val/g;

print "Content-type: text/html\n\n";
print "$header\n";
print "$maintext\n";
print "$footer\n";
