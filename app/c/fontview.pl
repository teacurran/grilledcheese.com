#!/usr/bin/perl
##############################################################################
# fontview.pl                         Version 1.0.0                               #
# Copyright 1998                   TeA Curran                      #
# Created 7/4/98                   Last Modified 7/4/98                       #
# Notes:                   This Script calls up a font name identified by the fname         #
#                              parameter in the url.   height and width parameters for this   #
#                              font image are optional, they are called height and name, easy#
############################################################

# Set Variables
$guestlog = "${basedir}guestlog.html";
$cgiurl = "http://www.tacoland.com/cgi-bin/taco-cgi/guestbook.pl";
$date_command = "/usr/bin/date";

# Set Your Options:

# If you answered 1 to $mail or $remote_mail you will need to fill out
# these variables below:
$mailprog = '/usr/lib/sendmail';
$recipient = 'tea@soundstone.com';

# Get the Date for Entry
$date = `$date_command +"%A, %B %d, %Y at %T (%Z)"`; chop($date);
$shortdate = `$date_command +"%D %T %Z"`; chop($shortdate);

# Get the input
$buffer = $ENV{'QUERY_STRING'};

if ($ENV{'REQUEST_METHOD'} eq "GET")
    {
    $herequery = $ENV{'QUERY_STRING'};
    }
else
    {
    read(STDIN, $herequery, $ENV{'CONTENT_LENGTH'});
    }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs)
   {
   ($name, $value) = split(/=/, $pair);

   # Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
    }

$fname = $FORM{'fname'};

$fonturl = "/fonts/";
$fontreal = "${basedir}fonts/";

$fontmacttf = "mac/". $fname ."ttf\.sit\.hqx";
$fontmacps = "mac/". $fname ."ps\.sit\.hqx";
$fontpcttf = "pc/". $fname ."ttf\.zip";
$fontpcps = "pc/". $fname ."ps\.zip";

# set the image height #
if ($FORM{'height'} ne 0 and $FORM{'height'} ne "")
    {
     $imageheight = $FORM{'height'};
    }
else
    {
     $imageheight = 200;
    }

#set the image width #
if ($FORM{'width'} ne 0 and $FORM{'width'} ne "")
    {
     $imagewidth = $FORM{'width'};
    }
else
    {
     $imagewidth = 300;
    }

print "Content-type: text/html\n\n";
print "<HTML><BODY BGCOLOR=\"#FFFFFF\" Background=\"http://www.grilledcheese.com/img/yellowcode.gif\" text=\"#FFFFFF\" ><HEAD><TITLE>-----(grilledcheese.com) ($fname)------</TITLE></HEAD>
<IMG SRC=\"/img/leftcornersmall.gif\" ALIGN=\"Left\">\n";

print "<CENTER><BR>&nbsp\;<BR>\n";
print "<TABLE BORDER=1 CELLPADDING=0 CELLSPACING=0 WIDTH=350>\n";
print "<TR><TD WIDTH=300 HEIGHT=200 VALIGN=\"TOP\" BGCOLOR=\"#000000\" COLSPAN=3>\n";
print "<IMG SRC=\"/img/font/$fname.gif\" height=$imageheight width=$imagewidth>\n";

print "</TD><TD VALIGN=\"top\" rowspan=4>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedot.gif\"><BR>\n";
print "<IMG SRC=\"/img/sidedotbottom.gif\"><BR>\n";
print "</TD></TR>\n";
print "<TR><TD BGCOLOR=\"#000000\">&nbsp;\n";

print "</TD><TD VALIGN=\"TOP\" ALIGN=\"RIGHT\" BGCOLOR=\"#000000\">\n";

if (-e "$fontreal$fontmacttf")
    {
     print "<A Href=\"$fonturl$fontmacttf\">\n";
     print "<IMG SRC=\"img/macintoshttf.gif\" BORDER=0></A><BR>\n";
    }

if (-e "$fontreal$fontpcttf")
    {
     print "<A Href=\"$fonturl$fontpcttf\">\n";
     print "<IMG SRC=\"/img/windowsttf.gif\" BORDER=0></A><BR>\n";
    }

if ($FORM{'o'} eq 1)
    {
     print "<A Href=\"order.pl?fname=$fname\"><IMG SRC=\"/img/ordernow.gif\" BORDER=0 HEIGHT=33 WIDTH=96></A>\n";
     }

print "</TD><TD  VALIGN=\"TOP\" ALIGN=\"RIGHT\" BGCOLOR=\"#000000\">&nbsp\;\n";

print "</TD></TR>\n";
print "<TR><TD COLSPAN=3 VALIGN=\"TOP\" ALIGN=\"RIGHT\" BGCOLOR=\"#000000\">\n";
print "&nbsp\;\n";
print "</TD></TR>\n";
print "</TABLE>\n";
print "</CENTER>\n";
print "</HTML>\n";


