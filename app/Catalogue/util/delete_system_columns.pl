use Catalogue::Systems::Importer;

my $system = 'USQL2vDWH';

my $importer = Catalogue::Systems::Importer->new(system_name => $system);

$importer->delete_all;
