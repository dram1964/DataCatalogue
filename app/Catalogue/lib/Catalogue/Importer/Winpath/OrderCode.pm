package Catalogue::Importer::Winpath::OrderCode;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Winpath::Laboratory

=head1 Description

Module to import Winpath Laboratory Definitions to wp_laboratory table

=head1 Synopsis

my $order = Catalogue::Importer::Winpath::OrderCode->new(
	code => 'FBC',
	type => 'G',
	description => 'Full Blood Count',
	laboratory_code => 'BA',
);

$order->update_or_add;
$order->delete;

=cut

has 'code' => ( is => 'rw', isa => 'Str', required => 1);
has 'type' => ( is => 'rw', isa => 'Str',  required => 1);
has 'description' => ( is => 'rw', isa => 'Str',  required => 1);
has 'laboratory_code' => ( is => 'rw', isa => 'Str',  required => 1);

=head1 Methods

=head2 update_or_add

updates or adds the record to the wp_laboratory table

$lab->update_or_add;

=cut 

sub update_or_add() {
	my $self = shift;
	my $order_rs = $self->schema->resultset('WpOrder')->update_or_create(
		code => $self->code,
		type => $self->type,
		description => $self->description,
		laboratory_code => $self->laboratory_code);
}

=head2 delete

deletes the record from the wp_order table

$order->delete

=cut 

sub delete() {
	my $self = shift;
    my $rs = $self->schema->resultset('WpOrder')->find({code => $self->code});
    if (!$rs) {
		print $self->code, " not found: nothing to delete\n";
		return 0;
    } else {
		$rs->delete;
    }

}


1;
