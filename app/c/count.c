/*
  count.c
  
  By Bill Kendrick
  New Breed Software
  February 14, 1996 / September 30, 1996 / December 18, 1996
  
  Update's a page's hit counter and displays the value (unless "QUIET" is
  used as the image prefix).  Displays ALTed images (unless "NONE" is used
  as the image prefix, or it's missing altogether).

  Based on the "count" and "nocount" directives from my "counter.cgi"
  'CGI-Side-Include' program.

  Call with: "count count-file [image prefix] {width height}"

  Examples:
    This page has been visited:
      <!--#exec cmd="count counter.dat counter-gifs/blue" -->  times.

   This page has been visited:
     <!--#exec cmd="count counter.dat counter-gifs/blue 16 16" -->  times.

    This page has been visited:
      <!--#exec cmd="count counter.dat NONE" -->  times.

    This page has been visited:
      <!--#exec cmd="count counter.dat" -->  times.
      
    <!--#exec cmd="count counter.dat QUIET" -->

*/


/* -- If you're running on a System V Unix system, uncomment this: -- */

#define SYSV


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char * argv[])
{
	printf("here is a test\n");
	exit(0);
}
