#!/usr/bin/perl

require "../application.pl";

$templatefile = "${basedir}templates/gen2.html";
$fontpreal = "${basedir}img/font/preview/";
$pageslocation = "${basedir}static/$FORM{'page'}.txt";

$mailreal = "${basedir}data/mailinglist.txt";
$foundname = 0;
$removedname = 0;
$validemail = 0;

# MESSAGE FLAGS
# 1	=	added
# 2	=	nothing to add
# 3	=	has been removed
# 4	=	cant remove, cant find
# 5	=	cant be added, already exists
# 6 =	not a valid email address

$FORM{'email'} = lc $FORM{'email'};

$_ = $FORM{'email'};
if ( s/@/@/g eq 1)
	{
	$_ = $FORM{'email'};
	if ( s/././g > 0 )
		{
		$validemail = 1;
		}
	}

if ( $FORM{'action'} eq "remove" )
	{
	$validemail = 1;
	}

if ($FORM{'email'} ne '' && $validemail eq 1)
	{
	open (MAILFILE,"$mailreal");
	@mailnames = <MAILFILE>;
	close(MAILFILE);

	open (MAILFILE,">$mailreal");

	foreach $line (@mailnames)
		{
		$line =~ chop($line);

		if ( $line ne "" )
			{
			if ( lc $line eq $FORM{email} )
				{
				$foundname = 1;
				$removedname = 1;
				}

			if ( $FORM{'action'} eq "remove" && $foundname && $removedname)
				{
				$removedname = 0;
				$messageflag = 3;
				}
			else
				{
				print MAILFILE "$line\n";
				}
			}
		}

	if ( $FORM{'action'} eq "add" && !$foundname)
		{
		print MAILFILE "$FORM{'email'}\n";
		$messageflag = 1;
		}
	elsif ( $FORM{'action'} eq "add" && $foundname)
		{
		$messageflag = 5;
		}

	if ( $FORM{'action'} eq "remove" && !$foundname)
		{
		$messageflag = 4;
		}

	close(MAILFILE);
	}
elsif ($FORM{'email'} ne ''  && $validemail eq 0)
	{
	$messageflag = 6
	}
elsif ($FORM{'action'} eq "add" || $FORM{'action'} eq "remove")
	{
	$messageflag = 2;
	}


if ( $messageflag eq 1 )
	{
	$string = "Thank You for signing up to the GrilledCheese.com mailing list.";
	}
elsif ( $messageflag eq 2 )
	{
	$string = "Im afraid your going to have to enter an email address. Please Try Again.";
	}
elsif ( $messageflag eq 3 )
	{
	$string = "You have been removed from the mailing list.";
	}
elsif ( $messageflag eq 4 )
	{
	$string = "That email address is not on the mailing list. Please try again.";
	}
elsif ( $messageflag eq 5 )
	{
	$string = "That email address is already on the mailing list. Please try again.";
	}
elsif ( $messageflag eq 6 )
	{
	$string = "What you entered is not a valid email address. Please try again.";
	}


open (TEMPLATEFILE,"$templatefile") || die "Can't Open $templatefile: $!\n";
 @T_LINES=<TEMPLATEFILE>;
close(TEMPLATEFILE);
$SIZE=@T_LINES;

for ($i=0;$i<=$SIZE;$i++)
	{
	$template = "$template$T_LINES[$i]";
	}
($header, $footer) = split(/<!--- %MAIN% --->/, $template);

$messagebody = <<'EOT';
	<CENTER>
	<FONT FACE="impact,airal,helvetica" size=+3>GrilledCheese.com Mailing List</FONT><BR>
	<FORM METHOD="post" action="http://www.grilledcheese.com/c/mailing.pl">
	<TABLE WIDTH=300>
		<TR>
			<TD>
				Sign up for the GrilledCheese.com mailing list and be notified whenever
				new fonts are added, or anything else signifigant happens here.  All email
				addresses are confidential and only used by GrilledCheese.com and never
				distributed or sold to anyone.
			</TD>
		</TR>
		<TR>
			<TD>
				<FONT COLOR="#FF0000"><B>%string%</B></FONT>
			</TD>
		</TR>
	</TABLE>

	<TABLE CELLPADDING=10 CELLSPACING=0 BGCOLOR="#000000" BORDER=0 WIDTH=300>
		<TR>
			<TD ALIGN="CENTER">
				<TABLE BORDER=0 CELLPADDING=10 CELLSPACING=0 BGCOLOR="#FFFFFF">
					<TR>
						<TD ALIGN="CENTER">
							<FONT FACE="airal,helvetica"><B>Email Address:</B></FONT>
							<BR>
							<INPUT TYPE="text" SIZE=30 MAXLENGTH=60 NAME="email" VALUE="%email%">
							<BR>
							Add <INPUT TYPE="radio" NAME="action" VALUE="add" CHECKED>
							Remove <INPUT TYPE="radio" NAME="action" VALUE="remove"><BR><BR>
							<INPUT TYPE="submit" VALUE="Shake It">
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	</FORM>

	</CENTER>
EOT

$header =~ s/<!--- %TITLE% --->/GrilledCheese.com: Mailing List/g;
$messagebody =~ s/%string%/$string/g;

if ( $messageflag eq 4 || $messageflag eq 5 || $messageflag eq 6)
	{
	$messagebody =~ s/%email%/$FORM{'email'}/g;
	}
else
	{
	$messagebody =~ s/%email%//g;
	}



print "Content-type: text/html\n\n";
print "$header\n";
print "$messagebody\n";
print "$footer\n";