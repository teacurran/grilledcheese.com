#!/usr/bin/perl -w
require "../application.pl";

$logfile = "${basedir}data/aim/aim.log";

$date_command = "/bin/date";
$datestamp = `$date_command +"%m/%d/%y %H:%M:%S"`;
chop($datestamp);

open (FILE, ">>$logfile");
	print FILE "$datestamp	$FORM{'x'}	$FORM{'y'}\n";
close (FILE);

print "Content-type: text/html\n\n";
print <<END;
<html>
	This is a test script, real content will be here soon.<br>
	<b>Name:</b>		Tea Curran<br>
	<b>Location:</b>	Boston<br>
	<b>Homepage:</b>	<a href="http://www.grilledcheese.com">http://www.grilledcheese.com</a><br>
</html>
END
print "\n";
