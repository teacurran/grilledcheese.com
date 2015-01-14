#!/usr/bin/perl
use DB_File;

####################################################################
# Copyright 1998                   TeA Curran                      #

require "../application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";
$main_template_file = "${basedir}${template_dir}${page_template}";

undef $/;
open (TEMPLATEFILE,"$main_template_file") || die "Can't Open $templatefile: $!\n";
 $template=<TEMPLATEFILE>;
close(TEMPLATEFILE);

$/ = "\n";

($header, $footer) = split(/<!--- %MAIN% --->/, $template);

$date=localtime(time);
($day, $month, $num, $time, $year) = split(/\s+/,$date);
$year = $year + 1;

$month=~tr/A-Z/a-z/;

$cookieexpire = "$num-$month-$year $time";

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

# set the parameters that can change the action value #
if ($FORM{'action'} eq 'add')
	{
	$action = 'add';
	}
elsif ($FORM{'action'} eq 'Clear Basket')
	{
	$action = 'clear';
	}
elsif ($FORM{'action'} eq 'view')
	{
	$action = 'view';
	}
elsif ($FORM{'action'} eq 'Change Qty')
	{
	$action = 'calc';
	}
else
	{
	$action = 'view';
	}


#                                       #
# start processing the action commands  #
#                                       #
if ($action eq 'add')
{
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

		if ($thistitle eq $FORM{fa})
		{
			$thisqty ++;
			$changeqtyflag = 1;
		}

		if ( $thistitle ne '' and $thisqty ne '' )
		{
			$finaltitles = "$finaltitles$thistitle,";
			$finalqty = "$finalqty$thisqty,";
		}
	}

	if ($changeqtyflag eq 0 )
	{
		$finaltitles = "$finaltitles$FORM{fa},";
		$thisqty = 1;
		$finalqty = "$finalqty$thisqty,";
	}

	if ( $COOKIE{parms} eq "" )
	{
		$parmslist = ",on,,on,1,";
		$COOKIE{parms} = $parmslist;
		print "Set-Cookie: parms=$parmslist; expires=$cookieexpire\n";
	}

	print "Set-Cookie: titles=$finaltitles; expires=$cookieexpire\n";
	print "Set-Cookie: qty=$finalqty; expires=$cookieexpire\n";
}
elsif ($action eq 'clear')
{
	#this date has already passed, so this cookie
	#will expire itself.
	$expires = "Sun, 01-Jan-1990 01:00:00 GMT";
	print "Set-Cookie: titles=; expires=$expires\n";
	print "Set-Cookie: qty=; expires=$expires\n";
	$finaltitles = '';
	$finalqty = '';
}

elsif ($action eq 'calc')
{
	@existtitles = split(/,/ , $FORM{'titleslist'});
	$existtitleslen = @existtitles;
	$finaltitles = '';

	@existqty = split(/,/ , $FORM{'qtylist'});
	$existqtylen = @existqty;
	$finalqty = '';

	# loop through the list of items #
	for ($titl=0;$titl<=$existtitleslen;$titl++)
		{
		# grab the list item for the title and qty #
		$temptitle = $existtitles[$titl];
		$tempqty = $FORM{$temptitle};

		# strip all white characters out of the qty #
   		$tempqty =~ s/(\s)//g;

		# if they entered nothing or all white space   #
		# that will have been stripped out, skip this. #
		unless ($tempqty eq '')
			{
			# set the qty to 1 if it contains any non #
			# numeric characters.                     #
			$_ = $tempqty;
			if (/(\D+)/)
				{
				$tempqty = 1;
				}
			}
		# add the title and qty to the final lists that get  #
		# printed to the cookie, unless the user has entered #
		# a qty of 0 or nothing at all.                      #
		unless ( $tempqty eq 0 or $tempqty eq '' )
			{
			$finaltitles = "$finaltitles$temptitle,";
			$finalqty = "$finalqty$tempqty,";
			}
		}

	if ( $COOKIE{parms} eq "" )
	{
		$parmslist = ",on,,on,1,";
		$COOKIE{parms} = $parmslist;
		print "Set-Cookie: parms=$parmslist; expires=$cookieexpire\n";
	}

	# set the cookies for the title and qty #
	print "Set-Cookie: titles=$finaltitles; expires=$cookieexpire\n";
	print "Set-Cookie: qty=$finalqty; expires=$cookieexpire\n";
}

