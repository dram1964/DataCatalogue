use Test::More;
use Catalogue::Importer::Application;

my $app1 = Catalogue::Importer::Application->new(
    kpe              => 'CDR',
    erid             => 'Core',
    category2        => 'Core Clinical',
    supplier         => 'CGI',
    application      => 'CDR Web',
    application_desc => 'ablaskj'
);

ok( $app1->kpe, 'KPE Accessor' );
cmp_ok( $app1->kpe, 'eq', 'CDR', "KPE Value" );
ok( $app1->erid, 'ERID Accessor' );
cmp_ok( $app1->erid, 'eq', 'Core', 'ERID Value' );
ok( $app1->category2, 'Category2 Accessor' );
cmp_ok( $app1->category2, 'eq', 'Core Clinical', 'Category2 Value' );
ok( $app1->supplier, 'Supplier Accessor' );
cmp_ok( $app1->supplier, 'eq', 'CGI', 'Supplier Value' );
ok( $app1->application, 'Application Accessor' );
cmp_ok( $app1->application, 'eq', 'CDR Web', 'Application Value' );
ok( $app1->application_desc, 'Application Description Accessor' );
cmp_ok( $app1->application_desc, 'eq', 'ablaskj',
    'Application Description Value' );

ok( $app1->add_or_update_application, "Can insert System Application" );
ok( $app1->delete_application,        "Can delete added application" );

done_testing();
