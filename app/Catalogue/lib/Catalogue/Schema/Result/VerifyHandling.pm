use utf8;
package Catalogue::Schema::Result::VerifyHandling;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::VerifyHandling

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

=head1 TABLE: C<verify_handling>

=cut

__PACKAGE__->table("verify_handling");

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

=head2 id_comment

  data_type: 'text'
  is_nullable: 1

=head2 rec_comment

  data_type: 'text'
  is_nullable: 1

=head2 population_comment

  data_type: 'text'
  is_nullable: 1

=head2 publish_comment

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
  "id_comment",
  { data_type => "text", is_nullable => 1 },
  "rec_comment",
  { data_type => "text", is_nullable => 1 },
  "population_comment",
  { data_type => "text", is_nullable => 1 },
  "publish_comment",
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-11-15 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cp5eAu6Yzw/EQDE0+6XK2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
