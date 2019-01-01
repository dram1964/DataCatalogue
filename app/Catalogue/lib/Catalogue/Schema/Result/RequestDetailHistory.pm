use utf8;
package Catalogue::Schema::Result::RequestDetailHistory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::RequestDetailHistory

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

=head1 TABLE: C<request_detail_history>

=cut

__PACKAGE__->table("request_detail_history");

=head1 ACCESSORS

=head2 data_request_id

  data_type: 'integer'
  is_nullable: 0

=head2 data_category_id

  data_type: 'integer'
  is_nullable: 0

=head2 status_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 detail

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "data_request_id",
  { data_type => "integer", is_nullable => 0 },
  "data_category_id",
  { data_type => "integer", is_nullable => 0 },
  "status_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "detail",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</data_request_id>

=item * L</data_category_id>

=item * L</status_date>

=back

=cut

__PACKAGE__->set_primary_key("data_request_id", "data_category_id", "status_date");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-08-04 18:54:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zKHVCj9Aug4i1mHIaqROqw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
