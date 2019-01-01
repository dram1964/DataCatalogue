use utf8;
package Catalogue::Schema::Result::CApplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::CApplication

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

=head1 TABLE: C<c_application>

=cut

__PACKAGE__->table("c_application");

=head1 ACCESSORS

=head2 app_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 erid_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 kpe_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 supplier_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 cat2_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "app_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "erid_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "kpe_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "supplier_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "cat2_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_id>

=back

=cut

__PACKAGE__->set_primary_key("app_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<application_name_uni>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("application_name_uni", ["name"]);

=head1 RELATIONS

=head2 cat2

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Cat2>

=cut

__PACKAGE__->belongs_to(
  "cat2",
  "Catalogue::Schema::Result::Cat2",
  { cat2_id => "cat2_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 erid

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Erid>

=cut

__PACKAGE__->belongs_to(
  "erid",
  "Catalogue::Schema::Result::Erid",
  { erid_id => "erid_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 kpe

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Kpe>

=cut

__PACKAGE__->belongs_to(
  "kpe",
  "Catalogue::Schema::Result::Kpe",
  { kpe_id => "kpe_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 supplier

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Supplier>

=cut

__PACKAGE__->belongs_to(
  "supplier",
  "Catalogue::Schema::Result::Supplier",
  { supplier_id => "supplier_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-26 19:58:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lUwReKPwQK+rPPJzyFsCLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 delete_allowed_by

Can the specified user delete the current Application?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('admin');
}

=head2 edit_allowed_by

Can the specified user edit the current Application?

=cut

sub edit_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator');
}

=head2 list_allowed_by

Can the specified user list Applications?

=cut

sub list_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator') || $user->has_role('admin');
}

__PACKAGE__->meta->make_immutable;

1;
