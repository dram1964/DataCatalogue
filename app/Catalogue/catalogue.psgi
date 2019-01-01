use strict;
use warnings;

use Catalogue;

my $app = Catalogue->apply_default_middlewares(Catalogue->psgi_app);
$app;

