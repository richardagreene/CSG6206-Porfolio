#!/usr/bin/perl
use strict;
use warnings;

die "Error; incorrect parameters, syntax: $0 <filename>\n example: $0 sample.csv\n " if @ARGV != 1;
die "Error; file should be comma separated value (.csv), syntax: $0 <filename>\n example: $0 sample.csv\n " if index(lc $ARGV[0], ".csv") == -1;

my $index;
foreach my $line (<>) {
    chomp( $line );
    my @fields = split "," , $line;
    if(scalar @fields < 4 )
    {
        print("Line:" . $index . " not formatted correctly\n");
        $index++;
        next
    }
    my $name = $fields[0];
    my $studentId = $fields[1];
    my $email = $fields[2];
    my @courses = split " " , $fields[3];
    my $studentType = "Undergraduate";
    my $enrolment = "Part Time";

    foreach my $course (@courses) {
         $course =~ s/^\s+|\s+$//g;
         if(substr($course, 3,1) == "5" || substr($course, 3,1) == "6") {
             $studentType = "Postgraduate";
         }
    }

    if($studentType eq "Undergraduate" && scalar @courses > 2 ) {
        $enrolment = "Full time";
    }
    if($studentType eq "Postgraduate" && scalar @courses > 1 ) {
        $enrolment = "Full time";
    }

    print("Name: ". $name . "\n");
    print("Student: " . $studentId . "\n");
    print("Email: " . $email . "\n");
    print("Units Enrolled: " . $fields[3] . "\n");
    print("Enrolment Mode: " . $enrolment . "\n");
    print("Student Type: " . $studentType . "\n\n");
    $index++;
}


