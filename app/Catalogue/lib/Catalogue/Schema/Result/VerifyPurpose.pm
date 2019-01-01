use utf8;
package Catalogue::Schema::Result::VerifyPurpose;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::VerifyPurpose

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

=head1 TABLE: C<verify_purpose>

=cut

__PACKAGE__->table("verify_purpose");

=head1 ACCESSORS

=head2 request_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 verifier

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 verification_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 area

  data_type: 'text'
  is_nullable: 1

=head2 area_comment

  data_type: 'text'
  is_nullable: 1

=head2 objective

  data_type: 'text'
  is_nullable: 1

=head2 objective_comment

  data_type: 'text'
  is_nullable: 1

=head2 benefits

  data_type: 'text'
  is_nullable: 1

=head2 benefits_comment

  data_type: 'text'
  is_nullable: 1

=head2 responsible

  data_type: 'text'
  is_nullable: 1

=head2 responsible_comment

  data_type: 'text'
  is_nullable: 1

=head2 organisation

  data_type: 'text'
  is_nullable: 1

=head2 organisation_comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "request_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "verifier",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "verification_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "area",
  { data_type => "text", is_nullable => 1 },
  "area_comment",
  { data_type => "text", is_nullable => 1 },
  "objective",
  { data_type => "text", is_nullable => 1 },
  "objective_comment",
  { data_type => "text", is_nullable => 1 },
  "benefits",
  { data_type => "text", is_nullable => 1 },
  "benefits_comment",
  { data_type => "text", is_nullable => 1 },
  "responsible",
  { data_type => "text", is_nullable => 1 },
  "responsible_comment",
  { data_type => "text", is_nullable => 1 },
  "organisation",
  { data_type => "text", is_nullable => 1 },
  "organisation_comment",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_id>

=back

=cut

__PACKAGE__->set_primary_key("request_id");

=head1 RELATIONS

=head2 request

Type: belongs_to

Related object: L<Catalogue::Schema::Result::DataRequest>

=cut

__PACKAGE__->belongs_to(
  "request",
  "Catalogue::Schema::Result::DataRequest",
  { id => "request_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 verifier

Type: belongs_to

Related object: L<Catalogue::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "verifier",
  "Catalogue::Schema::Result::User",
  { id => "verifier" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-11-10 12:15:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4wazQm1VN6DRjbE8Qz8vNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
