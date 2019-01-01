use utf8;
package Catalogue::Schema::Result::WpOrder;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::WpOrder

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

=head1 TABLE: C<wp_order>

=cut

__PACKAGE__->table("wp_order");

=head1 ACCESSORS

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 4

=head2 type

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 laboratory_code

  data_type: 'varchar'
  default_value: 'U'
  is_foreign_key: 1
  is_nullable: 0
  size: 2

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "varchar", is_nullable => 0, size => 4 },
  "type",
  { data_type => "char", is_nullable => 1, size => 1 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "laboratory_code",
  {
    data_type => "varchar",
    default_value => "U",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 2,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->set_primary_key("code");

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

=head2 wp_facts

Type: has_many

Related object: L<Catalogue::Schema::Result::WpFact>

=cut

__PACKAGE__->has_many(
  "wp_facts",
  "Catalogue::Schema::Result::WpFact",
  { "foreign.order_code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-09-28 11:52:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pV2WqGIOWZmd70UfP2LK2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
