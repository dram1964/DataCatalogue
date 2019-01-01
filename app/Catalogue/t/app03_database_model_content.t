#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst "Catalogue";
use Catalogue::Schema;

TODO: {
    local $TODO = "add tests for application and datasets list pages";
}

my $dsn = "dbi:mysql:catalogue_test";
my $connection
    = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );
my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok( "/login?username=test04&password=mypass", "Login test04" );

my $db_rs   = $connection->resultset('CDatabase');
my $db      = $db_rs->next;
my $schemas = [ $db->c_schemas ];
$mech->get_ok("/databases/list");
$mech->content_contains( $db->name, "Database list contains " . $db->name );
$mech->get_ok( "/schemas/list/" . $db->db_id,
    "Select schemas for db_id = " . $db->db_id );
for ( my $i = 0; $i < 10 && defined( $schemas->[$i] ); $i++ ) {
    $mech->content_contains( $schemas->[$i]->name,
              "Database "
            . $db->name . ": "
            . $schemas->[$i]->name
            . " schema name found" );
}

my $schema_rs = $connection->resultset('CSchema');
my $schema    = $schema_rs->next;
my $tables    = [ $schema->c_tables ];
$mech->get_ok(
    "/tables/list_tables/" . $schema->sch_id,
    "Select tables for schema_id = " . $schema->sch_id
);
for ( my $i = 0; $i < 10 && defined( $tables->[$i] ); $i++ ) {
    $mech->content_contains( $tables->[$i]->name,
              "Schema "
            . $schema->name . ": "
            . $tables->[$i]->name
            . " table name found" );
}

my $table_rs = $connection->resultset('CTable');
my $table    = $table_rs->next;
my $columns  = [ $table->c_columns ];
$mech->get_ok(
    "/columns/list_columns/" . $table->tbl_id,
    "Select columns for table_id = " . $table->tbl_id
);

#for my $table_column (@$columns[0..10]) {
for ( my $i = 0; $i < 10 && defined( $columns->[$i] ); $i++ ) {
    $mech->content_contains( $columns->[$i]->name,
              "Table "
            . $table->name . ": "
            . $columns->[$i]->name
            . " column name found" );
}

done_testing;
