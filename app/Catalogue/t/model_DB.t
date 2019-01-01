use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalogue::Model::DB' }

my $model = Catalogue::Model::DB->new();

isa_ok( $model, 'Catalyst::Model::DBIC::Schema' );

done_testing();
