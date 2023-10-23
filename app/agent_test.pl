#!/usr/bin/perl

$_ = $ENV{'HTTP_USER_AGENT'};

$user_agent = $ENV{'HTTP_USER_AGENT'};

if ($user_agent =~ /MSIE/) {
	$name = "Microsoft Internet Explorer";
	$name_version = $user_agent;
	$name_version =~ s/(^.*)(MSIE.*)(\;.*)/$2/g;
	($name, $version) = split(/ /, $name_version);
} else {
	$name_version = $user_agent;
	$name_version =~ s/(^.*\/\S*)(\s)(.*$)/$1/g;
	($name, $version) = split(/\//, $name_version);
}
$version =~ s/(^\D*)(\d*)(.*)(\d*)(\D*$)/$2$3$4/g;

print "Content-type: text/plain\n\n";
print "$ENV{'HTTP_USER_AGENT'}\n";
print "$name_version\n";
print "$name\n";
print "$version\n";