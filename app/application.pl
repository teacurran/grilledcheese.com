#!/usr/bin/perl
use Apache2::RequestRec;
use Apache2::RequestUtil;

#############################################################
# application.pl  Version 6.6.6
# Copyright 1998-99 TeA Curran
# Created 12/28/98 Last Modified 12/28/98
#
# Notes:   	This Script will be called before most scripts
# 			to set core commenly used variables.  done all
# 			cold fusion style, either that or call it
# 			global.pl. heh
#
#############################################################
my $date_command = "/bin/date";
our $basedir = "/app/";
our $template_dir = "templates/";

our $time 			= `$date_command +"%H:%M:%S"`; chop($time);
our $day 			= `$date_command +"%m_%d_%y"`; chop($day);
our $r = Apache2::RequestUtil->request;

our $user_agent = $r->headers_in->{'User-Agent'};

our $browser_name = "";
our $browser_version = "";
our $browser_key = "";

# BROWSER CHECK
if ($user_agent =~ /MSIE/) {
	$browser_name = "Microsoft Internet Explorer";
	$browser_key = "ie";
	$name_version = $user_agent;
	$name_version =~ s/(^.*)(MSIE.*)(\;.*)/$2/g;
	($browser_name, $browser_version) = split(/ /, $name_version);
} else {
	$name_version = $user_agent;
	$name_version =~ s/(^.*\/\S*)(\s)(.*$)/$1/g;
	($browser_name, $browser_version) = split(/\//, $name_version);
	$browser_key = lc($browser_name);
}

$browser_version =~ s/(^[^0123456789]*)(\d*)(\.*)(\d*)([^0123456789]*$)/$2$3$4/g;

if (!isNumeric($browser_version)) {
	$browser_version = 0;
}

if ($browser_key eq "mozilla" && $browser_version < 5) {
	$browser_key = "netscape";
}
# END BROWSER CHECK

$template_dir .= "4.0/";
$page_template = "mozilla.html";

# if ($browser_version >= 4) {
# 	if ($browser_key eq "netscape") {
# 		$template_dir .= "4.0/";
# 		$page_template = "netscape.html";
# 	} elsif ($browser_key eq "ie") {
# 		$template_dir .= "4.0/";
# 		$page_template = "ie.html";
# 	} elsif ($browser_key eq "mozilla") {
# 		$template_dir .= "4.0/";
# 		$page_template = "mozilla.html";
# 	}
# }

# Log The User
# open (LOGFILE,">>$logreal");
# print LOGFILE "$time, $ENV{'REMOTE_ADDR'}, $ENV{'SCRIPT_NAME'}$ENV{'DOCUMENT_URI'}$ENV{'PATH_INFO'}, $ENV{'HTTP_REFERER'},	$ENV{'HTTP_USER_AGENT'}, $browser, $bversion\n";
# close(LOGFILE);


# READ INPUT VARIABLES #
# READ INPUT VARIABLES #

	# this function unUrlEncodes form submit and query string variables and puts
	# all variables into a hash called $FORM
	sub unurl {
    	my @pairs = @_;
    	my %FORM;
		foreach my $pair (@pairs) {
			my ($myname, $myvalue) = split(/=/, $pair);
			$myvalue =~ tr/+/ /;
			$myvalue =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
			$FORM{$myname} = $myvalue;
		}
    	return %FORM;
	}
		
	my $args = $r->args();
	my @query_pairs = split(/&/, $args);
	my %query_form = unurl(@query_pairs);

	my $pi = $r->path_info();
	$pi =~ s/^.//;
	my @path_pairs = split(/\//, $pi);
	my %path_form = unurl(@path_pairs);

	my %FORM = (%query_form, %path_form);

	# get the form submit pairs
	# read(STDIN, $formsubmit, $r->header_in->{'Content-length'});
	# @pairs = split(/&/, $formsubmit);
	# &unurl;

# END READ INPUT VARIABLES #
# END READ INPUT VARIABLES #


############################################################################
#sub count_hits		#4/28/99 0:32AM
############################################################################
#	{
#	$filevalue = $ENV{'DOCUMENT_URI'};
#	$filevalue =~ s/\///g;
#	$filevalue =~ s/\.//g;
#	$hits_val = "";
#
#	$dbmfile = "/opt/guide/grill/HTML/counters/counter";
#
#	dbmopen %COUNTERS, $dbmfile, 0666;
#		$COUNTERS{$filevalue} = $COUNTERS{$filevalue} + 1;
#		$Hits = $COUNTERS{$filevalue};
#	dbmclose %COUNTERS;
#
#	$Ones = $Hits % 10;
#	$Hits = ($Hits - $Ones) / 10;
#	$Tens = $Hits % 10;
#	$Hits = ($Hits - $Tens) / 10;
#	$Hundreds = $Hits % 10;
#	$Hits = ($Hits - $Hundreds) / 10;
#	$Thousands = $Hits % 10;
#	$Hits = ($Hits - $Thousands) / 10;
#	$Ten_Thousands = $Hits % 10;
#	$Hits = ($Hits - $Ten_Thousands) / 10;
#	$Hun_Thousands = $Hits % 10;
#	$Hits = ($Hits - $Hun_Thousands) / 10;
#
#	@R_Ones = ("I","II","III","IV","V","VI","VII","VIII","IX");
#	@R_Tens = ("X","XX","XXX","XL","L","LX","LXX","LXXX","XC");
#	@R_Hundreds = ("C","CC","CCC","CD","D","DC","DCC","DCCC","CM");
#	@R_Thousands = ("M","MM","MMM","MW","W","WM","WMM","WMMM","WQ");
#	@R_Ten_Thousands = ("Q","QQ","QQQ","QH","H","HQ","HQQ","HQQQ","HR");
#	@R_Hun_Thousands = ("R","RR","RRR","RT","T","RT","RTT","RTTT","O");
#
#	for ($i=0; $i < $Hits; $i++)
#		{$hits_val = "${hits_val}O";}
#	if ($Hun_Thousands)
#		{$hits_val = "${hits_val}@R_Hun_Thousands[$Hun_Thousands]";}
#	if ($Ten_Thousands)
#		{$hits_val = "${hits_val}@R_Ten_Thousands[$Ten_Thousands]";}
#	if ($Thousands)
#		{$hits_val = "${hits_val}@R_Thousands[$Thousands]";}
#	if ($Hundreds)
#		{$hits_val = "${hits_val}@R_Hundreds[$Hundreds-1]";}
#	if ($Tens)
#		{$hits_val = "${hits_val}@R_Tens[$Tens-1]";}
#	if ($Ones)
#		{$hits_val = "${hits_val}@R_Ones[$Ones-1]";}
#
#	}


sub dollarFormat {
    my ($numtoformat) = @_;
    $numtoformat = sprintf("%.2f", $numtoformat);

    while ($numtoformat =~ /(\d)(\d{3})(\..+|\,.+)$/) {
        $numtoformat =~ s/(\d)(\d{3})(\..+|\,.+)$/$1\,$2$3/g;
    }
    
    return $numtoformat;
}

sub trim {
	my($stringtotrim) = @_;
	# Cut off white space
	$stringtotrim =~ s/^\s+//;
	$stringtotrim =~ s/\s+$//;

	# Cut off line returns
	$stringtotrim =~ s/^\n+//;
	$stringtotrim =~ s/\n+$//;

	return $stringtotrim;
}

sub isNumeric {
	local($stringtocheck) = @_;
	if ($stringtocheck eq "") {
		return 0;
	} elsif ($stringtocheck =~ /^\d*\.\d+$|^\d+\.\d*$|^\d+$/) {
		return 1;
	} else {
		return 0;
	}
}



1;