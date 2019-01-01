use strict;
use warnings;
use Test::More;
use Catalogue::Schema;
use Data::Dumper;

my $dsn = "dbi:mysql:catalogue_test";
my $schema = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );

SKIP: {
    skip "Requires data to be uploaded before these tests will work", 1;

    my $id = 769;

    ok( my $column = $schema->resultset('CColumn')->find($id),
        "Column Requested" );
    my $column_name   = $column->name;
    my $table_name    = $column->tbl->name;
    my $schema_name   = $column->tbl->schema->name;
    my $database_name = $column->tbl->schema->database->name;
    my $system_name   = $column->tbl->schema->database->system->name;

    my $query_rs = $schema->resultset('CColumn')->search(
        { 'me.col_id' => $id },
        {   select => [
                qw(me.name me.col_type me.col_size
                    tbl.name sch.name db.name)
            ],
            as => [
                qw(col_name col_type col_size
                    table_name schema_name database_name)
            ],
            join     => { 'tbl' => { 'sch' => 'db' } },
            prefetch => { 'tbl' => { 'sch' => 'db' } }
        }
    );
    my $query = $query_rs->first;

    is( $query->get_column('col_name'), $column_name, "Column Name matched" );
    is( $query->get_column('table_name'), $table_name, "Table Name matched" );
    is( $query->get_column('schema_name'),
        $schema_name, "Schema Name matched" );
    is( $query->get_column('database_name'),
        $database_name, "Database Name matched" );
    is( $query->get_column('system_name'),
        $system_name, "System Name matched" );
}
done_testing();

