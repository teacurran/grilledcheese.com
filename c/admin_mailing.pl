#!/usr/bin/perl -w

require "../application.pl";

$date_command = "/bin/date";
$mailprog = '/usr/sbin/sendmail';
$mailreal = "${basedir}data/mailinglist.txt";

if ($FORM{'action'} eq "SEND")
	{
	open (MAILFILE,"$mailreal");
	@mailnames = <MAILFILE>;
	close(MAILFILE);

	$i = 0;
	foreach $line (@mailnames)
		{
		$line =~ chomp($line);
		$i++;

		if ( $line ne "" )
			{
    		open(MAIL,"|$mailprog -t");
    			print MAIL "To: $line\n";
    			print MAIL "From: mailinglist\@grilledcheese.com (GrilledCheese.com Mailing List)\n";
     			print MAIL "Subject: $FORM{'subject'}\n\n";
    			print MAIL "$FORM{'body'}";
    		close(MAIL);
			}
		}
	$message = "$i Messages sent!";
	}

if ($FORM{'action'} eq "PREVIEW")
	{
    open(MAIL,"|$mailprog -t");
    	print MAIL "To: tea\@grilledcheese.com\n";
    	print MAIL "From: mailinglist\@grilledcheese.com (GrilledCheese.com Mailing List)\n";
     	print MAIL "Subject: $FORM{'subject'}\n\n";
    	print MAIL "$FORM{'body'}";
    close(MAIL);
	}

print "Content-type: text/html\n\n";
print "<B>$message</B><BR>\n";
print '<FORM METHOD="post" ACTION="admin_mailing.pl">';
print "<INPUT TYPE=\"text\" NAME=\"subject\" VALUE=\"$FORM{'subject'}\" SIZE=100><BR>\n";
print "<TEXTAREA NAME=\"body\" ROWS=30 COLS=60>$FORM{'body'}</TEXTAREA><BR>\n";
print '<INPUT TYPE="SUBMIT" NAME="action" VALUE="PREVIEW"><INPUT TYPE="SUBMIT" NAME="action" VALUE="SEND">';




