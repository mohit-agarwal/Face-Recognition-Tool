#!/usr/bin/env perl

use strict;
use warnings;
use File::Copy;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

my $source_dir = "/home/mohit/2013Monsoon/SMAI/Project/CroppedYale";
my $target_dir = "/home/mohit/2013Monsoon/workspace/data1";

opendir(my $DIR, $source_dir) || die "can't opendir $source_dir: $!";  
#my @files = readdir($DIR);
my @files = glob( $source_dir . '/*' );
#print @files,"\n\n\n";

foreach my $t (@files)
{
    print $t,"\n";
	opendir(my $tmp,$t);
	my @tempfiles = readdir($tmp);
   
    #print @tempfiles,"\n";
	my $count=0;
	my $lbound=-25;
	my $ubound=25;
	
	while($count < 20){
		
		foreach my $x (@tempfiles)
		{	
			if( ! (-e "$target_dir/$x")){ #if the file is already not there	
			
				if(-f "$t/$x" && ( (length $x) == 24) ){	#taking only the required files, Check with -f only for files (no directories)
				
					if( $lbound <= substr($x,13,3) && substr($x,13,3)<=$ubound && $lbound <= substr($x,18,2) && substr($x,18,2)<=$ubound ){ #checking the bounds
						#print $x," copied   ",substr($x,13,3),"    ",substr($x,18,2),"\n";
						copy "$t/$x", "$target_dir/$x";
						$count = $count+1;
						if($count == 20){
							last;
						}
					}
				}
			}
		}
		$lbound -= 5;
		$ubound += 5;
	}
	closedir($tmp);
	#print $count,"\n";
}

closedir($DIR);
