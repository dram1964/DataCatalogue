use utf8;
package Catalogue::Schema::Result::Package;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::Package

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

=head1 TABLE: C<package>

=cut

__PACKAGE__->table("package");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 submission_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 package_name

  data_type: 'varchar'
  is_nullable: 0
  size: 250

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "submission_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "package_name",
  { data_type => "varchar", is_nullable => 0, size => 250 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</submission_id>

=back

=cut

__PACKAGE__->set_primary_key("id", "submission_id");

=head1 RELATIONS

=head2 extracts

Type: has_many

Related object: L<Catalogue::Schema::Result::Extract>

=cut

__PACKAGE__->has_many(
  "extracts",
  "Catalogue::Schema::Result::Extract",
  { "foreign.package_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 submission

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "Catalogue::Schema::Result::Submission",
  { id => "submission_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-02-16 10:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2IQHATbjSF4DosVj7jjFsg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
