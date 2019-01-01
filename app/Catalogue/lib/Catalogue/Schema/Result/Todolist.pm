use utf8;
package Catalogue::Schema::Result::Todolist;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catalogue::Schema::Result::Todolist

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

=head1 TABLE: C<todolist>

=cut

__PACKAGE__->table("todolist");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 date_added

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 task

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 project

  data_type: 'varchar'
  default_value: 'Catalogue'
  is_nullable: 0
  size: 50

=head2 assigned_by

  data_type: 'varchar'
  default_value: 'anon'
  is_nullable: 0
  size: 50

=head2 assigned_to

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 completed_by

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 completed_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "date_added",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "task",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "project",
  {
    data_type => "varchar",
    default_value => "Catalogue",
    is_nullable => 0,
    size => 50,
  },
  "assigned_by",
  {
    data_type => "varchar",
    default_value => "anon",
    is_nullable => 0,
    size => 50,
  },
  "assigned_to",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "completed_by",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "completed_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-29 16:29:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qMZaE3ZquXWXo7/NMLCadw

=head2 delete_allowed_by

Can the specified user delete the current Task?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('admin');
}

=head2 edit_allowed_by

Can the specified user edit the current Task?

=cut

sub edit_allowed_by {
  my ($self, $user) = @_;
  return $user->has_role('curator') || $user->has_role('admin');
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