elsif ($action eq 'view')
	{
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
	}

#                                       #
# stop processing the action commands   #
#                                       #

if ( $COOKIE{tc} eq '' and $COOKIE{titles} eq '' )
	{
	$cookiewarn = 1;
	}

# any of the actions should have resulted in a finaltitles parameter #
# and a finalqty parameter.   process all that funk                  #

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
		}
   	}

untie(%FONTS);

($ttfcheck, $pscheck, $wincheck, $maccheck, $shipmethod) = split(/,/, $COOKIE{'parms'});

# set the parameters that can change the action value #
if ($FORM{'chaction'} eq 'format')
	{
	$ttfcheck = $FORM{'ttf'};
	$pscheck = $FORM{'ps'};

	}
elsif ($FORM{'chaction'} eq 'platform')
	{
	$wincheck = $FORM{'win'};
	$maccheck = $FORM{'mac'};
	}

elsif ($FORM{'chaction'} eq 'shipping')
	{
	$shipmethod = $FORM{'ship'};
	}

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
	$shipprice = 0.00;
}
elsif ( $shipmethod eq 0 )
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = 0.00;
}
elsif ( $shipmethod eq 1 )
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = 0.00;
}
elsif ( $shipmethod eq 2 )
{
	$shipo2 = 'CHECKED';
	$shipname = 'Http Download';
	$shipprice = 0.00;
}
elsif ( $shipmethod eq 3 )
{
	$shipo3 = 'CHECKED';
	$shipname = 'US Mail, Disk';
	$shipprice = 5.00;
}
elsif ( $shipmethod eq 4 )
{
	$shipo4 = 'CHECKED';
	$shipname = 'US Mail, CD-ROM';
	$shipprice = 15.00;
}
elsif ( $shipmethod eq 5 )
{
	$shipo5 = 'CHECKED';
	$shipname = 'Fed-Ex, Disk';
	$shipprice = 10.00;
}
else
{
	$shipo1 = 'CHECKED';
	$shipname = 'E-Mail';
	$shipprice = 0.00;
}


