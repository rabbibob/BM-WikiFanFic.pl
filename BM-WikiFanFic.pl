#!/usr/bin/perl
use strict;
use warnings;
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

open(my $DATA_IN, '<:encoding(utf8)', $INPUT_FILE) or die "Could not open '$INPUT_FILE' $!\n";
open(my $DATA_OUT, '>:encoding(utf8)', "output.txt") or die "Could not open: $!\n";

SETUP ();  #create page setup

while (my $fields = $CSV->getline( $DATA_IN ))
  {
  ##1	#2	Title	Author	PERM	Done?	BM	FF		AO3	.	Other1	.	RATING	LANGUAGE	STYLE	Chapter #	Length	Published	Updated	Description
  my $skip_1;
  my $SORT;
  my $TITLE;
  my $AUTHOR;
  my $PERMISSION;
  my $DONE;
  my $BM;
  my $FANFIC;
  my $AO3;
  my $OTHER;
  my $RATING;
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
      $skip_1 = $fields->[0];
      $SORT = $fields->[1];
      $TITLE = $fields->[2];
       # if($TITLE=~m/(Raumj).*/){$TITLE="Raumjager"}
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

#############

  if ($skip_1=~ "X")
    {
    #IGNORE ANYTHING WITH AN X IN THE FIRST COLUMN
    }

else
  {
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

if ($DONE =~ "N")
  {
    print $DATA_OUT "|$SHADE|$TITLE\n";
  }
else
  {
  print $DATA_OUT "|$SHADE|[[$TITLE]]\n";
  #print $DATA_OUT "|\n";
  }

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
  print $DATA_OUT "|$SHADE|$PUBLISHED\n";
  #print "UPDATED: $UPDATED\n";
  #print "DESC: $DESC\n";
  #print "NOTES: $NOTES\n";
  print $DATA_OUT "|-\n";
  print "$COUNTER - $TITLE-\n";
  }
  ########
    $skip_1="";
    $SORT="";
    $TITLE="";
    $AUTHOR="";
    $PERMISSION="";
    $DONE="";
    $BM="";
    $FANFIC="";
    $AO3="";
    $OTHER="";
    $RATING="";
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
      print $DATA_OUT "'''''Note:''' This page is under construction and there are parts missing from the list.''\n\n";
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
      print $DATA_OUT "|-\n";
      }

    sub FINISHED
      {
      print $DATA_OUT "\n\n\n";
      print $DATA_OUT "[[Category:Spreadsheet]]\n";
      print $DATA_OUT "[[Category:Perl]]\n";
      }