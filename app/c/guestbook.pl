#!/usr/bin/perl

require "/app/application.pl";

$basedir = "/app/";
$main_template_file = "${basedir}${template_dir}${page_template}";

undef $/;
open (TEMPLATEFILE,"$main_template_file") || die "Can't Open $templatefile: $!\n";
 $template=<TEMPLATEFILE>;
close(TEMPLATEFILE);

$/ = "\n";

($header, $footer) = split(/<!--- %MAIN% --->/, $template);

$header =~ s/<!--- %TITLE% --->/Grilledcheese.com : Guestbook/g;

$guestbookurl = "/c/static.pl/page=book";
$guestbookreal = "${basedir}static/book.txt";
$guestlog = "${basedir}booklog.html";
$cgiurl = "/c/guestbook.pl";
$date_command = "/bin/date";

# Set Your Options:
$mail = 0;              # 1 = Yes; 0 = No
$linkmail = 0;          # 1 = Yes; 0 = No
$separator = 1;         # 1 = <hr>; 0 = <p>
$redirection = 1;       # 1 = Yes; 0 = No
$entry_order = 1;       # 1 = Newest entries added first;
                        # 0 = Newest Entries added last.
$remote_mail = 0;       # 1 = Yes; 0 = No
$allow_html = 0;        # 1 = Yes; 0 = No
$line_breaks = 1;	# 1 = Yes; 0 = No

# If you answered 1 to $mail or $remote_mail you will need to fill out
# these variables below:
$mailprog = '/usr/sbin/sendmail';
$recipient = 'tea@grilledcheese.com';

# Done
##############################################################################

# Get the Date for Entry
$date = `$date_command +"%A, %B %d, %Y at %T (%Z)"`; chop($date);
$shortdate = `$date_command +"%D %T %Z"`; chop($shortdate);

# Get the input
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

   # Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   if ($allow_html != 1) {
      $value =~ s/<([^>]|\n)*>//g;
   }

   $FORM{$name} = $value;
}

if ($FORM{'submit'})
{
		$errorcount = 0;
		unless ($FORM{'realname'})
		{
				$errorlist[$errorcount] = "I'm afraid were going to have to ask you your name";
				$errorcount++;
		}
		unless ($FORM{'comments'})
		{
				$errorlist[$errorcount] = "I'm sure you can think of some comments to leave.";
				$errorcount++;
		}
		if ($errorcount > 0)
		{
				&blankpage;
		}
}
else
{
	&blankpage;
}

# Begin the Editing of the Guestbook File
open (FILE,"$guestbookreal");
@LINES=<FILE>;
close(FILE);
$SIZE=@LINES;

# Open Link File to Output
open (GUEST,">$guestbookreal");

for ($i=0;$i<=$SIZE;$i++) {
   $_=$LINES[$i];
   if (/<!--dance_your_ass_off-->/) {

      if ($entry_order eq '1') {
         print GUEST "<!--dance_your_ass_off-->\n";
      }

      if ($line_breaks == 1) {
         $FORM{'comments'} =~ s/\cM\n/<br>\n/g;
      }

			$FORM{'comments'} =~ s/<!--dance_your_ass_off-->/<!--try_to_hack_me_again_fucker-->/g;

		print GUEST "<TR><TD COLSPAN=2>";
      if ($FORM{'url'}) {
         print GUEST "<B><a href=\"$FORM{'url'}\" TARGET=\"new\">$FORM{'realname'}</a></B>";
      }
      else {
         print GUEST "<B>$FORM{'realname'}</B>";
      }

      if ( $FORM{'username'} ){
         if ($linkmail eq '1') {
            print GUEST " <B>...</B><a href=\"mailto:$FORM{'username'}\">";
            print GUEST "$FORM{'username'}</a><B>...</B>";
         }
         else {
            print GUEST " <B>...</B>$FORM{'username'}<B>...</B>";
         }
      }

		print GUEST '</TD></TR><TR><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD><TD>';

      	print GUEST "$FORM{'comments'}<BR>\n";

      if ( $FORM{'city'} ){
         print GUEST "&#149;$FORM{'city'},";
      }

      if ( $FORM{'state'} ){
         print GUEST " $FORM{'state'}";
      }

      if ( $FORM{'country'} ){
         print GUEST " $FORM{'country'}<BR>";
      }

        print GUEST "&#149;$date\n";

		print GUEST "</TD></TR>\n\n";

      if ($entry_order eq '0') {
         print GUEST "<!--dance_your_ass_off-->\n";
      }

   }
   else {
      print GUEST $_;
   }
}

