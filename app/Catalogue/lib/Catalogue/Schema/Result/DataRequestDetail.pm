use utf8;
package Catalogue::Schema::Result::DataRequestDetail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::DataRequestDetail

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

=head1 TABLE: C<data_request_detail>

=cut

__PACKAGE__->table("data_request_detail");

=head1 ACCESSORS

=head2 data_request_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 data_category_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 detail

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "data_request_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "data_category_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "detail",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</data_request_id>

=item * L</data_category_id>

=back

=cut

__PACKAGE__->set_primary_key("data_request_id", "data_category_id");

=head1 RELATIONS

=head2 data_category

Type: belongs_to

Related object: L<Catalogue::Schema::Result::DataCategory>

=cut

__PACKAGE__->belongs_to(
  "data_category",
  "Catalogue::Schema::Result::DataCategory",
  { id => "data_category_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 data_request

Type: belongs_to

Related object: L<Catalogue::Schema::Result::DataRequest>

=cut

__PACKAGE__->belongs_to(
  "data_request",
  "Catalogue::Schema::Result::DataRequest",
  { id => "data_request_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-08-01 22:00:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+7vpFVvmxpKbmk3aEcCc8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
