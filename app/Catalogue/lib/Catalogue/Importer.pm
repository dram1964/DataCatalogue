package Catalogue::Importer;
use Moose;

use Catalogue::Schema;

=head1 NAME

Catalogue::Importer - base class for Catalogue Importer routines 

=head1 SYNOPSIS

Provides a schema connnection for use by child classes

=head1 METHODS

=head2 schema

Sets up a connection to the Catalogue database

=cut

has 'schema' => (
	is => 'ro',
	required => 1,
	lazy_build => 1,
);

sub _build_schema {
	return Catalogue::Schema->connect(
		'dbi:mysql:catalogue_test', 'tutorial', 'thispassword');
}

no Moose;

__PACKAGE__->meta->make_immutable;


1;
