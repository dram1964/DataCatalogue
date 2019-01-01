use utf8;
package Catalogue::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-02-03 19:24:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UO929esFyTOjCI6t1L4jgA


=head1 NAME

Catalogue::Schema

=head1 Description

Schema Class

=cut



__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
