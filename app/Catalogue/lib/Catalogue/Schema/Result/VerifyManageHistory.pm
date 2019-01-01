use utf8;
package Catalogue::Schema::Result::VerifyManageHistory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::VerifyManageHistory

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

=head1 TABLE: C<verify_manage_history>

=cut

__PACKAGE__->table("verify_manage_history");

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

=head2 storing_comment

  data_type: 'text'
  is_nullable: 1

=head2 completion_comment

  data_type: 'text'
  is_nullable: 1

=head2 secure_comment

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
  "storing_comment",
  { data_type => "text", is_nullable => 1 },
  "completion_comment",
  { data_type => "text", is_nullable => 1 },
  "secure_comment",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_id>

=item * L</verification_time>

=back

=cut

__PACKAGE__->set_primary_key("request_id", "verification_time");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-11-15 13:32:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:K/7LsPf4rMDhep2HoMW37g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
