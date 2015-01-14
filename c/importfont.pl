#!/usr/bin/perl -w
use DB_File;


require "../application.pl";

$fontsdbm = "${basedir}data/dbm/fonts";
$exportfile = "${basedir}static/db.txt";


$fname = $FORM{'fname'};

open (FILE,"$exportfile");
@LINES=<FILE>;
close(FILE);
$SIZE=@LINES;

# dbmopen %FONTS, $fontsdbm, 0666;
tie(%FONTS, "DB_File", $fontsdbm, O_CREAT|O_RDWR, 0666, $DB_File::DB_BTREE) || die "Can't open $fontsdbm: $!\n";

for ($i=0;$i<=$SIZE;$i++) {
   $_=$LINES[$i];

   ($key, $value) = split(/\|\|\|/, $_);

   $FONTS{$key} = $value;
   print "$key\n$value\n";
}

untie %FONTS;

print "done";

