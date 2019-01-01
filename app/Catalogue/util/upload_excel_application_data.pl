#!/usr/bin/perl
use strict;
use warnings;

use Catalogue::Importer::Application;
use Spreadsheet::XLSX;
use Text::Iconv;

my $converter = Text::Iconv->new("utf-8", "windows-1251");

my $excel = Spreadsheet::XLSX->new('/home/dr00/Catalogue/data/kpe.xlsx', $converter);

my $kpe = $excel->{Worksheet}->[0];

my ( $row_min, $row_max ) = $kpe->row_range();
my ( $col_min, $col_max ) = $kpe->col_range();

print join(":\t", qw/Row KPE ERID Category2 Supplier Application ApplicationDescription/), "\n";

my $test_run = 1;
&load_data($test_run);
&load_data();

sub load_data {
	my $data;
	my $rows = $test_run ? 15 : $row_max;
	for my $row (1..$rows ) {
		my @record;
	    	for my $col ( $col_min .. $col_max ) {
			my $cell = $kpe->get_cell( $row, $col );
			my $value = defined($cell) ? $cell->value() : '';
			$value = &fix_text($value);
			push (@record, $value);
	    	}
		$data = {'kpe' => $record[0],
				'erid' => $record[1],
				'category2' => $record[2],
				'supplier' => $record[3],
				'application' => $record[4],
				'application_desc' => $record[5],
		};
		my $import = Catalogue::Importer::Application->new($data);
		print join(":", "($row of $row_max)", 
			$import->kpe, 
			$import->erid,
			$import->category2, 
			$import->supplier, 
			$import->application,
			$import->application_desc), "\n";
                if (!$import->application) {
		    print "skipping row $row: no application name\n" unless $data->{application};
		    next;
		}
		$import->add_or_update_application unless $test_run;
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

sub fix_text() {
  my $text = shift;
    if ($text =~ /&amp;/) {
      $text =~ s/&amp;/&/g;
    }
    if ($text =~ /&quot;/) {
      $text =~ s/&quot;/'/g;
    }
    if ($text =~ /&#10;/) {
      $text =~ s/&#10;/\n/g;
    }
    if ($text =~ /\s*$/) {
      $text =~ s/\s*$//g;
    }
    if ($text =~ /\s*$/) {
      $text =~ s/\s*$//g;
    }
    return $text;
}
