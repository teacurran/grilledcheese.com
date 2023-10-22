#!/usr/bin/perl

require "../application.pl";

$main_template_file = "${basedir}${template_dir}${page_template}";


# MESSAGE FLAGS
# 1	=	added
# 2	=	nothing to add
# 3	=	has been removed
# 4	=	cant remove, cant find
# 5	=	cant be added, already exists
# 6 =	not a valid email address
$messageflag = 0;

if ($FORM{'m'} =~ /1|2|3|4|5|6/)
	{
	$messageflag = $FORM{'m'};
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


open (TEMPLATEFILE,"$main_template_file") || die "Can't Open $templatefile: $!\n";
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
	<FORM METHOD=post action=http://scripts.dreamhost.com/add_list.cgi>
    <INPUT type=hidden name=list 			value="CheeseMailing">
    <INPUT type=hidden name=url 			value="http://grilledcheese.com/c/mailing.pl?m=1">
    <INPUT type=hidden name=unsuburl 		value="http://grilledcheese.com/c/mailing.pl?m=3">
    <INPUT type=hidden name=alreadyonurl 	value="http://grilledcheese.com/c/mailing.pl?m=5">
    <INPUT type=hidden name=notonurl 		value="http://grilledcheese.com/c/mailing.pl?m=4">
    <INPUT type=hidden name=invalidurl 		value="http://grilledcheese.com/c/mailing.pl?m=6">
    <INPUT type=hidden name=domain 			value="grilledcheese.com">
    <INPUT type=hidden name=emailit 		value="1">

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
							<INPUT TYPE="text" SIZE=30 MAXLENGTH=60 NAME="address" VALUE="">
							<BR>
							Add <INPUT TYPE="radio" NAME="submit" VALUE="add" CHECKED>
							Remove <INPUT TYPE="radio" NAME="submit" VALUE="remove"><BR><BR>
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

print "Content-type: text/html\n\n";
print "$header\n";
print "$messagebody\n";
print "$footer\n";