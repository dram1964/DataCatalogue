use Test::More;
use Catalogue::Schema;

my $dsn = "dbi:mysql:catalogue_test";
my $connection
    = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );
my $test_rs = $connection->resultset('WpTest');

BEGIN { use_ok 'Catalogue::Importer::Winpath::TestCode' }

ok( my $test = Catalogue::Importer::Winpath::TestCode->new(
        code            => 'WCC',
        name            => 'White Cells',
        laboratory_code => 'BA',
        units           => 'm/mol',
        function        => 'xsi',
        flags           => 'xx',
        report_section  => 'X',
        line_number     => '23'
    ),
    "TestCode Constructor"
);

is( $test->code,            'WCC',         "Code accessor" );
is( $test->name,            'White Cells', "Name Accessor" );
is( $test->laboratory_code, 'BA',          "Laboratory Code Accessor" );
is( $test->units,           'm/mol',       "Units accessor" );
is( $test->function,        'xsi',         "Function accessor" );
is( $test->flags,           'xx',          "flags accessor" );
is( $test->report_section,  'X',           "Report Section accessor" );
is( $test->line_number,     '23',          "Line Number accessor" );

ok( $test->update_or_add, "Can add order record" );

ok( $test->name('White Cell Count'), "Update the Description" );
ok( $test->update_or_add,            "Can update the record" );

my $count
    = $test_rs->search( { code => 'WCC', laboratory_code => 'BA' } )->count();
cmp_ok( $count, '==', 1, "Only one record for updated test code" );

ok( $test->delete, "Can delete test record" );
$count
    = $test_rs->search( { code => 'WCC', laboratory_code => 'BA' } )->count();
cmp_ok( $count, "==", 0, "Record no longer exists in database" );

done_testing();
