use strict;
use warnings;

use LWP::Simple;



#my $url = 'https://docs.google.com/spreadsheets/d/1U_mtxhf4Qjx8RQWuWQoQFk57NlROtGReRHLcxClTgd0/gviz/tq?tqx=out:csv&sheet=FanFic - Master List';
my $url = 'https://docs.google.com/spreadsheets/d/1U_mtxhf4Qjx8RQWuWQoQFk57NlROtGReRHLcxClTgd0/export?gid=1454785779&format=csv';
my $file = 'Galaxy Rangers - The Spreadsheet - FanFic - Master List.csv';

getstore($url, $file);

$url = 'https://docs.google.com/spreadsheets/d/1U_mtxhf4Qjx8RQWuWQoQFk57NlROtGReRHLcxClTgd0/export?gid=854799729&format=csv';
$file = 'Galaxy Rangers - The Spreadsheet - Fanfic - Appearances.csv';
getstore($url, $file);

