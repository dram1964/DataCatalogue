package Catalogue::Importer::Winpath::TestCode;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Winpath::TestCode

=head1 Description

Module to import Winpath Test Codes to wp_test table

=head1 Synopsis

my $test = Catalogue::Importer::Winpath::TestCode->new(
	code => 'WCC',
	name => 'White Cells',
	laboratory_code => 'BA',
	units => 'm/mol',
	function => 'xsi',
	flags => 'xx',
	report_section => 'X',
	line_number => '23'
);

$test->update_or_add;
$test->delete;

=cut

has 'code' => ( is => 'rw', isa => 'Str', required => 1);
has 'name' => ( is => 'rw', isa => 'Str',  required => 1);
has 'laboratory_code' => ( is => 'rw', isa => 'Str',  required => 1);
has 'units' => ( is => 'rw', isa => 'Str', required => 1);
has 'function' => ( is => 'rw', isa => 'Str', required => 1);
has 'flags' => ( is => 'rw', isa => 'Str', required => 1);
has 'report_section' => ( is => 'rw', isa => 'Str', required => 1);
has 'line_number' => ( is => 'rw', isa => 'Int', required => 1);

=head1 Methods

=head2 update_or_add

updates or adds the record to the wp_laboratory table

$lab->update_or_add;

=cut 

sub update_or_add() {
	my $self = shift;
	my $test_rs = $self->schema->resultset('WpTest')->update_or_create(
		code => $self->code,
		name => $self->name,
		laboratory_code => $self->laboratory_code,
		units => $self->units,
		function => $self->function,
		flags => $self->flags,
		report_section => $self->report_section,
		line_number => $self->line_number,
	);
}

=head2 delete

deletes the record from the wp_order table

$order->delete

=cut 

sub delete() {
	my $self = shift;
    my $rs = $self->schema->resultset('WpTest')->find({
		code => $self->code,
		laboratory_code => $self->laboratory_code
    });
    if (!$rs) {
		print $self->code, ": ", 
		    $self->laboratory_code, " not found: nothing to delete\n";
		return 0;
    } else {
		$rs->delete;
    }

}


1;