if ($FORM{'chaction'} eq 'format' or $FORM{'chaction'} eq 'platform' or $FORM{'chaction'} eq 'shipping')
{
	$parmslist = "$ttfcheck,$pscheck,$wincheck,$maccheck,$shipmethod,";
	$COOKIE{parms} = $parmslist;
	print "Set-Cookie: parms=$parmslist; expires=$cookieexpire\n";
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

$header =~ s/<!--- %TITLE% --->/Grilledcheese.com: Shopping Cart/g;

print "Content-type: text/html\n\n";
print "$header\n\n";

print "<center>";

print '<FONT SIZE=+3 FACE="impact,verdana,airal,helvetica"><B>Shopping Cart</B></FONT>';

print "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=10 BGCOLOR=\"#FFFFFF\"><TR><TD ALIGN=\"CENTER\">";

$totaldatlen = @totaldat;

if ($totaldatlen > 0)
	{

	print "<TABLE BORDER=0 CELLSPACING=2 CELLPADDING=2 BGCOLOR=\"#FFFFFF\">\n";

	print "<tr><td colspan=\"4\">\n";
	print "<FORM METHOD=\"post\" ACTION=\"order.pl\">\n";
	print "<INPUT TYPE=\"HIDDEN\" NAME=\"titleslist\" VALUE=\"$finalprinttitles\">\n";
	print "<INPUT TYPE=\"HIDDEN\" NAME=\"qtylist\" VALUE=\"$finalprintqty\">\n";
	print "</td></tr>\n";

	print "<TR><TD ALIGN=\"CENTER\" BGCOLOR=\"#FFFFFF\"><B>Qty</B></TD><TD ALIGN=\"CENTER\"><B>Font Name</B>";
	print "</TD><TD ALIGN=\"CENTER\"><B>Font Price</B></TD><TD ALIGN=\"CENTER\"><B>Total Price</B></TD></TR>\n";

	@totaldat = sort @totaldat;
	$totalprice = 0;
	$totalqty = 0;

	$color = '#00779E';

	for ($td=0;$td<$totaldatlen;$td++)
		{
		$thisdat = $totaldat[$td];
		@thisitem = split(/,/, $thisdat);
		$realname = $thisitem[0];
		$printname = $thisitem[1];
		$fontprice =  $thisitem[2];
		$fontqty =  $thisitem[3];

		$totalfontprice = dollarFormat ($fontprice * $fontqty);
		$totalprice = dollarFormat($totalprice + $totalfontprice);

		$totalqty = $totalqty + $fontqty;

		print "<TR><TD BGCOLOR=\"$color\"><INPUT TYPE=\"text\" name=\"$realname\" value=\"$fontqty\" SIZE=4 MAXLEN=3></TD>";
		print "<TD BGCOLOR=\"$color\">$printname</TD><TD ALIGN=\"right\" BGCOLOR=\"$color\">\$$fontprice</TD><TD ALIGN=\"RIGHT\" BGCOLOR=\"$color\">\$$totalfontprice</TD></TR>\n";

		if ($color eq '#00779E')
   			{
	   		$color = '#00B2EB';
   			}
		else
   			{
   			$color = '#00779E';
   			}
		}

	$finalprice = $totalprice;
	$formatcharge = 0;
	$platformcharge = 0;

	print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Subtotal:</TD><TD ALIGN=\"RIGHT\">\$$totalprice</TD></TR>\n";

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
                                                #
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
		$discount1 = dollarFormat(5.00);
		$finalprice = dollarFormat($finalprice - $discount1);
		print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>\$5 off for orders over \$50:</TD><TD ALIGN=\"RIGHT\"><B>-</B>\$$discount1</B></TD></TR>\n";
		}

	$finalprice = dollarFormat($finalprice + $shipprice);

	print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2>Shipping ($shipname):</TD><TD ALIGN=\"RIGHT\">\$$shipprice</B></TD></TR>\n";


	print "<TR><TD>&nbsp;</TD><TD ALIGN=\"RIGHT\" COLSPAN=2><B>TOTAL</B>:</TD><TD ALIGN=\"RIGHT\"><B>\$$finalprice</B></TD></TR>\n";



	print "<TR><TD COLSPAN=2><INPUT NAME=\"action\" TYPE=\"SUBMIT\" VALUE=\"Change Qty\"></TD><TD COLSPAN=2>\n";
	print "<INPUT NAME=\"action\" TYPE=\"SUBMIT\" VALUE=\"Clear Basket\">";
	print "</TD></TR>\n";

	print '</FORM>';

	#                                                              #
	# Let the user choose the platform they would like the font in #
	#                                                              #
	print '<TR><TD COLSPAN=4 ALIGN="CENTER">';
	print '<FORM METHOD="POST" ACTION="order.pl">All prices listed are in United States currency.<BR>';
	print '</TD></TR>';
	print '<TR><TD COLSPAN=4 BGCOLOR="#00B2EB">';
	print '<B>What Platform would you like these fonts?</B>';
	print '</TD></TR>';
	print "<TR><TD COLSPAN=4>";
	print 'Please note that chooseing both Windows and';
	print '<BR>Macintosh will incure a double the charge';
	print '<BR>because it will require that you buy liscences.';
	print '<BR>for each platform.';
	print '<BR>Choosing neither will get you Macintosh';
	print "</TD></TR>\n";
	print "<TR><TD COLSPAN=2 NOWRAP>\n\n";
	print "<INPUT TYPE=\"checkbox\" NAME=\"win\" $winchecked>Windows\n";
	print "<INPUT TYPE=\"checkbox\" NAME=\"mac\" $macchecked>Macintosh\n\n";
	print '<INPUT TYPE="hidden" name="chaction" value="platform">';
	print '</TD><TD COLSPAN=2 ALIGN="CENTER"><INPUT TYPE="SUBMIT" VALUE="CHANGE"></FORM>';
	print '</TD></TR>';

	#                                                            #
	# Let the user choose the format they would like the font in #
	#                                                            #
	print '<TR><TD COLSPAN=4>';
	print '<FORM METHOD="POST" ACTION="order.pl">&nbsp;';
	print '</TD></TR>';
	print '<TR><TD COLSPAN=4 BGCOLOR="#00B2EB">';
	print '<B>What Format would you like these fonts?</B>';
	print '</TD></TR>';
	print "<TR><TD COLSPAN=4>";
	print 'Please note that chooseing both PostScript and';
	print '<BR>True Type will incure a $5.00 charge per font.';
	print '<BR>Choosing neither will get you PostScript';
	print "</TD></TR>\n";
	print "<TR><TD COLSPAN=2 NOWRAP>\n\n";
	print "<INPUT TYPE=\"checkbox\" NAME=\"ttf\" $ttfchecked>True Type\n";
	print "<INPUT TYPE=\"checkbox\" NAME=\"ps\" $pschecked>Post Script\n\n";
	print '<INPUT TYPE="hidden" name="chaction" value="format">';
	print '</TD><TD COLSPAN=2 ALIGN="CENTER"><INPUT TYPE="SUBMIT" VALUE="CHANGE"></FORM>';
	print '</TD></TR>';


	#                                                            #
	# Let the user choose the shipping                           #
	#                                                            #
	print '<TR><TD COLSPAN=4>';
	print '<FORM METHOD="POST" ACTION="order.pl">&nbsp;';
	print '</TD></TR>';
	print '<TR><TD COLSPAN=4 BGCOLOR="#00B2EB">';
	print '<B>How would you like these fonts shipped?</B>';
	print '</TD></TR>';
	print "<TR><TD COLSPAN=2 NOWRAP>\n\n";

	print "    <INPUT TYPE=\"radio\" NAME=\"ship\" Value=\"1\" $shipo1>E-Mail - Free\n";
	print "<BR><INPUT TYPE=\"radio\" NAME=\"ship\" Value=\"2\" $shipo2>Http Download - Free\n";
	print "<BR><INPUT TYPE=\"radio\" NAME=\"ship\" Value=\"3\" $shipo3>US Mail (Disk) - \$5.00\n";
	print "<BR><INPUT TYPE=\"radio\" NAME=\"ship\" Value=\"4\" $shipo4>US Mail (CD-ROM) - \$15.00\n";
	print "<BR><INPUT TYPE=\"radio\" NAME=\"ship\" Value=\"5\" $shipo5>Fed-Ex (Disk) - \$10.00\n";

	print '<INPUT TYPE="hidden" name="chaction" value="shipping">';
	print '</TD><TD COLSPAN=2 ALIGN="CENTER"><INPUT TYPE="SUBMIT" VALUE="CHANGE"></FORM>';
	print '</TD></TR>';

	#                                                            #
	# final ordering stuff                                       #
	#                                                            #
	print '<TR><TD COLSPAN=4>';
	print '<FORM METHOD="POST" ACTION="order.pl">&nbsp;';
	print '</TD></TR>';
	print '<TR><TD COLSPAN=4 BGCOLOR="#00B2EB">';
	print "<B>I'm all set and ready to order.</B>";
	print '</TD></TR>';
	print "<TR><TD COLSPAN=4>";
	print 'Grilledcheese.com currently does not have online ordering';
	print '<BR>capibilities.  To place an order, go to <A href="printorder.pl" target="_top">this page</A> and make ';
	print '<BR>a printout of it. (if you dont have a printer, you can';
	print '<BR>write all the information neatly on a piece of paper,';
	print '<BR>cardboard, wood,  whatever.)  Be sure to fill out the';
	print '<BR>spaces for your name and mailing or email address so ';
	print '<BR>I know where to send the goods';

	print "<BR><BR>Mail the printout and a check or money order for <B>\$$finalprice.00</B>";
	print '<BR>made out to <B>"Approaching Pi, Inc." </B> to :<BR>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>TeA Curran</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>345 Franklin St.</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Suite 308</B>';
	print '<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Cambridge, MA 02139</B>';

	print '<BR><BR>Orders are processed the day they are recieved and';
	print '<BR>shipped the following business day, unless ship method.';
	print '<BR>is via E-mail where they are shipped right away.';

	print '<BR><BR><BR></FORM>';
	print '</TD></TR>';



	#           #
	#debug info #
	#           #
	if ( 1 eq 0 )
		{
		print "<TR><TD COLSPAN=4>";
		print "<B>parms = </B> $COOKIE{parms}<BR>\n";
		print "<B>Form Submit = </B> $herequery2 <BR>\n";
		print "<B>Cookies = </B> $ENV{'HTTP_COOKIE'} <BR>\n";
		print "<B>shipmethod = </B> $shipmethod <BR>";
		print "</TD></TR>\n";
		}
	print "</TABLE>\n";
	}
else
	{
	print "<BR><B>You Have No Items In Your Shopping Basket</B><BR><BR>";
	}
print "</TD></TR></TABLE>";
print "</CENTER>";

print "$footer\n\n";