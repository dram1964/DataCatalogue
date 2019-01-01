use utf8;
package Catalogue::Schema::Result::VerifyDataHistory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::VerifyDataHistory

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

=head1 TABLE: C<verify_data_history>

=cut

__PACKAGE__->table("verify_data_history");

=head1 ACCESSORS

=head2 request_id

  data_type: 'integer'
  is_nullable: 0

=head2 verifier

  data_type: 'integer'
  is_nullable: 0

=head2 verification_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 cardiology_comment

  data_type: 'text'
  is_nullable: 1

=head2 diagnosis_comment

  data_type: 'text'
  is_nullable: 1

=head2 episode_comment

  data_type: 'text'
  is_nullable: 1

=head2 other_comment

  data_type: 'text'
  is_nullable: 1

=head2 pathology_comment

  data_type: 'text'
  is_nullable: 1

=head2 pharmacy_comment

  data_type: 'text'
  is_nullable: 1

=head2 radiology_comment

  data_type: 'text'
  is_nullable: 1

=head2 theatre_comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "request_id",
  { data_type => "integer", is_nullable => 0 },
  "verifier",
  { data_type => "integer", is_nullable => 0 },
  "verification_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "cardiology_comment",
  { data_type => "text", is_nullable => 1 },
  "diagnosis_comment",
  { data_type => "text", is_nullable => 1 },
  "episode_comment",
  { data_type => "text", is_nullable => 1 },
  "other_comment",
  { data_type => "text", is_nullable => 1 },
  "pathology_comment",
  { data_type => "text", is_nullable => 1 },
  "pharmacy_comment",
  { data_type => "text", is_nullable => 1 },
  "radiology_comment",
  { data_type => "text", is_nullable => 1 },
  "theatre_comment",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_id>

=item * L</verification_time>

=back

=cut

__PACKAGE__->set_primary_key("request_id", "verification_time");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-09-22 13:40:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H6a8Xo/Eu9a1sd1owQFpLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
