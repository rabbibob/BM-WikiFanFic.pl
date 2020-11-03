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




while (my $fields = $CSV->getline( $DATA_IN )) 
  {
  #FanFic Name,Type,Name,T Appearance\Reference,Notes,BM,Author,Category To Post,Author Category,Do not Edit,Do Not Edit,Do Not Edit
  my $TITLE;
  my $TITLE_FILE;
  my $CATEGORY;
  my $AUTHOR;
  
  ####
      $TITLE = $fields->[0];
      $CATEGORY = $fields->[7];
      $AUTHOR = $fields->[6];
     # if($TITLE=~m/(Raumj).*/){$TITLE="Raumjager"}
      $TITLE_FILE=$TITLE;


#############
 
my $TITLE_OUT;
$TITLE_FILE =~ s/\?|\'|  |\:|\!//g;

#my $checkoutputexists = "fanfic/$TITLE_FILE-$AUTHOR-FINISHING.txt";

if (-e "fanfic/$TITLE_FILE-$AUTHOR-FINISHING.txt") 
    {
    open($TITLE_OUT, '>>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR-FINISHING.txt") or die "Could not open $TITLE_FILE: $!\n";
    }
elsif (-e "fanfic/$TITLE_FILE-$AUTHOR-COMPLETE.txt") 
    {
    open($TITLE_OUT, '>>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR-COMPLETE.txt") or die "Could not open $TITLE_FILE: $!\n";
    }
else
    {
    open($TITLE_OUT, '>>:encoding(utf8)', "fanfic/$TITLE_FILE-$AUTHOR.txt") or die "Could not open $TITLE_FILE: $!\n";
    }

print $TITLE_OUT "$CATEGORY\n";
#print "$TITLE - $CATEGORY\n";
    $TITLE="";
    $TITLE_FILE="";
    $CATEGORY="";

close $TITLE_OUT;
 ####
  }
 
if (not $CSV->eof) 
    {
    $CSV->error_diag();
    }

close $DATA_IN;

#FINISHED ();

