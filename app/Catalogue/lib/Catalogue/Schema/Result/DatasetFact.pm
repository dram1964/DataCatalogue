use utf8;
package Catalogue::Schema::Result::DatasetFact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::DatasetFact

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

=head1 TABLE: C<dataset_facts>

=cut

__PACKAGE__->table("dataset_facts");

=head1 ACCESSORS

=head2 dataset_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 fact_type

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 fact

  data_type: 'json'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "dataset_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fact_type",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "fact",
  { data_type => "json", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</dataset_id>

=item * L</fact_type>

=back

=cut

__PACKAGE__->set_primary_key("dataset_id", "fact_type");

=head1 RELATIONS

=head2 dataset

Type: belongs_to

Related object: L<Catalogue::Schema::Result::Dataset>

=cut

__PACKAGE__->belongs_to(
  "dataset",
  "Catalogue::Schema::Result::Dataset",
  { id => "dataset_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-29 16:29:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xUV8aORpONVfvpXQrYBadw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
