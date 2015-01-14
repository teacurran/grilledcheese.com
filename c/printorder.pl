#!/usr/bin/perl -w
use DB_File;

##############################################################################
# fontview.pl                         Version 1.1                               #
# Copyright 1998                   TeA Curran                      #
# Created 7/4/98                   Last Modified 7/19/00                       #
# Notes:                   This Script calls up a font name identified by the fname         #
#                              parameter in the url.   height and width parameters for this   #
#                              font image are optional, they are called height and name, easy#
############################################################

require "../application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";
$templatefile = "${basedir}templates/gen2.html";

$totalfontprice = 0;

&get_cookie_data;

sub get_cookie_data
{
	@cookiepairs = split(/; /, $ENV{'HTTP_COOKIE'});

	foreach $cookie (@cookiepairs)
   	{
   	($cookiename, $cookieval) = split(/\=/, $cookie);

   	$COOKIE{$cookiename} = $cookieval;
   	}
}


$changeqtyflag = 0;

#                                       #
# start processing the action commands  #
#                                       #

	@existtitles = split(/,/ , $COOKIE{titles});
	$existtitleslen = @existtitles;
	$finaltitles = '';

	@existqty = split(/,/ , $COOKIE{qty});
	$existqtylen = @existqty;
	$finalqty = '';


	for ($i=0;$i<=$existtitleslen;$i++)
	{
		$thistitle = $existtitles[$i];
		$thisqty = $existqty[$i];

		if ( $thistitle ne '' and $thisqty ne '' )
		{
			$finaltitles = "$finaltitles$thistitle,";
			$finalqty = "$finalqty$thisqty,";
		}
	}

#                                       #
# stop processing the action commands   #
#                                       #

# any of the actions should have resulted in a finaltitles parameter #
# and a finalqty parameter.   process all that funk                  #
#$listreal = 'fontlist.txt';

#open (LISTFILE,"$listreal") || die "Can't Open $listreal: $!\n";
#	@LINES=<LISTFILE>;
#close(LISTFILE);
#$LINESSIZE=@LINES;

@finaltitlesarray = split(/,/ , $finaltitles);
$lenfinaltitles=@finaltitlesarray;
@finalqtyarray = split(/,/ , $finalqty);

tie(%FONTS, "DB_File", $fontsdbm, O_RDONLY, 0, $DB_File::DB_BTREE) || die "Can't open $fontsdbm: $!\n";

for ($i=0;$i<=$lenfinaltitles;$i++)
	{
	$this_product = $finaltitlesarray[$i];
	$this_qty = $finalqtyarray[$i];

	@thisitem 	= split(/:\|:/, $FONTS{$this_product});
	$listprintname	= $thisitem[0];
	$height 	= $thisitem[1];
	$width 		= $thisitem[2];
	$listorderflag 	= $thisitem[3];
	$listfontprice	= $thisitem[4];
	$pcchars   	= $thisitem[5];
	$macchars  	= $thisitem[6];
	$created 	= $thisitem[7];
	$modify 	= $thisitem[8];
	$notes 		= $thisitem[9];
	$teaser 	= $thisitem[10];
	$new	 	= $thisitem[11];

	if ($FONTS{$this_product} ne '')
		{

		$this_list = "$this_product,$listprintname,$listfontprice,$this_qty";
		push(@totaldat,$this_list);
		$finalprinttitles = "$finalprinttitles$this_product,";
		$finalprintqty = "$finalprintqty$finalqtyarray[$i],";

		$totalfontprice = $listfontprice * $finalqtyarray[$i];
		$totalprice = $totalprice + $totalfontprice;

		}
   	}

untie %FONTS;

($ttfcheck, $pscheck, $wincheck, $maccheck, $shipmethod) = split(/,/, $COOKIE{'parms'});

$shipo1 = '';
$shipo2 = '';
$shipo3 = '';
$shipo4 = '';
$shipo5 = '';
$shipname = '';
$shipprice = 0;

