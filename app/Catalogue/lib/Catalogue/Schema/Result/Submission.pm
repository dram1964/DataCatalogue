use utf8;
package Catalogue::Schema::Result::Submission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::Submission

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

=head1 TABLE: C<submission>

=cut

__PACKAGE__->table("submission");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 request_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 project_type

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 project_name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 project_location

  data_type: 'text'
  is_nullable: 1

=head2 extract_run_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 extract_output_file

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 extract_output_file_location

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 extract_delivery_method

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "request_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "project_type",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "project_name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "project_location",
  { data_type => "text", is_nullable => 1 },
  "extract_run_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "extract_output_file",
  { data_type => "varchar", is_nullable => 1, size => 250 },
  "extract_output_file_location",
  { data_type => "varchar", is_nullable => 1, size => 250 },
  "extract_delivery_method",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</request_id>

=back

=cut

__PACKAGE__->set_primary_key("id", "request_id");

=head1 RELATIONS

=head2 packages

Type: has_many

Related object: L<Catalogue::Schema::Result::Package>

=cut

__PACKAGE__->has_many(
  "packages",
  "Catalogue::Schema::Result::Package",
  { "foreign.submission_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 request

Type: belongs_to

Related object: L<Catalogue::Schema::Result::DataRequest>

=cut

__PACKAGE__->belongs_to(
  "request",
  "Catalogue::Schema::Result::DataRequest",
  { id => "request_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-02-16 10:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4jst/ZQklRwChOUpqb3G6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
