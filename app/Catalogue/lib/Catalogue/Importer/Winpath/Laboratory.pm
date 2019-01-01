package Catalogue::Importer::Winpath::Laboratory;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Winpath::Laboratory

=head1 Description

Module to import Winpath Laboratory Definitions to wp_laboratory table

=head1 Synopsis

my $lab = Catalogue::Importer::Winpath::Laboratory->new(
	code => 'BZ',
	discipline => 'Special Biochemistry',
	cluster => 'Biochemistry',
	specialty => 'Biochemistry',
);
$lab->update_or_add;
$lab->delete;

=cut

has 'code' => ( is => 'rw', isa => 'Str', required => 1);
has 'discipline' => ( is => 'rw', isa => 'Str',  required => 1);
has 'cluster' => ( is => 'rw', isa => 'Str',  required => 1);
has 'specialty' => ( is => 'rw', isa => 'Str',  required => 1);

=head1 Methods

=head2 update_or_add

updates or adds the record to the wp_laboratory table

$lab->update_or_add;

=cut 

sub update_or_add() {
	my $self = shift;
	my $lab_rs = $self->schema->resultset('WpLaboratory')->update_or_create(
		code => $self->code,
		discipline => $self->discipline,
		cluster => $self->cluster,
		specialty => $self->specialty);
}

=head2 delete

deletes the record from the wp_laboratory table

$lab->delete

=cut 

sub delete() {
	my $self = shift;
    my $rs = $self->schema->resultset('WpLaboratory')->find({code => $self->code});
    if (!$rs) {
		print $self->code, " not found: nothing to delete\n";
		return 0;
    } else {
		$rs->delete;
    }

}


1;
