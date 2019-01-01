use utf8;
package Catalogue::Schema::Result::CAppDb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::CAppDb

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

=head1 TABLE: C<c_app_db>

=cut

__PACKAGE__->table("c_app_db");

=head1 ACCESSORS

=head2 db_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 app_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "db_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "app_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</db_id>

=item * L</app_id>

=back

=cut

__PACKAGE__->set_primary_key("db_id", "app_id");

=head1 RELATIONS

=head2 app

Type: belongs_to

Related object: L<Catalogue::Schema::Result::CApplication>

=cut

__PACKAGE__->belongs_to(
  "app",
  "Catalogue::Schema::Result::CApplication",
  { app_id => "app_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-04-25 07:52:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OLhKTyNn01jmveWMNCqDYA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
