use Test::More;
use Catalogue::Schema;

my $dsn = "dbi:mysql:catalogue_test";
my $connection
    = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );
my $lab_rs = $connection->resultset('WpLaboratory');

BEGIN { use_ok 'Catalogue::Importer::Winpath::Laboratory' }

ok( my $lab = Catalogue::Importer::Winpath::Laboratory->new(
        code       => 'BZ',
        discipline => 'Special Biochemistry',
        cluster    => 'Biochemistry',
        specialty  => 'Biochemistry',
    ),
    "Laboratory Constructor"
);

is( $lab->code,       'BZ',                   "Code accessor" );
is( $lab->discipline, 'Special Biochemistry', "Discipline Accessor" );
is( $lab->cluster,    'Biochemistry',         "Cluster Accessor" );
is( $lab->specialty,  'Biochemistry',         "Specialty Accessor" );

ok( $lab->update_or_add, "Can add laboratory record" );

ok( $lab->specialty('Neuroimmunology'), "Update the Specialty" );
ok( $lab->update_or_add,                "Can update the record" );

my $count = $lab_rs->search( { code => 'BZ' } )->count();
cmp_ok( $count, '==', 1, "Only one record for updated lab code" );

ok( $lab->delete, "Can delete laboratory record" );
$count = $lab_rs->search( { code => 'BZ' } )->count();
cmp_ok( $count, "==", 0, "Record no longer exists in database" );

done_testing();
