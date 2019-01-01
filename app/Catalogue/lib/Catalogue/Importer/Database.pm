package Catalogue::Importer::Database;
use Moose;

extends 'Catalogue::Importer';

=head1 NAME

Catalogue::Importer::Database

=head1 Description

Utilities for importing data into the Database table of the Catalogue System

=head1 Synopsis

use Catalogue::Importer::Database

my $db_record = {
	server_name => 'TestServer',
	database_name => 'DBName',
	database_description => 'DB Description',
	schema_name => 'SchemaName',
	schema_description => 'Schema Description',
	table_name => 'TableName',
	table_description => 'Table Description',
	column_name => 'Column1',
	column_type => 'integer',
	column_size => '11',
}
my $record = Catalogue::Systems::Importer->new($db);
$record->add_or_update_database;
$record->delete_db;
$record->delete_srv;

=cut

has 'server_name' => ( is => 'rw', required => 1);
has 'database_name' => ( is => 'rw', required => 1);
has 'database_description' => ( is => 'rw', required => 1, default => '');
has 'schema_name' => ( is => 'rw', required => 1);
has 'schema_description' => ( is => 'rw', required => 1, default => '');
has 'table_name' => ( is => 'rw', required => 1);
has 'table_description' => ( is => 'rw', required => 1, default => '');
has 'column_name' => ( is => 'rw', required => 1);
has 'column_type' => ( is => 'rw', required => 1, default => '');
has 'column_size' => ( is => 'rw', required => 1, default => '');

=head1 METHODS

=head2 add_or_update_database

my $record = {
	server_name => 'TestServer',
	database_name => 'DBName',
	schema_name => 'SchemaName',
	table_name => 'TableName',
	column_name => 'Column1',
}

my $record = Catalogue::Systems::Importer->new($db);
$record->add_or_update_database;
Checks that the record has all the required elements, and then updates or adds the database and child/parent records

=cut


sub add_or_update_database () {
    my ($self) = @_;
    my $rs = $self->schema->resultset('CServer')->find({name => $self->server_name});
    if (!$rs) {
	$rs = $self->schema->resultset('CServer')->create({
		name => $self->server_name});
    } 
    my $db_rs = $rs->c_databases->find({name => $self->database_name,
		srv_id => $rs->srv_id});
    if (!$db_rs) {
	$db_rs = $rs->c_databases->create({
	    name => $self->database_name,
	    description => $self->database_description,
	    srv_id => $rs->srv_id});
    } else {
	my $update = $db_rs->update({
		description => $self->database_description});
    }
    my $schema_rs = $db_rs->c_schemas->find({
	name => $self->schema_name,
	db_id => $db_rs->db_id});
    if (!$schema_rs) {
	$schema_rs = $db_rs->c_schemas->create({
	    name => $self->schema_name,
	    description => $self->schema_description,
	    db_id => $db_rs->db_id});
    } else {
	my $update = $schema_rs->update( {
	    description => $self->schema_description});
    }
    my $table_rs = $schema_rs->c_tables->find({
	name => $self->table_name,
	sch_id => $schema_rs->sch_id});
    if (!$table_rs) {
	$table_rs = $schema_rs->c_tables->create({
	    name => $self->table_name,
	    description => $self->table_description,
	    sch_id => $schema_rs->sch_id});
    } else {
	my $update = $table_rs->update({
	    description => $self->table_name});
    }
    my $column_rs = $table_rs->c_columns->find({
	name => $self->column_name,
	tbl_id => $table_rs->tbl_id});
    if (!$column_rs) {
	$column_rs = $table_rs->c_columns->create({
	     name => $self->column_name,
	     col_type => $self->column_type,
	     col_size => $self->column_size,
	     tbl_id => $table_rs->tbl_id});
    } else {
	my $update = $column_rs->update({
	     col_type => $self->column_type,
	     col_size => $self->column_size});
    }
}


=head2 delete_db

Deletes Catalogue Database and all child records (Schemas, Tables and columns associated with the system

=cut

sub delete_db {
    my ($self) = @_;
    my $rs = $self->schema->resultset('CDatabase')->find({name => $self->database_name});
    if (!$rs) {
		print $self->database_name, " not found: nothing to delete\n";
    } else {
		$rs->delete;
    }
}

=head2 delete_srv

Deletes server record 

=cut

sub delete_srv {
    my ($self) = @_;
    my $rs = $self->schema->resultset('CServer')->find({name => $self->server_name});
    if (!$rs) {
		print $self->server_name, " not found: nothing to delete\n";
    } else {
		$rs->delete;
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;


1;
