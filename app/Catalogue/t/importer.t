use Test::More;
use Catalogue::Importer;

ok( my $importer = Catalogue::Importer->new );
isa_ok( $importer, 'Catalogue::Importer' );

ok( $importer->schema, "Schema accessor" );

done_testing();
