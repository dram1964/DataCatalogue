#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Spreadsheet::XLSX;
use Text::Iconv;

use Catalogue::Importer::Database;

my $server_name;
my $sheet_number = 0;
my $first_data_row = 0;
my $help;

GetOptions("server=s" => \$server_name, 
	"worksheet=i" => \$sheet_number, 
	"data_from=i" => \$first_data_row,
	"help" => \&help) or &help();

&help() if ($help || !$server_name);

my $filename = "data/$server_name.xlsx";
die "Import file '$filename' not found\n" unless (-f $filename);

my $converter = Text::Iconv->new("utf-8", "windows-1251");
my $excel = Spreadsheet::XLSX->new($filename, $converter);
my $sheet = $excel->{Worksheet}->[$sheet_number];
my ( $row_min, $row_max ) = $sheet->row_range();
my ( $col_min, $col_max ) = $sheet->col_range();

print join(":\t", qw/Row Server Database Schema Table Column Type Size/), "\n";

my $test_run = 1;
&load_data($test_run);
&load_data();

sub load_data {
	my $data;
	my $rows = $test_run ? 15 : $row_max;
	for my $row ($first_data_row..$rows ) {
    	my @record;
    	for my $col ( $col_min .. $col_max ) {
			my $cell = $sheet->get_cell( $row, $col );
        	next unless $cell;
			push (@record, $cell->value());
    	}
    	$data = {'server_name' => $server_name,
			'database_name' => $record[0],
			'schema_name' => $record[1],
			'table_name' => $record[2],
			'column_name' => $record[3],
			'column_type' => $record[7],
			'column_size' => $record[8],
    	};
		my $import = Catalogue::Importer::Database->new($data);
		print join(":", "($row of $row_max)", $import->server_name, 
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

sub help() {
	print <<HELPTEXT;
Usage: $0 -s servername -w 0 -d 0

-s --server		Name of file to load without '.xlsx' extension
                	Will be used as server name during upload
-w --worksheet		Worksheet index. Begins at 0
-d --data_from		Number of header rows to skip

HELPTEXT
	exit 0;
}

