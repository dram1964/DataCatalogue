use utf8;
package Catalogue::Schema::Result::RiskScore;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::RiskScore

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

=head1 TABLE: C<risk_score>

=cut

__PACKAGE__->table("risk_score");

=head1 ACCESSORS

=head2 request_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 risk_category

  data_type: 'varchar'
  is_nullable: 0
  size: 250

=head2 rating

  data_type: 'integer'
  is_nullable: 0

=head2 likelihood

  data_type: 'integer'
  is_nullable: 0

=head2 score

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "request_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "risk_category",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "rating",
  { data_type => "integer", is_nullable => 0 },
  "likelihood",
  { data_type => "integer", is_nullable => 0 },
  "score",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_id>

=item * L</risk_category>

=back

=cut

__PACKAGE__->set_primary_key("request_id", "risk_category");

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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-10-01 12:53:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:28fDGGLancqG+NyBHEc39A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