if ( $shipmethod eq '' )
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = dollarFormat(0);
}
elsif ( $shipmethod eq 0 )
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = dollarFormat(0);
}
elsif ( $shipmethod eq 1 )
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = dollarFormat(0);
}
elsif ( $shipmethod eq 2 )
{
	$shipo2 = 'CHECKED';
	$shipname = 'Http Download';
	$shipprice = dollarFormat(0);
}
elsif ( $shipmethod eq 3 )
{
	$shipo3 = 'CHECKED';
	$shipname = 'US Mail, Disk';
	$shipprice = dollarFormat(5);
}
elsif ( $shipmethod eq 4 )
{
	$shipo4 = 'CHECKED';
	$shipname = 'US Mail, CD-ROM';
	$shipprice = dollarFormat(15);
}
elsif ( $shipmethod eq 5 )
{
	$shipo5 = 'CHECKED';
	$shipname = 'Fed-Ex, Disk';
	$shipprice = dollarFormat(10);
}
else
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = 0;
}


if ( $ttfcheck eq 'on' )
{
	$ttfchecked = 'CHECKED';
}
else
{
	$ttfchecked = '';
}

if ( $pscheck eq 'on' )
{
	$pschecked = 'CHECKED';
}
else
{
	$pschecked = '';
}

if ( $maccheck eq 'on' )
{
	$macchecked = 'CHECKED';
}
else
{
	$macchecked = '';
}

if ( $wincheck eq 'on' )
{
	$winchecked = 'CHECKED';
}
else
{
	$winchecked = '';
}

#                                       #
# mail contents of this page to me      #
#                                       #

    $mailprog = '/usr/lib/sendmail';
    $recipient = 'tea@grilledcheese.com';
    $realname = 'TeA Curran';


    # Open The Mail Program
    open(MAIL,"|$mailprog -t");

    print MAIL "To: $recipient\n";
    print MAIL "From: $recipient ($realname)\n";

    # Check for Message Subject
     print MAIL "Subject: Demographic\n\n";

    print MAIL "IP Address - $ENV{'REMOTE_ADDR'}\n";
    print MAIL "Titles - $COOKIE{'titles'}\n";
    print MAIL "Qty - $COOKIE{'qty'}\n\n";
    print MAIL "Platform - ";
		if ( $winchecked eq 'CHECKED' and $macchecked eq 'CHECKED' )
		{
			print MAIL "Both Windows and Macintosh\n";
		}
		elsif ( $winchecked eq 'CHECKED')
		{
			print MAIL "Windows\n";
		}
		elsif ( $macchecked eq 'CHECKED')
		{
			print MAIL "Macintosh\n";
		}
		else
		{
			print MAIL "None Selected\n";
		}

	print MAIL "Format - ";
		if ( $ttfchecked eq 'CHECKED' and $pschecked eq 'CHECKED' )
		{
			print MAIL "Both True Type and Postscript\n";
		}
		elsif ( $ttfchecked eq 'CHECKED')
		{
			print MAIL "True Type\n";
		}
		elsif ( $pschecked eq 'CHECKED')
		{
			print MAIL "Postscript\n";
		}
		else
		{
			print MAIL "None Selected\n";
		}

	print MAIL "Ship Method - ";

		if ( $shipmethod eq 1 or $shipmethod eq 2 or $shipmethod eq 3 or $shipmethod eq 4 or $shipmethod eq 5)
		{
			print MAIL "$shipmethod\n";
		}
		else
		{
			print MAIL "none selected\n";
		}


    close(MAIL);


print "Content-type: text/html\n\n";
print "<HTML><BODY BGCOLOR=\"#FFFFFF\" text=\"#000000\" ><HEAD><TITLE>-----(grilledcheese.com)------</TITLE></HEAD>\n";
print "<CENTER><A Href=\"http://www.grilledcheese.com/indexnew.html\">Back to Grilledcheese.com</A><BR>";
print "<BR><TABLE BORDER=0 CELLPADDING=10 BGCOLOR=\"#000000\" WIDTH=500><TR><TD ALIGN=\"CENTER\"><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=10 BGCOLOR=\"#FFFFFF\"><TR><TD ALIGN=\"CENTER\">";

$totaldatlen = @totaldat;