close (GUEST);

# Log The Entry
open (LOGFILE,">>$guestlog");
print LOGFILE "IP Address - $ENV{'REMOTE_ADDR'}<BR>";
print LOGFILE "Name - $FORM{'realname'}<BR>";
print LOGFILE "Time - $date<BR><HR>";
close(LOGFILE);

#########
# Options

# Mail Option

	$mailprog = '/usr/lib/sendmail';
	$recipient = 'TeACalcium@aol.com';
	$realname = 'TeA Curran';

	# Open The Mail Program
	open(MAIL,"|$mailprog -t");

	print MAIL "To: $recipient\n";
	print MAIL "From: $recipient ($realname)\n";

	# Check for Message Subject
    print MAIL "Subject: Guestbook\n\n";

   	print MAIL "You have a new entry in your guestbook:\n\n";
   	print MAIL "------------------------------------------------------\n";
   	print MAIL "$FORM{'comments'}\n";
   	print MAIL "$FORM{'realname'}";

   	if ( $FORM{'username'} ){
      	print MAIL " <$FORM{'username'}>";
   	}

   	print MAIL "\n";

   	if ( $FORM{'city'} ){
      	print MAIL "$FORM{'city'},";
   	}

   	if ( $FORM{'state'} ){
      	print MAIL " $FORM{'state'}";
   	}

   	if ( $FORM{'country'} ){
      	print MAIL " $FORM{'country'}";
   	}

   	print MAIL " - $date\n";
   	print MAIL "------------------------------------------------------\n";

   	close (MAIL);


if ($remote_mail eq '1' && $FORM{'username'}) {
   open (MAIL, "|$mailprog -t") || die "Can't open $mailprog!\n";

   print MAIL "To: $FORM{'username'}\n";
   print MAIL "From: $recipient\n";
   print MAIL "Subject: Entry to Guestbook\n\n";
   print MAIL "Thank you for adding to my guestbook.\n\n";
   print MAIL "------------------------------------------------------\n";
   print MAIL "$FORM{'comments'}\n";
   print MAIL "$FORM{'realname'}";

   if ( $FORM{'username'} ){
      print MAIL " <$FORM{'username'}>";
   }

   print MAIL "\n";

   if ( $FORM{'city'} ){
      print MAIL "$FORM{'city'},";
   }

   if ( $FORM{'state'} ){
      print MAIL " $FORM{'state'}";
   }

   if ( $FORM{'country'} ){
     print MAIL " $FORM{'country'}";
   }

   print MAIL " - $date\n";
   print MAIL "------------------------------------------------------\n";

   close (MAIL);
}

# Print Out Initial Output Location Heading
if ($redirection eq '1') {
   print "Location: $guestbookurl\n\n";
}
else {
   &no_redirection;
}

