use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Datasets;

ok( request('/datasets')->is_success, 'Request should succeed' );
done_testing();
