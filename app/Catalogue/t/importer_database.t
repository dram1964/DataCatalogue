use Test::More;

BEGIN { use_ok Catalogue::Importer::Database }

my @values = qw/TestServer DB2 TestDB Schema2 SchemaDesc Table1 TableDesc
    Col1 varchar 7/;

ok( my $minimal_record = Catalogue::Importer::Database->new(
        server_name   => 'TestServer2',
        database_name => 'DBName',
        schema_name   => 'SchemaName',
        table_name    => 'TableName',
        column_name   => 'Column1'
    ),
    "New record created with required-only fields"
);

isa_ok( $minimal_record, 'Catalogue::Importer::Database' );
ok( $minimal_record->server_name( $values[0] ),
    'inherits server_name Mutator' );
ok( $minimal_record->database_name( $values[0] ),
    'inherits database_name Mutator' );
ok( $minimal_record->schema_name( $values[0] ),
    'inherits schema_name Mutator' );
ok( $minimal_record->table_name( $values[0] ),
    'inherits table_name Mutator' );
ok( $minimal_record->column_name( $values[0] ),
    'inherits column_name Mutator' );
ok( $minimal_record->add_or_update_database, "Can update database" );
ok( $minimal_record->column_name('Column2'), "Can use column_name mutator" );
is( $minimal_record->column_name, 'Column2', "Column_name accessor" );
ok( $minimal_record->add_or_update_database, "Can update database" );
ok( $minimal_record->delete_db,  "Removed all traces of database" );
ok( $minimal_record->delete_srv, "Removed Server record" );

undef($@);
eval {
    my $db1
        = Catalogue::Importer::Database->new( server_name => 'TestServer' );
};
ok( $@, "Can't create database with just a server name" );
undef($@);
eval {
    my $db2 = Catalogue::Importer::Database::Importer->new(
        {   server_name   => 'TestServer',
            database_name => 'DBName'
        }
    );
};
ok( $@, "Can't create database with just a server and database name" );
undef($@);
eval {
    my $db2 = Catalogue::Importer::Database::Importer->new(
        {   server_name   => 'TestServer',
            database_name => 'DBName',
            schema_name   => 'Schema1'
        }
    );
};
ok( $@,
    "Can't create database with just a server, database and schema name" );
undef($@);
eval {
    my $db2 = Catalogue::Importer::Database::Importer->new(
        {   server_name   => 'TestServer',
            database_name => 'DBName',
            schema_name   => 'Schema1',
            table_name    => 'Table1'
        }
    );
};
ok( $@,
    "Can't create database with just a server, database, schema, and table name"
);
SKIP: {
    skip "to be implemented", 1;

    my $db5 = Catalogue::Importer::Database::Importer->new(
        server_name   => 'TestServer',
        database_name => 'DBName',
        schema_name   => 'SchemaName',
        table_name    => 'TableName',
        column_name   => 'Column1'
    );
    ok( $db5->add_or_update_database, "Can add database" );
    ok( !$db5->error_msg,             "No Error Message Set" );
    ok( $db5->delete_db,              "Removed all traces of database" );
    ok( $db5->delete_srv,             "Removed Server record" );

}

done_testing();
