use utf8;
package Catalogue::Schema::Result::WpLaboratory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::WpLaboratory

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

=head1 TABLE: C<wp_laboratory>

=cut

__PACKAGE__->table("wp_laboratory");

=head1 ACCESSORS

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 2

=head2 discipline

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 cluster

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 specialty

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "varchar", is_nullable => 0, size => 2 },
  "discipline",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "cluster",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "specialty",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);

=head1 PRIMARY KEY

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->set_primary_key("code");

=head1 RELATIONS

=head2 wp_facts

Type: has_many

Related object: L<Catalogue::Schema::Result::WpFact>

=cut

__PACKAGE__->has_many(
  "wp_facts",
  "Catalogue::Schema::Result::WpFact",
  { "foreign.laboratory_code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 wp_orders

Type: has_many

Related object: L<Catalogue::Schema::Result::WpOrder>

=cut

__PACKAGE__->has_many(
  "wp_orders",
  "Catalogue::Schema::Result::WpOrder",
  { "foreign.laboratory_code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 wp_tests

Type: has_many

Related object: L<Catalogue::Schema::Result::WpTest>

=cut

__PACKAGE__->has_many(
  "wp_tests",
  "Catalogue::Schema::Result::WpTest",
  { "foreign.laboratory_code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-09-28 11:52:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fKuIHnWmtXgWYskP5h6BGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