#######################
# Subroutines
sub blankpage {

$topofpage = <<'EOT';

		<TABLE BORDER=0 WIDTH=425 CELLPADDING=10 CELLSPACING=0>
			<TR><TD>
				<TABLE BORDER=0 WIDTH=100% CELLPADDING=5 CELLSPACING=0 BGCOLOR="#FFFFFF">
					<TR><TD>
						<CENTER>
						<FONT SIZE=+2 FACE="airal,helvetica"><B>Guestbook Guestbook La La La...</B></FONT>
						<BR>
						You know how it works, name and comments required.
						</CENTER>
						<BR>

EOT

$bottomofpage = <<'EOT';

					</TD></TR>
				</TABLE>
			</TD></TR>
		</TABLE>

EOT

   print "Content-type: text/html\n\n";
   print $header;
   print $topofpage;
	 print "<CENTER><TABLE><TR><TD COLSPAN=2>";
		if ($errorcount > 0)
		{
				print '<HR><B>We Have Problems:</B>';
				print '</TD></TR>';
				foreach $error (@errorlist)
				{
   					print "<TR><TD>&nbsp;</TD><TD>$error.</TD></TR>";
				}
				print '<TR><TD COLSPAN=2><HR><BR><BR></TD></TR>';
		}
   	print "<form method=POST action=\"guestbook.pl\">\n";
	print '<INPUT TYPE="hidden" NAME="submit" VALUE="1">';
   	print "<TR><TD ALIGN=\"RIGHT\">\n";
	print "<B>Name:</B></TD><TD><input type=text name=\"realname\" size=20 ";
   	print "MAXLEN=30 value=\"$FORM{'realname'}\"></TD></TR>\n";
   	print '<TR><TD ALIGN="RIGHT">';
   	print "<B>URL:</B></TD><TD><input type=text name=\"url\"";
   	print " value=\"$FORM{'url'}\" size=20 MAXLEN=\"50\"></TD></TR>\n";
   	print '<TR><TD ALIGN="RIGHT">';
   	print "<B>E-Mail:</B></TD><TD><input type=text name=\"username\"";
   	print " value=\"$FORM{'username'}\" size=20 MAXLEN=\"50\"></TD></TR>\n";
   	print '<TR><TD ALIGN="RIGHT">';
   	print "<B>City:</B></TD><TD><input type=text name=\"city\" value=\"$FORM{'city'}\" ";
   	print "size=15>";
   	print '<TR><TD ALIGN="RIGHT">';
	print "<B>State:</B></TD><TD><input type=text name=\"state\" ";
   	print "value=\"$FORM{'state'}\" size=15></TD></TR>";
   	print '<TR><TD ALIGN="RIGHT">';
	print "<B>Country:</B></TD><TD><input type=text ";
   	print "name=\"country\" value=\"$FORM{'country'}\" size=15></TD></TR>\n";
   	print '<TR><TD ALIGN="RIGHT" VALIGN="TOP">';
   	print "<B>Comments:</B></TD><TD>\n";
   	print "<textarea name=\"comments\" COLS=20 ROWS=8";
	print "WRAP=VIRTUAL>$FORM{'comments'}</textarea><p>\n";
   	print '<input type=submit VALUE="Rock It">&nbsp;&nbsp;';
	print '<input type=reset VALUE="Sock It"></form>';
	print "</TD></TR></TABLE></CENTER>";
   	print "$bottomofpage";
	print "$footer";
   exit;
}

# Redirection Option
sub no_redirection {

   # Print Beginning of HTML
   print "Content-Type: text/html\n\n";
   print "<html><head><title>Thank You</title></head>\n";
   print "<body><h1>Thank You For Signing The Guestbook</h1>\n";

   # Print Response
   print "Thank you for filling in the guestbook.  Your entry has\n";
   print "been added to the guestbook.<hr>\n";
   print "Here is what you submitted:<p>\n";
   print "<b>$FORM{'comments'}</b><br>\n";

   if ($FORM{'url'}) {
      print "<a href=\"$FORM{'url'}\">$FORM{'realname'}</a>";
   }
   else {
      print "$FORM{'realname'}";
   }

   if ( $FORM{'username'} ){
      if ($linkmail eq '1') {
         print " &lt;<a href=\"mailto:$FORM{'username'}\">";
         print "$FORM{'username'}</a>&gt;";
      }
      else {
         print " &lt;$FORM{'username'}&gt;";
      }
   }

   print "<br>\n";

   if ( $FORM{'city'} ){
      print "$FORM{'city'},";
   }

   if ( $FORM{'state'} ){
      print " $FORM{'state'}";
   }

   if ( $FORM{'country'} ){
      print " $FORM{'country'}";
   }

   print " - $date<p>\n";

   # Print End of HTML
   print "<hr>\n";
   print "<a href=\"$guestbookurl\">Back to the Guestbook</a>\n";         print "- You may need to reload it when you get there to see your\n";
   print "entry.\n";
   print "</body></html>\n";

   exit;
}