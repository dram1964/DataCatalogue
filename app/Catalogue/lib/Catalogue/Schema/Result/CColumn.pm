use utf8;
package Catalogue::Schema::Result::CColumn;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::CColumn

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

=head1 TABLE: C<c_column>

=cut

__PACKAGE__->table("c_column");

=head1 ACCESSORS

=head2 col_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 col_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 col_size

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 col_enum

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 col_pattern

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 completion_rate

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 first_record_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 last_record_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 tbl_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "col_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "col_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "col_size",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "col_enum",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "col_pattern",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "completion_rate",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "first_record_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "last_record_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "tbl_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</col_id>

=back

=cut

__PACKAGE__->set_primary_key("col_id");

=head1 RELATIONS

=head2 tbl

Type: belongs_to

Related object: L<Catalogue::Schema::Result::CTable>

=cut

__PACKAGE__->belongs_to(
  "tbl",
  "Catalogue::Schema::Result::CTable",
  { tbl_id => "tbl_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-27 22:04:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pIAh//wmOZi191ZPWE+/lQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 delete_allowed_by

Can the specified user delete the current Column?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('admin');
}

=head2 edit_allowed_by

Can the specified user edit the current Column?

=cut

sub edit_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator');
}

=head2 list_allowed_by

Can the specified user list Columns?

=cut

sub list_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator') || $user->has_role('admin');
}

__PACKAGE__->meta->make_immutable;

1;
