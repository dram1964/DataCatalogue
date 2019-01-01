use utf8;
package Catalogue::Schema::Result::DataRequest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::DataRequest

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

=head1 TABLE: C<data_request>

=cut

__PACKAGE__->table("data_request");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 request_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 status_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 status_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "request_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 data_handlings

Type: has_many

Related object: L<Catalogue::Schema::Result::DataHandling>

=cut

__PACKAGE__->has_many(
  "data_handlings",
  "Catalogue::Schema::Result::DataHandling",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 data_request_details

Type: has_many

Related object: L<Catalogue::Schema::Result::DataRequestDetail>

=cut

__PACKAGE__->has_many(
  "data_request_details",
  "Catalogue::Schema::Result::DataRequestDetail",
  { "foreign.data_request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 request_type

Type: belongs_to

Related object: L<Catalogue::Schema::Result::RequestType>

=cut

__PACKAGE__->belongs_to(
  "request_type",
  "Catalogue::Schema::Result::RequestType",
  { id => "request_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 risk_scores

Type: has_many

Related object: L<Catalogue::Schema::Result::RiskScore>

=cut

__PACKAGE__->has_many(
  "risk_scores",
  "Catalogue::Schema::Result::RiskScore",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 status

Type: belongs_to

Related object: L<Catalogue::Schema::Result::RequestStatus>

=cut

__PACKAGE__->belongs_to(
  "status",
  "Catalogue::Schema::Result::RequestStatus",
  { id => "status_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 submissions

Type: has_many

Related object: L<Catalogue::Schema::Result::Submission>

=cut

__PACKAGE__->has_many(
  "submissions",
  "Catalogue::Schema::Result::Submission",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<Catalogue::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Catalogue::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 verify_data

Type: might_have

Related object: L<Catalogue::Schema::Result::VerifyData>

=cut

__PACKAGE__->might_have(
  "verify_data",
  "Catalogue::Schema::Result::VerifyData",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 verify_handling

Type: might_have

Related object: L<Catalogue::Schema::Result::VerifyHandling>

=cut

__PACKAGE__->might_have(
  "verify_handling",
  "Catalogue::Schema::Result::VerifyHandling",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 verify_manage

Type: might_have

Related object: L<Catalogue::Schema::Result::VerifyManage>

=cut

__PACKAGE__->might_have(
  "verify_manage",
  "Catalogue::Schema::Result::VerifyManage",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 verify_purpose

Type: might_have

Related object: L<Catalogue::Schema::Result::VerifyPurpose>

=cut

__PACKAGE__->might_have(
  "verify_purpose",
  "Catalogue::Schema::Result::VerifyPurpose",
  { "foreign.request_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-02-16 10:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q14/1fJgB7zqbCr6nTtcdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 submitted_dates

Type: might_have

Related object: L<Catalogue::Schema::Result::RequestHistory>

=cut

__PACKAGE__->might_have(
  "submitted_dates",
  "Catalogue::Schema::Result::RequestHistory",
  { "foreign.request_id" => "self.id"},
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 last_submit_date

Returns the last date from the request history where the submit type was 3 (submitted)

=cut

sub last_submit_date {
  my ($self) = @_;
  my $submit_rs = [$self->search_related('submitted_dates', {status_id => [3, 7]})];
  return defined($submit_rs->[-1]) ? $submit_rs->[-1]->status_date : undef;
}

=head2 first_submit_date

Returns the last date from the request history where the submit type was 3 (submitted)

=cut

sub first_submit_date {
  my ($self) = @_;
  my $submit_rs = [$self->search_related('submitted_dates', {status_id => 3})];
  return defined($submit_rs->[0]) ? $submit_rs->[0]->status_date : undef;
}

=head2 delete_allowed_by

Can the specified user delete the current Data Request?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('admin');
}

=head2 edit_allowed_by

Can the specified user edit the current Data Request?

=cut

sub edit_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('ig_admin') || $user->has_role('verifier');
}

=head2 request_allowed_by

Can the specified user make a Data Request?

=cut

sub request_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('requestor');
}

=head2 extract_allowed_by

Can the specified user record extract data for a Data Request?

=cut

sub extract_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('extractor');
}

__PACKAGE__->meta->make_immutable;

1;
