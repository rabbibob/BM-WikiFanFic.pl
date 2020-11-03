rd /s /q "fanfic\finishing"
rd /s /q "fanfic\Done"
rd /s /q "fanfic"
mkdir fanfic
mkdir fanfic\finishing
mkdir fanfic\done
perl "download.pl"
perl "Master fanfic.pl" "Galaxy Rangers - The Spreadsheet - FanFic - Master List.csv"
perl "Appearances fanfic.pl" "Galaxy Rangers - The Spreadsheet - Fanfic - Appearances.csv"
move /Y fanfic\*COMPLETE.txt fanfic\done
move /Y fanfic\*FINISHING.txt fanfic\finishing
