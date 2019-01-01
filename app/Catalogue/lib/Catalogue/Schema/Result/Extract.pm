use utf8;
package Catalogue::Schema::Result::Extract;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::Extract

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

=head1 TABLE: C<extract>

=cut

__PACKAGE__->table("extract");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 package_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 source_name

  accessor: 'column_source_name'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 source_type

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 extract_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 extract_query

  data_type: 'text'
  is_nullable: 1

=head2 output_type

  data_type: 'text'
  is_nullable: 1

=head2 filename

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "package_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "source_name",
  {
    accessor => "column_source_name",
    data_type => "varchar",
    is_nullable => 0,
    size => 50,
  },
  "source_type",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "extract_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "extract_query",
  { data_type => "text", is_nullable => 1 },
  "output_type",
  { data_type => "text", is_nullable => 1 },
  "filename",
  { data_type => "varchar", is_nullable => 1, size => 250 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</package_id>

=back

=cut

__PACKAGE__->set_primary_key("id", "package_id");

=head1 RELATIONS

=head2 package

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Package>

=cut

__PACKAGE__->belongs_to(
  "package",
  "Catalogue::Schema::Result::Package",
  { id => "package_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-02-16 10:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9raZPXk+ATUPg6+4A/wknw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
