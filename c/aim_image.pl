#!/usr/bin/perl
require "../application.pl";

$logfile = "${basedir}data/aim/aim.log";

$date_command = "/bin/date";
$datestamp = `$date_command +"%m/%d/%y %H:%M:%S"`;
chop($datestamp);

open (FILE, ">>$logfile");
	print FILE "$datestamp	$FORM{'x'}	$FORM{'y'}\n";
close (FILE);

print "Content-type: image/gif\n\n";
print <<END;
<html>
	<table>
		<tr>
			<td><b>Name:</b></td>
			<td>Tea Curran</td>
		</tr>
		<tr>
			<td><b>Location:</b></td>
			<td>Boston</td>
		</tr>
		<tr>
			<td><b>Homepage:</b></td>
			<td><a href="http://www.grilledcheese.com">http://www.grilledcheese.com</a></td>
		</tr>
	</table>
</html>
END
