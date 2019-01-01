package Catalogue::Importer::Winpath::Fact;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Winpath::Fact

=head1 Description

Module to import Winpath Data to wp_fact table

=head1 Synopsis

my $fact = Catalogue::Importer::Winpath::Fact->new(
	order_code => 'FBC',
	fact_code => 'WCC',
	laboratory_code => 'BA',
	cluster_name => 'Haematology',
	year_of_birth => '1964',
	year_of_result => '2010',
	gender => 'U',
	requests => '23'
);

$fact->update_or_add;
$fact->delete;

=cut

has 'order_code' => ( is => 'rw', isa => 'Str', required => 1);
has 'test_code' => ( is => 'rw', isa => 'Str', required => 1);
has 'laboratory_code' => ( is => 'rw', isa => 'Str', required => 1);
has 'cluster_name' => ( is => 'rw', isa => 'Str', required => 1);
has 'year_of_birth' => ( is => 'rw', isa => 'Int', required => 1);
has 'year_of_result' => ( is => 'rw', isa => 'Int', required => 1);
has 'gender' => ( is => 'rw', isa => 'Str', required => 1);
has 'requests' => ( is => 'rw', isa => 'Int', required => 1);

=head1 Methods

=head2 update_or_add

updates or adds the record to the wp_fact table

$lab->update_or_add;

=cut 

sub update_or_add() {
	my $self = shift;
	my $testcode_rs = $self->schema->resultset('WpTest')->find_or_create(
		code => $self->test_code,
		laboratory_code => $self->laboratory_code);
	my $test_rs = $self->schema->resultset('WpFact')->update_or_create(
		order_code => $self->order_code,
		test_code => $self->test_code,
		laboratory_code => $self->laboratory_code,
		cluster_name => $self->cluster_name,
		year_of_birth => $self->year_of_birth,
		year_of_result => $self->year_of_result,
		gender => $self->gender,
		requests => $self->requests,
	);
}

=head2 delete

deletes the record from the wp_order table

$order->delete

=cut 

sub delete() {
	my $self = shift;
    my $rs = $self->schema->resultset('WpFact')->search({
		order_code => $self->order_code,
		test_code => $self->test_code,
		laboratory_code => $self->laboratory_code,
		cluster_name => $self->cluster_name,
		year_of_birth => $self->year_of_birth,
		year_of_result => $self->year_of_result,
		gender => $self->gender,
    });
    if (!$rs) {
		print $self->order_code, ": ", 
		    $self->laboratory_code, " not found: nothing to delete\n";
		return 0;
    } else {
		$rs->delete;
    }

}


1;
