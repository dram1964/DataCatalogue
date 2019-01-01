use utf8;
package Catalogue::Schema::Result::WpFact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::WpFact

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<wp_fact>

=cut

__PACKAGE__->table("wp_fact");

=head1 ACCESSORS

=head2 order_code

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 4

=head2 test_code

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 4

=head2 laboratory_code

  data_type: 'varchar'
  default_value: 'U'
  is_foreign_key: 1
  is_nullable: 0
  size: 2

=head2 cluster_name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 year_of_birth

  data_type: 'integer'
  is_nullable: 0

=head2 year_of_result

  data_type: 'integer'
  is_nullable: 0

=head2 gender

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 requests

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "order_code",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 4 },
  "test_code",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 4 },
  "laboratory_code",
  {
    data_type => "varchar",
    default_value => "U",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 2,
  },
  "cluster_name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "year_of_birth",
  { data_type => "integer", is_nullable => 0 },
  "year_of_result",
  { data_type => "integer", is_nullable => 0 },
  "gender",
  { data_type => "char", is_nullable => 0, size => 1 },
  "requests",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</order_code>

=item * L</test_code>

=item * L</laboratory_code>

=item * L</cluster_name>

=item * L</year_of_birth>

=item * L</year_of_result>

=item * L</gender>

=back

=cut

__PACKAGE__->set_primary_key(
  "order_code",
  "test_code",
  "laboratory_code",
  "cluster_name",
  "year_of_birth",
  "year_of_result",
  "gender",
);

=head1 RELATIONS

=head2 laboratory_code

Type: belongs_to

Related object: L<Catalogue::Schema::Result::WpLaboratory>

=cut

__PACKAGE__->belongs_to(
  "laboratory_code",
  "Catalogue::Schema::Result::WpLaboratory",
  { code => "laboratory_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 order_code

Type: belongs_to

Related object: L<Catalogue::Schema::Result::WpOrder>

=cut

__PACKAGE__->belongs_to(
  "order_code",
  "Catalogue::Schema::Result::WpOrder",
  { code => "order_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 test_code

Type: belongs_to

Related object: L<Catalogue::Schema::Result::WpTest>

=cut

__PACKAGE__->belongs_to(
  "test_code",
  "Catalogue::Schema::Result::WpTest",
  { code => "test_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-09-28 11:52:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SXnvVV+b0h8t0UvZ/q32cw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