if ($totaldatlen > 0)
{

print "<TABLE BORDER=1 CELLSPACING=2 CELLPADDING=2 BGCOLOR=\"#FFFFFF\"><TR><TD COLSPAN=4 ALIGN=\"CENTER\"><B>Shopping Basket</B></TD></TR>\n";
print "<TR><TD ALIGN=\"CENTER\" BGCOLOR=\"#FFFFFF\"><B>Qty</B></TD><TD ALIGN=\"CENTER\"><B>Font Name</B>";
print "</TD><TD ALIGN=\"CENTER\"><B>Font Price</B></TD><TD ALIGN=\"CENTER\"><B>Total Price</B></TD></TR>\n";

@totaldat = sort @totaldat;
#$totalprice = 0;
$totalqty = 0;

$color = '#FFFFFF';

for ($td=0;$td<$totaldatlen;$td++)
{
	$thisdat = $totaldat[$td];
	@thisitem = split(/,/, $thisdat);
	$realname = $thisitem[0];
	$printname = $thisitem[1];
	$fontprice =  $thisitem[2];
	$fontqty =  $thisitem[3];

 	$totalfontprice = dollarFormat($fontprice * $fontqty);
 #	$totalprice = $totalprice + $totalfontprice;

	$totalqty = $totalqty + $fontqty;

	print "<TR><TD BGCOLOR=\"$color\">$fontqty";
	print "</TD><TD BGCOLOR=\"$color\">$printname</TD><TD ALIGN=\"right\" BGCOLOR=\"$color\">\$$fontprice</TD><TD ALIGN=\"RIGHT\" BGCOLOR=\"$color\">\$$totalfontprice</TD></TR>\n";

}

$finalprice = $totalprice;
$formatcharge = 0;
$platformcharge = 0;

print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Subtotal:</TD><TD ALIGN=\"RIGHT\">\$$totalprice\.00</TD></TR>\n";

#                                                   #
# charge double if they want both mac and windows   #
#                                                   #
if ( $maccheck eq 'on' and $wincheck eq 'on')
{
	$platformcharge = dollarFormat($totalprice);
	$finalprice = $finalprice + $platformcharge;
}
if ( $platformcharge > 0 )
{
	print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Charge for Both Mac and Win Formats:</TD><TD ALIGN=\"RIGHT\">\$$platformcharge</B></TD></TR>\n";
}

#                                                   #
# charge extra if they want both postscript and ttf #
#                                                   #
if ( $ttfcheck eq 'on' and $pscheck eq 'on')
{
	$formatcharge = dollarFormat($totalqty * 5);
	$finalprice = $finalprice + $formatcharge;
}


if ( $formatcharge > 0 )
{
	print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Charge for Both TTF and PS Formats:</TD><TD ALIGN=\"RIGHT\">\$$formatcharge</B></TD></TR>\n";
}

#                                                   #
# subtract Promo Discounts							#
#                                                   #
	if ( $finalprice >= 500)
		{
		$discount1 = dollarFormat(($finalprice * 20) / 100);
		$finalprice = $finalprice - $discount1;
		print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>20% off for orders over \$500:</TD><TD ALIGN=\"RIGHT\"><B>-</B>\$$discount1</B></TD></TR>\n";
		}

	elsif ( $finalprice >= 200)
		{
		$discount1 = dollarFormat(($finalprice * 15) / 100);
		$finalprice = $finalprice - $discount1;
		print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>15% off for orders over \$200:</TD><TD ALIGN=\"RIGHT\"><B>-</B>\$$discount1</B></TD></TR>\n";
		}

	elsif ( $finalprice >= 100)
		{
		$discount1 = dollarFormat(($finalprice * 10) / 100);
		$finalprice = $finalprice - $discount1;
		print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>10% off for orders over \$100:</TD><TD ALIGN=\"RIGHT\"><B>-</B>\$$discount1</B></TD></TR>\n";
		}

	elsif ( $finalprice >= 50)
		{
		$discount1 = dollarFormat(5);
		$finalprice = dollarFormat($finalprice - $discount1);
		print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>\$5 off for orders over \$50:</TD><TD ALIGN=\"RIGHT\"><B>-</B>\$$discount1</B></TD></TR>\n";
		}


$finalprice = dollarFormat($finalprice + $shipprice);

print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Shipping ($shipname):</TD><TD ALIGN=\"RIGHT\">\$$shipprice</B></TD></TR>\n";

print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2><B>TOTAL</B>:</TD><TD ALIGN=\"RIGHT\"><B>\$$finalprice</B></TD></TR>\n";

#                                                              #
# Let the user choose the platform they would like the font in #
#                                                              #
	print '<TR><TD COLSPAN=4>';
	print '<FORM METHOD="POST" ACTION="printorder.pl"><CENTER>All prices listed are in United States currency.<BR></CENTER>';
	print '<TABLE WIDTH=100%><TR><TD WIDTH=33%><B>Platform : </B>';
	if ( $winchecked eq 'CHECKED' and $macchecked eq 'CHECKED' )
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Both Windows and Macintosh';
	}
	elsif ( $winchecked eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Windows';
	}
	elsif ( $macchecked eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Macintosh';
	}
	else
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Macintosh';
	}

