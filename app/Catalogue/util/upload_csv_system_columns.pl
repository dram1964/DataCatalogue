#!/usr/bin/perl
use strict;
use warnings;

use Catalogue::Systems::Importer;
use Text::CSV;

my @rows;
my $line = 0;

my $csv = Text::CSV->new( {binary => 0} ) or die "Cannot use CSV: " . Text::CSV->error_diag();
open my $fh, "<:encoding(utf8)", "/home/dr00/Catalogue/data/urisl.csv" or die $!;

while (my $row = $csv->getline( $fh) ) {
  $row->[0] =~ s/\W//;
  $line++;
  print "$row->[0]\n" unless $line > 1;
  push @rows, $row; 
}

$csv->eof or $csv->error_diag();
close $fh;

print join(":", qw/Row System Database Schema Table Column Type Size/), "\n";

my $test_run = 1;
&load_data($test_run);
&load_data();

sub load_data {
	my $data;
	my $limit = $test_run ? 15 : (scalar @rows) - 1;
	for my $row (0..$limit ) {
    		$data = {'server_name' => 'urisl',
			'database_name' => 'RIS',
			'schema_name' => $rows[$row]->[0],
			'table_name' => $rows[$row]->[1],
			'column_name' => $rows[$row]->[2],
			'column_type' => $rows[$row]->[3],
			'column_size' => $rows[$row]->[6],
        	};
		my $import = Catalogue::Systems::Importer->new($data);
		print join(":", "($row of $limit)", $import->server_name, 
		  $import->database_name, $import->schema_name, 
		  $import->table_name, $import->column_name, 
		  $import->column_type, $import->column_size), "\n";
		$import->add_or_update_database unless $test_run;
		$data = ();
	}
	if ($test_run) {
		 print "Adding Records above to the database. Really continue? (y|N)";
		my $response = <STDIN>;
		die "Aborting update at user request" unless $response =~ /^y/i;
	} 
	print "Records Inserted\n" unless $test_run;
	$test_run = 0;
}
