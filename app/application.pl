#!/usr/bin/perl
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

our $time = `$date_command +"%H:%M:%S"`; chop($time);
our $day = `$date_command +"%m_%d_%y"`; chop($day);
my $is_mod_perl = $ENV{MOD_PERL} ? 1 : 0;

our $browser_name = "";
our $browser_version = "";
our $browser_key = "";

my($args, $pi, $user_agent);

if ($is_mod_perl) {
    use Apache2::RequestRec;
    use Apache2::RequestUtil;

    my $r = Apache2::RequestUtil->request;
    $user_agent = $r->headers_in->{'User-Agent'};
    $args = $r->args() || "";
    $pi = $r->path_info();
} else {
    $user_agent = $ENV{'HTTP_USER_AGENT'};
    $args = $ENV{'QUERY_STRING'} || "";
    $pi = $ENV{'PATH_INFO'};
}

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

# READ INPUT VARIABLES #
# READ INPUT VARIABLES #

# this function unUrlEncodes form submit and query string variables and puts
# all variables into a hash called $FORM
sub splitParams {
    my @pairs = @_;
    my %FORM;
    foreach my $pair (@pairs) {
        my ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $FORM{$name} = $value;
    }
    return %FORM;
}

my @query_pairs = split(/&/, $args);
my %query_form = splitParams(@query_pairs);

$pi =~ s/^.//;
my @path_pairs = split(/\//, $pi);
my %path_form = splitParams(@path_pairs);

our %FORM = (%query_form, %path_form);

# get the form submit pairs
# read(STDIN, $formsubmit, $r->header_in->{'Content-length'});
# @pairs = split(/&/, $formsubmit);
# &unurl;

# END READ INPUT VARIABLES #
# END READ INPUT VARIABLES #

sub dollarFormat {
    my ($value) = @_;
    $value = sprintf("%.2f", $value);

    while ($value =~ /(\d)(\d{3})(\..+|\,.+)$/) {
        $value =~ s/(\d)(\d{3})(\..+|\,.+)$/$1\,$2$3/g;
    }
    return $value;
}

sub trim {
	my($value) = @_;
	# Cut off white space
	$value =~ s/^\s+//;
	$value =~ s/\s+$//;

	# Cut off line returns
	$value =~ s/^\n+//;
	$value =~ s/\n+$//;

	return $value;
}

sub isNumeric {
	my($value) = @_;
	if ($value eq "") {
		return 0;
	} elsif ($value =~ /^\d*\.\d+$|^\d+\.\d*$|^\d+$/) {
		return 1;
	} else {
		return 0;
	}
}

1;