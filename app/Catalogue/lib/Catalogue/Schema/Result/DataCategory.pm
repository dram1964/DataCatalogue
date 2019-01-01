use utf8;
package Catalogue::Schema::Result::DataCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::DataCategory

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

=head1 TABLE: C<data_category>

=cut

__PACKAGE__->table("data_category");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 category

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "category",
  { data_type => "varchar", is_nullable => 0, size => 30 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 data_request_details

Type: has_many

Related object: L<Catalogue::Schema::Result::DataRequestDetail>

=cut

__PACKAGE__->has_many(
  "data_request_details",
  "Catalogue::Schema::Result::DataRequestDetail",
  { "foreign.data_category_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-08-01 22:00:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yzSSnAtnSlfKkFvP94QDpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub friendly_category {
     my ($self) = @_;
     my $friendly_key = $self->category;
     $friendly_key =~ s/^([a-z])/\u$1/; 
     return $friendly_key;
}

__PACKAGE__->meta->make_immutable;
1;
