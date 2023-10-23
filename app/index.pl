#!/usr/bin/perl
use strict;
use warnings;

require ("/app/application.pl");

our $basedir;
our $template_dir;
our $page_template;

my $pageslocation = "/app/static/updates.txt";
my $main_template_file = "${basedir}${template_dir}${page_template}";

my $template;
undef $/;
open (TEMPLATEFILE,"$main_template_file");
 $template = <TEMPLATEFILE>;
close(TEMPLATEFILE);

my ($header, $footer) = split(/<!--- %MAIN% --->/, $template);

open (STATIC,"$pageslocation");
my $maintext = <STATIC>;
close(STATIC);

$/ = "\n";
my ($title_var) = ($maintext =~ /(.*?)\n/);
$maintext =~ s/(.*?)\n//;

my $hits_val;

$header =~ s/<!--- %TITLE% --->/$title_var/g;
$footer =~ s/<!--- %QUOTE% --->/$hits_val/g;

print "Content-type: text/html\n\n";
print "$header\n";
print "$maintext\n";
print "$footer\n";