#                                                            #
# Let the user choose the format they would like the font in #
#
	print '</TD><TD WIDTH=33%><B>Format : </B><BR>';
	if ( $ttfchecked eq 'CHECKED' and $pschecked eq 'CHECKED' )
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Both True Type and Postscript';
	}
	elsif ( $ttfchecked eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;True Type';
	}
	elsif ( $pschecked eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Postscript';
	}
	else
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Postscript';
	}

#                                                            #
# Let the user choose the shipping                           #
#                                                            #
	print '</TD><TD WIDTH=34%><B>Shipping : </B>';
	if ( $shipo1 eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E-Mail';
	}
	elsif ( $shipo2 eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Http Download';
	}
	elsif ( $shipo3 eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;US Mail (Disk)';
	}
	elsif ( $shipo4 eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;US Mail (CD)';
	}
	elsif ( $shipo5 eq 'CHECKED')
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fed-Ex (Disk)';
	}
	else
	{
		print '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E-Mail';
	}
	print '</TD></TR></TABLE>';

#                                                            #
# final ordering stuff                                       #
#                                                            #
	print '<TABLE BORDER=0 CELLSPACING=2><TR><TD COLSPAN=2><FONT SIZE=+1><B>Please fill out your email address and additional shipping info if neccessary.<BR>&nbsp;</B></TD></TR>';
	print '<TR><TD NOWRAP ALIGN="RIGHT"><B>E-Mail Address : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=35></B><BR></TD></TR>';
	print '<TR><TD NOWRAP ALIGN="RIGHT"><B>Phone Number : </TD><TD>(<INPUT TYPE="text" SIZE=3 MAXLENGTH=3>)<INPUT TYPE="text" SIZE=3 MAXLENGTH=3>-<INPUT TYPE="text" SIZE=4 MAXLENGTH=4></B><BR></TD></TR>';
	print '<BR>';
	if ( $shipo3 eq 'CHECKED' or $shipo4 eq 'CHECKED' or $shipo5 eq 'CHECKED')
	{
		print '<TR><TD COLSPAN=2><B>Since you have chosen to have the fonts mailed or shipped to you, please fill out the additional information below.</TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>Full Name : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>Address 1 : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>Address 2 : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>City/State : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>Zip Code : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';
		print '<TR><TD ALIGN="RIGHT" NOWRAP><B>Country : </TD><TD><INPUT TYPE="text" SIZE=35 MAXLENGTH=20></B><BR></TD></TR>';

	}
	print '<TR><TD COLSPAN=2><HR></TD></TR></TABLE></FONT></FORM>';
	print 'Grilledcheese.com currently does not have online ordering capibilities.  To place an order, print out this page';
	print ' or write out all the information on this page and send it along with your address and a check or money order';
	print ' for ';
	print " <B>\$$finalprice.00</B>";
	print ' made out to <B>"Approaching Pi, Inc." </B> to :';
	print '<BR> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Tea Curran</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>345 Franklin St.</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Suite 308</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Cambridge MA, 02139</B>';

	print '<BR>Orders are processed the day they are recieved and';
	print ' shipped the following business day, unless ship method.';
	print ' is via E-mail where they are shipped right away.';

	print '<BR>';
	print '</TD></TR>';

	print "</TABLE>\n";

}
else
{
print "<BR><B>You Have No Items In Your Shopping Basket</B><BR><BR>";
}
print "</TD></TR></TABLE></TD></TR></TABLE>";
print "<BR><A Href=\"http://www.grilledcheese.com\">Back to Grilledcheese.com</A></CENTER>";