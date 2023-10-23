#!/usr/bin/perl -w

$mailprog = '/usr/lib/sendmail';
$recipient = 'gill@grilledcheese.com';
$sender = 'cupid@friendfinder.com';

# Open The Mail Program
open(MAIL,"|$mailprog -t");

print MAIL "To: $recipient\n";
print MAIL "From: $sender ($sender)\n";

print MAIL "Subject: Response to your profile\n\n";

print MAIL "You have recieved a response to your profile on Friend Finder from lil_jess.\n\n";
print MAIL "To view the response, log in at http://FriendFinder.com and click below the mailbox in the top left corner.\n\n";
print MAIL "Best of Luck!\n\n";
print MAIL "The Friend Finder Cupid Team\n\n";
close (MAIL);