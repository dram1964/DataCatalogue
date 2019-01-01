use Test::More;
use Catalogue::Schema;

my $dsn = "dbi:mysql:catalogue_test";
my $connection
    = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );
my $order_rs = $connection->resultset('WpOrder');

BEGIN { use_ok 'Catalogue::Importer::Winpath::OrderCode' }

ok( my $order = Catalogue::Importer::Winpath::OrderCode->new(
        code            => 'FBC',
        type            => 'G',
        description     => 'Full Blood Count',
        laboratory_code => 'BA',
    ),
    "OrderCode Constructor"
);

is( $order->code,            'FBC',              "Code accessor" );
is( $order->type,            'G',                "Type Accessor" );
is( $order->description,     'Full Blood Count', "Desription Accessor" );
is( $order->laboratory_code, 'BA',               "Laboratory Code Accessor" );

ok( $order->update_or_add, "Can add order record" );

ok( $order->description('Blood Count'), "Update the Description" );
ok( $order->update_or_add,              "Can update the record" );

my $count = $order_rs->search( { code => 'FBC' } )->count();
cmp_ok( $count, '==', 1, "Only one record for updated order code" );

ok( $order->delete, "Can delete order record" );
$count = $order_rs->search( { code => 'FBC' } )->count();
cmp_ok( $count, "==", 0, "Record no longer exists in database" );

done_testing();
