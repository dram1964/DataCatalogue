package Catalogue::Importer::Application;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Application

=head1 Description

Utilities for importing data into the Application table of the Catalogue System

=head1 Synopsis

use Catalogue::Importer::Application;

my $app1 = Catalogue::Systems::Importer->new(
	kpe => 'CDR',
	erid => 'Core',
	category2 => 'Core Clinical',
	supplier => 'CGI',
	application => 'CDR Web',
	application_desc => 'ablaskj'
);

ok($app1->add_or_update_application, "Can insert System Application");
ok($app1->delete_application, "Can delete added application");

=cut

has 'kpe' => ( is => 'rw', required => 1, default => '');
has 'erid' => ( is => 'rw', required => 1, default => ''); 
has 'category2' =>  ( is => 'rw', required => 1, default => '');
has 'supplier' =>  ( is => 'rw', required => 1, default => '');
has 'application' => ( is => 'rw', required => 1);
has 'application_desc' =>  ( is => 'rw', required => 1, default => '');

=head1 METHODS

=head2 add_or_update_application

updates or adds the Application and child records

=cut

sub add_or_update_application () {
    my ($self) = @_;
    my $category2_rs; my $erid_rs; my $supplier_rs; my $kpe_rs;
    my $category2_id; my $erid_id; my $supplier_id; my $kpe_id;
    if ($self->category2) {
	$category2_rs = $self->schema->resultset('Cat2')->find_or_create({name => $self->category2});
	$category2_id = $category2_rs->id;
    }
    if ($self->erid) {
	$erid_rs = $self->schema->resultset('Erid')->find_or_create({name => $self->erid});
	$erid_id = $erid_rs->id;
    }
    if ($self->supplier) {
	$supplier_rs = $self->schema->resultset('Supplier')->find_or_create({name => $self->supplier});
	$supplier_id = $supplier_rs->id;
    }
    if ($self->kpe) {
 	$kpe_rs = $self->schema->resultset('Kpe')->find_or_create({name => $self->kpe});
	$kpe_id = $kpe_rs->id;
    }
    my $rs = $self->schema->resultset('CApplication')->find({name => $self->application});
    if (!$rs) {
	$rs = $self->schema->resultset('CApplication')->create({
		name => $self->application,
		description => $self->application_desc,
		cat2_id => $category2_id,
		erid_id => $erid_id,
		supplier_id => $supplier_id,
		kpe_id => $kpe_id,
	});
    } else {
    $rs->update({
		cat2_id => $category2_id,
		erid_id => $erid_id,
		supplier_id => $supplier_id,
		kpe_id => $kpe_id,
	});
    }
}

=head2 delete_application

Deletes application based on the application name

=cut

sub delete_application {
    my ($self) = @_;
    my $rs = $self->schema->resultset('CApplication')->find({name => $self->application});
    if (!$rs) {
		print $self->application, " not found: nothing to delete\n";
    } else {
		$rs->delete;
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;


1;
