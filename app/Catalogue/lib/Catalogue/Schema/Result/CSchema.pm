use utf8;
package Catalogue::Schema::Result::CSchema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::CSchema

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

=head1 TABLE: C<c_schema>

=cut

__PACKAGE__->table("c_schema");

=head1 ACCESSORS

=head2 sch_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 db_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sch_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "db_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sch_id>

=back

=cut

__PACKAGE__->set_primary_key("sch_id");

=head1 RELATIONS

=head2 c_tables

Type: has_many

Related object: L<Catalogue::Schema::Result::CTable>

=cut

__PACKAGE__->has_many(
  "c_tables",
  "Catalogue::Schema::Result::CTable",
  { "foreign.sch_id" => "self.sch_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 db

Type: belongs_to

Related object: L<Catalogue::Schema::Result::CDatabase>

=cut

__PACKAGE__->belongs_to(
  "db",
  "Catalogue::Schema::Result::CDatabase",
  { db_id => "db_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-27 22:04:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nhHvjAzcyd23Z5yBPRlmWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 delete_allowed_by

Can the specified user delete the current Schema?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('admin');
}

=head2 edit_allowed_by

Can the specified user edit the current Schema?

=cut

sub edit_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator');
}

=head2 list_allowed_by

Can the specified user list Schemas?

=cut

sub list_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator') || $user->has_role('admin');
}

__PACKAGE__->meta->make_immutable;

1;
