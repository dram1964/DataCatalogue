use utf8;
package Catalogue::Schema::Result::DataHandling;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::DataHandling

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

=head1 TABLE: C<data_handling>

=cut

__PACKAGE__->table("data_handling");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 request_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 identifiable

  data_type: 'integer'
  is_nullable: 1

=head2 identifiers

  data_type: 'text'
  is_nullable: 1

=head2 pid_justify

  data_type: 'text'
  is_nullable: 1

=head2 legal_basis_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 publish

  data_type: 'integer'
  is_nullable: 1

=head2 publish_to

  data_type: 'text'
  is_nullable: 1

=head2 storing

  data_type: 'text'
  is_nullable: 1

=head2 completion

  data_type: 'text'
  is_nullable: 1

=head2 completion_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 objective

  data_type: 'text'
  is_nullable: 1

=head2 area

  data_type: 'text'
  is_nullable: 1

=head2 population

  data_type: 'text'
  is_nullable: 1

=head2 rec_approval

  data_type: 'integer'
  is_nullable: 1

=head2 disclosure

  data_type: 'integer'
  is_nullable: 1

=head2 disclosure_to

  data_type: 'text'
  is_nullable: 1

=head2 disclosure_contract

  data_type: 'text'
  is_nullable: 1

=head2 benefits

  data_type: 'text'
  is_nullable: 1

=head2 rec_approval_number

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 responsible

  data_type: 'text'
  is_nullable: 1

=head2 organisation

  data_type: 'text'
  is_nullable: 1

=head2 secure

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "request_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "identifiable",
  { data_type => "integer", is_nullable => 1 },
  "identifiers",
  { data_type => "text", is_nullable => 1 },
  "pid_justify",
  { data_type => "text", is_nullable => 1 },
  "legal_basis_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "publish",
  { data_type => "integer", is_nullable => 1 },
  "publish_to",
  { data_type => "text", is_nullable => 1 },
  "storing",
  { data_type => "text", is_nullable => 1 },
  "completion",
  { data_type => "text", is_nullable => 1 },
  "completion_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "objective",
  { data_type => "text", is_nullable => 1 },
  "area",
  { data_type => "text", is_nullable => 1 },
  "population",
  { data_type => "text", is_nullable => 1 },
  "rec_approval",
  { data_type => "integer", is_nullable => 1 },
  "disclosure",
  { data_type => "integer", is_nullable => 1 },
  "disclosure_to",
  { data_type => "text", is_nullable => 1 },
  "disclosure_contract",
  { data_type => "text", is_nullable => 1 },
  "benefits",
  { data_type => "text", is_nullable => 1 },
  "rec_approval_number",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "responsible",
  { data_type => "text", is_nullable => 1 },
  "organisation",
  { data_type => "text", is_nullable => 1 },
  "secure",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 legal_basis

Type: belongs_to

Related object: L<Catalogue::Schema::Result::LegalBasis>

=cut

__PACKAGE__->belongs_to(
  "legal_basis",
  "Catalogue::Schema::Result::LegalBasis",
  { id => "legal_basis_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-11-15 09:51:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Sgfi/4cdTsXK86YQcOy/Ug


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 friendly_identifiers

Returns an arrayref of descriptive names for the comma-separated list of values in identifiers field

=cut

sub friendly_identifiers {
   my ($self, $resultset) = @_;
   my $identifiers = [split /, /, $self->identifiers];
   my $friendly_identifiers;
   for my $identifier (@{$identifiers}) {
	my $friendly_identifier_rs =  $resultset->search({value => $identifier});
	if ($friendly_identifier_rs->first) {
		my $friendly_identifier = $friendly_identifier_rs->first->description;
		push @{$friendly_identifiers}, $friendly_identifier ;
        }
   }
  return $friendly_identifiers;
}

__PACKAGE__->meta->make_immutable;
1;
