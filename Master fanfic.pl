#!/usr/bin/perl
use strict;
use warnings;
no warnings 'uninitialized';
use Data::Dumper;
use Text::CSV;
use feature 'unicode_strings';
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use open IN => ":encoding(utf8)", OUT => ":utf8";



my $filename='temp.txt';
my $NAME_CHECK="";
my $COUNTER=0;
my $INPUT_FILE = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $CSV = Text::CSV->new ({
                                              binary    => 1,
                                              auto_diag => 1,
                                              sep_char  => ','    # not really needed as this is the default
                                              }
                                            );

open(my $DATA_IN, '<:encoding(utf8)', $INPUT_FILE) or die "Could not open '$INPUT_FILE' $! - exiting\n";

open(my $DATA_OUT, '>:encoding(utf8)', "output.txt") or die "Could not open: $! -exiting\n";






SETUP ();  #create page setup

while (my $fields = $CSV->getline( $DATA_IN )) 
  {
  ##1	#2	Title	Author	PERM	Done?	BM	FF		AO3	.	Other1	.	RATING	LANGUAGE	STYLE	Chapter #	Length	Published	Updated	Description	
  my $BMSTATUS;            
  my $SORT;
  my $TITLE;
  my $TITLE_FILE;
  my $AUTHOR;
  my $PERMISSION;
  my $DONE;
  my $BM;
  my $FANFIC;
  my $AO3;
  my $OTHER;
  my $RATING = "[[Category:Fanfic-Unrated]]";
  my $TIMELINE;
  my $AUTHOR_ORDER;
  my $SERIES;
  my $SERIES_ORDER;
  my $MASTER_ORDER;
  my $LANGUAGE;
  my $STYLE;
  my $CHAPTERS;
  my $LENGTH;
  my $PUBLISHED;
  my $UPDATED;
  my $DESC;
  my $NOTES;
  my $SHADE;
  
  ####
      $BMSTATUS = $fields->[0];        
      $SORT = $fields->[1];          
      $TITLE = $fields->[2];
       # if($TITLE=~m/(Raumj).*/){$TITLE="Raumjager"}
      $TITLE_FILE=$TITLE;
      $AUTHOR = $fields->[3];
      $PERMISSION = $fields->[4];
      $DONE = $fields->[5];
      $BM = $fields->[6];
      $FANFIC = $fields->[7];
      $AO3 = $fields->[9];
      $OTHER = $fields->[11];
      $RATING = $fields->[13];
      $TIMELINE = $fields->[14];
      $AUTHOR_ORDER = $fields->[15];
      $SERIES = $fields->[16];
      $SERIES_ORDER = $fields->[17];
      $MASTER_ORDER = $fields->[18];
      $LANGUAGE = $fields->[19];
      $STYLE = $fields->[20];
      $CHAPTERS = $fields->[21];
      $LENGTH = $fields->[22];
      $PUBLISHED = $fields->[23];
      $UPDATED = $fields->[24];
      $DESC = $fields->[25];
      $NOTES = $fields->[26];
#######################################


#############
  ################################################################
  ## check to see if html\$TITLE.html exists and if so, open it, read it in and add it to $TITLE_OUT
my $htmlfilename = "html/$TITLE.html";
$htmlfilename =~ s/(\?|\:)//g;
if (-e $htmlfilename) 
  {
    #print "$htmlfilename"; 
  }
else {
  
  print "No $htmlfilename, creating blank\n";
  open my $FH_OUT, '>', "$htmlfilename" or die "Can't open file $!";
  #print $FH_OUT "<poem style=\"border: 2px solid #d6d2c5; background-color: #f9f4e6; padding: 1em; font-family:verdana;\">\n\n\n</poem>\n";
  close $FH_OUT;
  }
  
  
  ##
  ################################################################

  
#############

  if ($BMSTATUS=~ "X")
    {
    #IGNORE ANYTHING WITH AN X IN THE FIRST COLUMN
    }
    
else
  {
	  
$TITLE_FILE =~ s/\?|\'|  |\:|\!//g;

my $TITLE_OUT;

if ($BMSTATUS =~ "COMPLETE")
  {
  open($TITLE_OUT, '>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR-COMPLETE.txt") or die "Could not open $TITLE_FILE: $!\n";
  }
elsif ($BMSTATUS =~ "FINISHING")
## Added to help sort the spreadsheet to avoid confusion.  Change to COMPLETE after scripts are run.
  {
  open($TITLE_OUT, '>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR-FINISHING.txt") or die "Could not open $TITLE_FILE: $!\n";
  }
else
  {
  open($TITLE_OUT, '>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR.txt") or die "Could not open $TITLE_FILE: $!\n";  
    }
	  
  $COUNTER++;
  if (0 == $COUNTER % 2) 
    {
    $SHADE="style=\"background:#D3D3D3\"";
    } 
  else
    {
    $SHADE="";
    }
      
#print $DATA_OUT "| $SORT\n";
#print $DATA_OUT "| {{#ifexist: $TITLE | [[$TITLE]] | $TITLE }} \n";  #Too intensive for Mediawiki

  print $DATA_OUT "|$SHADE|$SORT\n";

# N - not done
# O - offsite only, but categorized
# Y - done
if ($DONE =~ "N")
  {
    print $DATA_OUT "|$SHADE|<i>$TITLE</i>";
  }
elsif ($DONE =~ "O")
  {
    print $DATA_OUT "|$SHADE|$TITLE";
  }
else
  {
  print $DATA_OUT "|$SHADE|[[$TITLE]]";
  #print $DATA_OUT "|\n";
  }

#############
## DESC for Summary Hover ##
#############

if (length $DESC > 0)
  {
    #$DESC=~ s/(\:|\")//g;  #COLONS ARE WIKI BAD
    #print $DATA_OUT "    {{HoverSynopsis|<nowiki>$DESC</nowiki>|$TITLE}}";
  }
else
{}

print $DATA_OUT "\n";
print $DATA_OUT "|$SHADE|$AUTHOR\n";

#print "PERMISSION: $PERMISSION\n";
#print "DONE: $DONE\n";
#print $DATA_OUT "|[[$TITLE]]\n";


if ($FANFIC=~ "^http(.*)")
  {
    print $DATA_OUT "|$SHADE|[[File:Logo FanFiction.jpg|25px|link=$FANFIC]]\n";
      #print $DATA_OUT "|$SHADE|[$FANFIC FF]\n";
      #Logo FanFiction.jpg
  }
else
  {
  print $DATA_OUT "|$SHADE|\n";
  }
  
if ($AO3=~ "^http(.*)")
  {
    #[[Image:Wiki.png|50px|link=MediaWiki]]
      #print $DATA_OUT "|$SHADE|[$AO3 Ao3 ]\n";
      print $DATA_OUT "|$SHADE|[[File:Logo Ao3.jpg|25px|link=$AO3]]\n";
  }
else
  {
  print $DATA_OUT "|$SHADE|\n";
  }

if ($OTHER=~ "^http(.*)")
  {
    #Logo Site.jpg
    print $DATA_OUT "|$SHADE|[[File:Logo Site.jpg|25px|link=$OTHER]]\n";
      #print $DATA_OUT "|$SHADE|[$OTHER Site]\n";
  }
else
  {
  print $DATA_OUT "|$SHADE|\n";
  }
  print $DATA_OUT "|$SHADE|$RATING\n";
 #print $DATA_OUT "| $LANGUAGE\n";
  #print $DATA_OUT "| $STYLE\n";
  #print $DATA_OUT "| $CHAPTERS\n";
  print $DATA_OUT "|$SHADE|$LENGTH\n";
  print $DATA_OUT "|$SHADE|<p style=\"font-size:11px\">$PUBLISHED</p>\n";
  print $DATA_OUT "|$SHADE|$DONE\n";
   #print "UPDATED: $UPDATED\n";
  #print "DESC: $DESC\n";
  #print "NOTES: $NOTES\n";
  print $DATA_OUT "|-\n";
  #print $TITLE_OUT "$BM";
  #####
  
  #$FANFIC = $fields->[7];
  #$AO3 = $fields->[9];
  #$OTHER = $fields->[11];


if ($AO3=~ "^http(.*)" || $FANFIC=~ "^http(.*)" || $OTHER=~ "^http(.*)")
	{
	if ($AO3=~ "^http(.*)://archiveofourown.org/works/(.*)")
	  {
		$AO3 = $2;
		print $TITLE_OUT "{{FanFicExists|$AUTHOR|{{AOOO|$AO3}}|$OTHER|$FANFIC}}\n\n";
	  }
	  else
		{
	  print $TITLE_OUT "{{FanFicExists|$AUTHOR|$OTHER|$FANFIC||}}\n\n";
		}
	}
  
  print $TITLE_OUT "<!-- HEADER START -->\n"; 
  print $TITLE_OUT "__NOTOC__\n";  
  print $TITLE_OUT "{{HideTitle}}\n";
  print $TITLE_OUT "<center>\n";
  print $TITLE_OUT "<h1>{{PAGENAME}}</h1>\n";
  print $TITLE_OUT "<h2></h2>\n";
  print $TITLE_OUT "<h3>by $AUTHOR</h3><br>\n";
  print $TITLE_OUT "<h4>Rated: $RATING</h4></center><br>\n";
  if (length $DESC > 0)
  {
    print $TITLE_OUT "'''Summary:'''  <nowiki>$DESC</nowiki>";
  }
else
{print $TITLE_OUT "<!-- '''Summary:''' -->\n";}
  
  print $TITLE_OUT "\n";
  print $TITLE_OUT "\n";
  print $TITLE_OUT "<hr><br><br>\n";
  print $TITLE_OUT "<!-- HEADER END -->\n"; 
  
  
  ################################################################
  ## check to see if html\$TITLE.html exists and if so, open it, read it in and add it to $TITLE_OUT
  #$filename = "html/$TITLE.html";
if (-e $htmlfilename) 
  {
  #print "$filename Exists!!!!!!!!!";
  
  open my $fh, '<', "$htmlfilename" or die "Can't open file $!";
  my @lines = readline $fh;
  
  
  if ($PERMISSION =~ "(NEED|UNFINISHED)")
    {
    print $TITLE_OUT "<!--  PERMISSION: $PERMISSION\n";
    print $TITLE_OUT "      Material collected however not made available for display.\n";
    print $TITLE_OUT "<poem style=\"border: 2px solid #d6d2c5; background-color: #f9f4e6; padding: 1em; font-family:verdana;\">";
    print {$TITLE_OUT} @lines;
    print $TITLE_OUT "<\/poem>";
    print $TITLE_OUT "-->\n";
    print $TITLE_OUT "[[Category:FanFic-NeedsPermission]]\n";
    print $TITLE_OUT "[[Category:FanFic-NeedsPermission-$AUTHOR]]\n";
  
  
    }
else
    {
    print $TITLE_OUT "<!--  PERMISSION DERIVED FROM: $PERMISSION \n";
    print $TITLE_OUT "      YES or PERM comes from messaging and\\or email.  RB has attempted to keep track of this.\n";
    print $TITLE_OUT "      GRCD1 or RANGER-L derives from posting or inclusion within the fan community.\n";
    print $TITLE_OUT "      Archive.org, OoOCities.org, etc derived from rescuing material that was publically available and has fallen to the archives as the original website has gone away.  BetaMountain is attempting to provide a collective archive of material.\n";
    print $TITLE_OUT "      *********** IF THERE ARE ANY DISPUTES ON THE ABOVE OR CHANGES REQUESTED PLEASE CONTACT RB DIRECTLY WITH DETAILS ********\n";
    print $TITLE_OUT "-->\n";
    print $TITLE_OUT "<poem style=\"border: 2px solid #d6d2c5; background-color: #f9f4e6; padding: 1em; font-family:verdana;\">";
    print {$TITLE_OUT} @lines;
    print $TITLE_OUT "<\/poem>";
    print $TITLE_OUT "\n";
    }

  
  close $fh;
  }
else {
  
  #print "No $filename\n";
  # create a blank file for later 
  }
  
  
  ##
  ################################################################
  
  
  print $TITLE_OUT "\n";
  print $TITLE_OUT "<!-- FOOTER START -->\n"; 
  print $TITLE_OUT "[[Category:Fanfic]]\n";
  print $TITLE_OUT "[[Category:Fanfic-$RATING]]\n";
  print $TITLE_OUT "[[Category:Fanfic-$AUTHOR]]\n";  
  if ($PERMISSION =~ "GRCD")
    {
      print $TITLE_OUT "[[Category:GRCD1]]\n";  
      }
  
  print $TITLE_OUT "\n\n<!-- ********************************************************************************************************** -->\n";      
  print $TITLE_OUT "<!-- Review items for clean up -->\n";      
  print $TITLE_OUT "<!-- Does the page look good (and can it be helped?) -->\n";      
  print $TITLE_OUT "<!-- If fanfic exists elsewhere, is the new template in place? Did we include all the links? -->\n";      
  print $TITLE_OUT "<!-- If additional links are found, send to RB to put in the master spreadsheet as well as add them here -->\n";      
  print $TITLE_OUT "<!-- If everything looks good, remove the next lines and set the Finished marker. -->\n";      
  print $TITLE_OUT "<!-- ********************************************************************************************************** -->\n";      
  #print $TITLE_OUT "[[Category:FanFic-CheckFormat]]\n\n";   
  #print "$BMSTATUS\n";
  
  
  ## Consider check earlier on to see if Permission has been granted and include the .html file or not
  
  # B = needs both + needs permission
  # FI = COMPLETE
  # FU = needs index
  # UU needs both
  # UI = needs formatting
  # EI = needs permission to import
  
  if ($BMSTATUS =~ "B")
    {
     print $TITLE_OUT "[[Category:FanFic-CheckFormat]]\n";
     print $TITLE_OUT "[[Category:FanFic-NeedsIndex]]\n";
     print $TITLE_OUT "[[Category:FanFic-NeedsImporting]]\n";
    }
  elsif  ($BMSTATUS =~ "COMPLETE")
    {
     print $TITLE_OUT "[[Category:FanFic-Finished]]\n";
    }
  elsif  ($BMSTATUS =~ "FINISHING")
    {
     print $TITLE_OUT "[[Category:FanFic-Finished]]\n";
    }
  elsif  ($BMSTATUS =~ "FI")
    {
     print $TITLE_OUT "[[Category:FanFic-Finished]]\n";
    }
  elsif  ($BMSTATUS =~ "FU")
    {
     print $TITLE_OUT "[[Category:FanFic-NeedsIndex]]\n";
    }
  elsif ($BMSTATUS =~ "UU")
    {
     print $TITLE_OUT "[[Category:FanFic-CheckFormat]]\n";
     print $TITLE_OUT "[[Category:FanFic-NeedsIndex]]\n";
    }
  elsif ($BMSTATUS =~ "UI")
    {
     print $TITLE_OUT "[[Category:FanFic-CheckFormat]]\n";
    }
  elsif ($BMSTATUS =~ "EI")
    {
    print $TITLE_OUT "[[Category:FanFic-NeedsImporting]]\n";
    }
   else
    {
      print $TITLE_OUT "[[Category:FanFic-CheckFormat]]\n";
      print $TITLE_OUT "[[Category:FanFic-NeedsIndex]]\n";
      print $TITLE_OUT "[[Category:FanFic-NeedsImporting]]\n";
  }   
  #print $TITLE_OUT "[[Category:FanFic-NeedsIndex]]\n\n";   
  #print $TITLE_OUT "<!--Leave only the following (remove the comment container): [[Category:FanFic-Finished]] -->\n\n\n";  
  print $TITLE_OUT "<!-- FOOTER END -->\n"; 
      
      
  print "$COUNTER - $TITLE-\n";
  }
  ######## 
    $BMSTATUS="";         
    $SORT="";
    $TITLE="";
    $TITLE_FILE="";
    $AUTHOR="";
    $PERMISSION="";
    $DONE="";
    $BM="";
    $FANFIC="";
    $AO3="";
    $OTHER="";
    $RATING = "[[Category:Fanfic-Unrated]]";
    $LANGUAGE="";
    $STYLE="";
    $CHAPTERS="";
    $LENGTH="";
    $PUBLISHED="";
    $UPDATED="";
    $DESC="";
    $NOTES="";
     
 ####
  }
 
if (not $CSV->eof) 
    {
    $CSV->error_diag();
    }

close $DATA_IN;
print $DATA_OUT "|}\n";
FINISHED ();
close $DATA_OUT;

sub CATEGORY
  {
    my $in=shift;
    if (defined $in && length $in > 0)
      {
      #print $fh "[[Category:$in]]\n";
      }
    }
    
sub BOX_OUTPUT
  {
    my ($type, $val) = @_;
    if (defined $val && length $val > 0)
      {
      print "$type: $val\n";
      }
    }
    
    
  sub SETUP
    {
      print $DATA_OUT "See Also [[:Category:Fanfic]]\n\n";
      print $DATA_OUT "'''''Note:''' This page is under construction and there are parts missing from the list.''<br>\n";
      print $DATA_OUT "'''''Note:''' Titles in italics have not been cataloged and the stories are offsite''<br>\n";
      print $DATA_OUT "'''''Note:''' Titles without links have been cataloged and the stories are offsite''<br>\n";
      print $DATA_OUT "{| class=\"wikitable sortable\" style=\"margin: 1ex auto 1ex auto\"\n";
      print $DATA_OUT "! Sort\n";
      print $DATA_OUT "! Title\n";
      print $DATA_OUT "! Author\n";
      #print $DATA_OUT "! BM\n";
      print $DATA_OUT "! FF\n";
      print $DATA_OUT "! AO3\n";
      print $DATA_OUT "! Site\n";
      print $DATA_OUT "! Rating\n";
      #print $DATA_OUT "! Language\n";
      #print $DATA_OUT "! Style\n";
      #print $DATA_OUT "! Chapters\n";
      print $DATA_OUT "! Length\n";
      print $DATA_OUT "! Published\n";
      print $DATA_OUT "! Status\n";
      print $DATA_OUT "|-\n";
      }
      
    sub FINISHED
      {
      print $DATA_OUT "\n\n\n";
      print $DATA_OUT "[[Category:Spreadsheet]]\n";    
      print $DATA_OUT "[[Category:Perl]]\n";    
      }
